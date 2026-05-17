#!/usr/bin/env python3
"""Mirror https://tranquilityhydrotherapy.com/ into ../web2 (static copy for local hosting)."""

from __future__ import annotations

import argparse
import html
import os
import re
import shutil
import subprocess
import sys
from html.parser import HTMLParser
from urllib.parse import urljoin, urlparse, urlunparse

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_BASE = "https://tranquilityhydrotherapy.com/"
ALLOWED_NETLOCS = {"tranquilityhydrotherapy.com", "www.tranquilityhydrotherapy.com"}


def netloc_ok(netloc: str) -> bool:
    n = netloc.lower().split("@")[-1]
    return n in ALLOWED_NETLOCS or n == ""


def normalize_url(raw: str, base: str) -> str | None:
    raw = raw.strip()
    if not raw or raw.startswith("#") or raw.lower().startswith("javascript:"):
        return None
    if raw.startswith("//"):
        raw = "https:" + raw
    u = urljoin(base, raw)
    p = urlparse(u)
    if p.scheme not in ("http", "https", ""):
        return None
    if not netloc_ok(p.netloc):
        return None
    p = p._replace(fragment="", scheme="https", netloc="tranquilityhydrotherapy.com")
    return urlunparse(p)


def curl_bytes(url: str) -> bytes:
    r = subprocess.run(
        ["curl", "-fsSL", "--compressed", "-A", "Mozilla/5.0 (compatible; TranquilityMirror/2.0)", url],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if r.returncode != 0:
        raise RuntimeError(f"curl failed {url}: {r.stderr.decode(errors='replace')[:500]}")
    return r.stdout


def fs_path_for_url(url: str, web_root: str) -> str:
    path = urlparse(url).path or "/"
    if path.endswith("/"):
        path = path + "index.html"
    rel = path.lstrip("/")
    if not rel:
        rel = "index.html"
    return os.path.join(web_root, rel)


def ensure_parent(path: str) -> None:
    d = os.path.dirname(path)
    if d:
        os.makedirs(d, exist_ok=True)


class LinkHTMLParser(HTMLParser):
    def __init__(self, base_url: str):
        super().__init__()
        self.base_url = base_url
        self.out: list[str] = []

    def feed_links(self, html_text: str) -> list[str]:
        self.out = []
        self.feed(html_text)
        return self.out

    def _push_attr(self, attrs: list[tuple[str, str | None]], name: str) -> None:
        for k, v in attrs:
            if k.lower() == name and v:
                n = normalize_url(v, self.base_url)
                if n:
                    self.out.append(n)

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        t = tag.lower()
        if t in ("a", "link", "area"):
            self._push_attr(attrs, "href")
        if t in ("img", "script", "iframe", "source", "video", "audio", "embed"):
            self._push_attr(attrs, "src")
        if t in ("img", "source", "video"):
            self._push_attr(attrs, "srcset")
            self._push_attr(attrs, "poster")
        for k, v in attrs:
            if k.lower() == "style" and v:
                for u in extract_css_urls(html.unescape(v), self.base_url):
                    self.out.append(u)

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self.handle_starttag(tag, attrs)


def extract_css_urls(css_text: str, base_url: str) -> list[str]:
    found: list[str] = []
    for m in re.finditer(r"url\s*\(\s*([^)]+?)\s*\)", css_text, flags=re.I):
        raw = m.group(1).strip().strip('"').strip("'")
        if raw.startswith("data:") or raw.startswith("#"):
            continue
        n = normalize_url(raw, base_url)
        if n:
            found.append(n)
    return found


def extract_html_urls(html_text: str, base_url: str) -> list[str]:
    p = LinkHTMLParser(base_url)
    urls = p.feed_links(html_text)
    for part in re.findall(r"srcset\s*=\s*[\"']([^\"']+)[\"']", html_text, flags=re.I):
        for chunk in part.split(","):
            u = chunk.strip().split()[0] if chunk.strip() else ""
            n = normalize_url(u, base_url)
            if n:
                urls.append(n)
    return urls


def extract_js_local_urls(js_text: str, base_url: str, site_base: str) -> list[str]:
    out: list[str] = []
    for m in re.finditer(r"""['"]((?:\./|\.\./)?(?:images|videos|assets)/[^'"]+)['"]""", js_text):
        raw = m.group(1)
        join_base = site_base if raw.startswith(("images/", "./images/", "videos/", "./videos/")) else base_url
        n = normalize_url(raw, join_base)
        if n:
            out.append(n)
    return out


def is_probably_text(path: str, content: bytes) -> bool:
    low = path.lower()
    if any(low.endswith(ext) for ext in (".html", ".htm", ".css", ".js", ".svg", ".txt", ".xml")):
        return True
    if b"\x00" in content[:2048]:
        return False
    return content[:200].isascii() and (b"<" in content[:200] or b"/*" in content[:200] or b"function" in content[:200])


def rewrite_site_domains(text: str) -> str:
    """Use relative paths so the mirror works offline from any host."""
    reps = [
        "https://www.tranquilityhydrotherapy.com",
        "http://www.tranquilityhydrotherapy.com",
        "https://tranquilityhydrotherapy.com",
        "http://tranquilityhydrotherapy.com",
        "//www.tranquilityhydrotherapy.com",
        "//tranquilityhydrotherapy.com",
    ]
    for r in reps:
        text = text.replace(r, "")
    return text


def mirror(web_root: str, base: str, clean: bool) -> int:
    seed_paths = [
        "/",
        "/index.html",
        "/services.html",
        "/aboutus.html",
        "/menu.html",
        "/giftcard.html",
        "/membership.html",
        "/faq.html",
        "/style.css",
        "/script.js",
        "/favicon.ico",
    ]
    seen: set[str] = set()
    queue: list[str] = []
    for sp in seed_paths:
        u = normalize_url(sp, base)
        if u and u not in seen:
            seen.add(u)
            queue.append(u)

    while queue:
        url = queue.pop(0)
        out_path = fs_path_for_url(url, web_root)
        try:
            data = curl_bytes(url)
        except Exception as e:
            print("skip", url, e, file=sys.stderr)
            continue
        ensure_parent(out_path)
        with open(out_path, "wb") as f:
            f.write(data)
        print("ok", url, "->", os.path.relpath(out_path, REPO_ROOT))

        if not is_probably_text(out_path, data):
            continue
        try:
            text = data.decode("utf-8")
        except UnicodeDecodeError:
            text = data.decode("utf-8", errors="replace")

        if out_path.lower().endswith((".html", ".htm")):
            for u in extract_html_urls(text, url):
                if u not in seen:
                    seen.add(u)
                    queue.append(u)
        if out_path.lower().endswith(".css"):
            for u in extract_css_urls(text, url):
                if u not in seen:
                    seen.add(u)
                    queue.append(u)
        if out_path.lower().endswith(".js"):
            for u in extract_js_local_urls(text, url, base):
                if u not in seen:
                    seen.add(u)
                    queue.append(u)

    for root, _, files in os.walk(web_root):
        for name in files:
            fp = os.path.join(root, name)
            if not fp.lower().endswith((".html", ".htm", ".css", ".js", ".svg")):
                continue
            with open(fp, "rb") as f:
                raw = f.read()
            try:
                t = raw.decode("utf-8")
            except UnicodeDecodeError:
                continue
            nt = rewrite_site_domains(t)
            if nt != t:
                with open(fp, "w", encoding="utf-8", newline="") as f:
                    f.write(nt)

    print("mirrored", len(seen), "urls into", web_root)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Mirror tranquilityhydrotherapy.com")
    parser.add_argument(
        "--out",
        default=os.path.join(REPO_ROOT, "web2"),
        help="Output directory (default: ../web2)",
    )
    parser.add_argument("--base", default=DEFAULT_BASE, help="Site base URL")
    parser.add_argument("--no-clean", action="store_true", help="Do not wipe output dir first")
    args = parser.parse_args()

    web_root = os.path.abspath(args.out)
    base = args.base if args.base.endswith("/") else args.base + "/"

    os.makedirs(web_root, exist_ok=True)
    if not args.no_clean and os.path.isdir(web_root):
        for name in os.listdir(web_root):
            path = os.path.join(web_root, name)
            if os.path.isdir(path):
                shutil.rmtree(path)
            else:
                os.remove(path)

    with open(os.path.join(web_root, ".gitignore"), "w", encoding="utf-8") as gf:
        gf.write(".vercel\n")

    return mirror(web_root, base, clean=not args.no_clean)


if __name__ == "__main__":
    raise SystemExit(main())
