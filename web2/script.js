/**
 * Interactive Script for Tranquility Hydrotherapy
 */

document.addEventListener("DOMContentLoaded", () => {
	/* ==========================================================
       1. HERO BACKGROUND SLIDER & DOT NAVIGATION LOGIC
       ========================================================== */
	const slides = document.querySelectorAll(".hero-slide");
	const dots = document.querySelectorAll(".slider-dot");
	let currentSlide = 0;
	let slideInterval;

	// Function to handle changing slides and updating dots
	function goToSlide(index) {
		// Hide current slide and update current dot
		slides[currentSlide].classList.remove("opacity-100");
		slides[currentSlide].classList.add("opacity-0");

		dots[currentSlide].classList.remove("bg-white", "scale-125");
		dots[currentSlide].classList.add("bg-white/50");

		// Update index
		currentSlide = index;

		// Show new slide and highlight new dot
		slides[currentSlide].classList.remove("opacity-0");
		slides[currentSlide].classList.add("opacity-100");

		dots[currentSlide].classList.remove("bg-white/50");
		dots[currentSlide].classList.add("bg-white", "scale-125");
	}

	// Function to move to the next slide
	function nextSlide() {
		let nextIndex = (currentSlide + 1) % slides.length;
		goToSlide(nextIndex);
	}

	// Initialize Slider if elements exist
	if (slides.length > 0) {
		// Start automatic sliding
		slideInterval = setInterval(nextSlide, 5000);

		// Add click event listeners to each dot
		dots.forEach((dot, index) => {
			dot.addEventListener("click", () => {
				// Clear the existing interval to prevent weird jumping
				clearInterval(slideInterval);

				// Go to the clicked slide
				goToSlide(index);

				// Restart the automatic sliding timer
				slideInterval = setInterval(nextSlide, 5000);
			});
		});
	}

	/* ==========================================================
       2. SCROLL REVEAL ANIMATIONS (Intersection Observer)
       ========================================================== */
	const revealElements = document.querySelectorAll(".reveal, .reveal-scale");

	const revealOptions = {
		threshold: 0.15,
		rootMargin: "0px 0px -50px 0px",
	};

	const revealOnScroll = new IntersectionObserver(function (entries, observer) {
		entries.forEach((entry) => {
			if (!entry.isIntersecting) {
				return;
			} else {
				entry.target.classList.add("active");
				observer.unobserve(entry.target);
			}
		});
	}, revealOptions);

	revealElements.forEach((el) => {
		revealOnScroll.observe(el);
	});

	// Initial trigger for hero background zoom effect
	const heroBgs = document.querySelectorAll(".reveal-scale");
	heroBgs.forEach((bg) => {
		setTimeout(() => bg.classList.add("active"), 100);
	});

	/* ==========================================================
       3. MOBILE MENU TOGGLE
       ========================================================== */
	const mobileMenuBtn = document.getElementById("mobileMenuBtn");
	const closeMenuBtn = document.getElementById("closeMenuBtn");
	const mobileMenu = document.getElementById("mobileMenu");
	const mobileLinks = document.querySelectorAll(".mobile-link");

	if (mobileMenuBtn) {
		mobileMenuBtn.addEventListener("click", () => {
			mobileMenu.classList.remove("translate-x-full");
		});
	}

	if (closeMenuBtn) {
		closeMenuBtn.addEventListener("click", () => {
			mobileMenu.classList.add("translate-x-full");
		});
	}

	mobileLinks.forEach((link) => {
		link.addEventListener("click", () => {
			mobileMenu.classList.add("translate-x-full");
		});
	});

	/* ==========================================================
       4. BACK TO TOP BUTTON LOGIC
       ========================================================== */
	const backToTopBtn = document.getElementById("backToTopBtn");

	if (backToTopBtn) {
		window.addEventListener("scroll", () => {
			if (window.scrollY > 400) {
				backToTopBtn.classList.add("btn-visible");
			} else {
				backToTopBtn.classList.remove("btn-visible");
			}
		});

		backToTopBtn.addEventListener("click", () => {
			window.scrollTo({
				top: 0,
				behavior: "smooth",
			});
		});
	}
});
