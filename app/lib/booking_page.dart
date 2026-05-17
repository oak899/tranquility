import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consultation_forms.dart';
import 'tranquility_api.dart';

/// In-app visit booking (replaces opening the Order Online Hub visit URL in a browser).
/// Reference flow: https://www.orderonlinehub.com/servicesnostaff/tranquilityhydrotherapy_hf8w7q93ghgf8926q3vr9q2g8vrt6gq

/// Matches [TranquilityApp] theme constants in `main.dart`.
const Color _kGold = Color(0xFFC49B63);
const Color _kCharcoal = Color(0xFF1A1A1A);
const Color _kCream = Color(0xFFF8F5F0);

const String _kPrefsKey = 'tranquility_local_booking_requests_v1';

void openTranquilityBooking(BuildContext context) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const TranquilityBookingPage(),
    ),
  );
}

class BookingRequest {
  const BookingRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.visitAt,
    required this.createdAt,
  });

  final String name;
  final String phone;
  final String email;
  /// Preferred visit date & time chosen on the form.
  final DateTime visitAt;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'phone': phone,
        'email': email,
        'visitAt': visitAt.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  static BookingRequest fromJson(Map<String, dynamic> json) {
    final DateTime created = DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now();
    final DateTime? visit = DateTime.tryParse(json['visitAt'] as String? ?? '');
    return BookingRequest(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      visitAt: visit ?? created,
      createdAt: created,
    );
  }
}

class BookingLocalStore {
  static Future<List<BookingRequest>> loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_kPrefsKey);
    if (raw == null || raw.isEmpty) return <BookingRequest>[];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(BookingRequest.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <BookingRequest>[];
    }
  }

  static Future<void> append(BookingRequest request) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<BookingRequest> existing = await loadAll();
    final List<BookingRequest> next = <BookingRequest>[request, ...existing];
    final String encoded = jsonEncode(next.map((BookingRequest e) => e.toJson()).toList());
    await prefs.setString(_kPrefsKey, encoded);
  }
}

class TranquilityBookingPage extends StatefulWidget {
  const TranquilityBookingPage({super.key});

  @override
  State<TranquilityBookingPage> createState() => _TranquilityBookingPageState();
}

class _TranquilityBookingPageState extends State<TranquilityBookingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  bool _submitting = false;
  List<BookingRequest> _history = <BookingRequest>[];

  late DateTime _visitSlot;

  static final RegExp _emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final DateFormat _visitDateFmt = DateFormat.yMMMEd();
  static final DateFormat _visitTimeFmt = DateFormat.jm();

  @override
  void initState() {
    super.initState();
    final DateTime base = DateTime.now().add(const Duration(days: 1));
    _visitSlot = DateTime(base.year, base.month, base.day, 10, 0);
    _refreshHistory();
  }

  Future<void> _refreshHistory() async {
    final List<BookingRequest> list = await BookingLocalStore.loadAll();
    if (mounted) setState(() => _history = list);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    final String t = v?.trim() ?? '';
    if (t.length < 2) return 'Please enter your name.';
    return null;
  }

  String? _validatePhone(String? v) {
    final String digits = RegExp(r'\d').allMatches(v ?? '').map((Match m) => m.group(0)!).join();
    if (digits.length < 10) return 'Enter a valid phone number (at least 10 digits).';
    return null;
  }

  String? _validateEmail(String? v) {
    final String t = (v ?? '').trim();
    if (!_emailOk.hasMatch(t)) return 'Enter a valid email address.';
    return null;
  }

  Future<void> _pickVisitDate() async {
    final DateTime now = DateTime.now();
    final DateTime first = DateTime(now.year, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitSlot,
      firstDate: first,
      lastDate: first.add(const Duration(days: 370)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _kGold, onPrimary: _kCharcoal, surface: _kCream),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() {
      _visitSlot = DateTime(picked.year, picked.month, picked.day, _visitSlot.hour, _visitSlot.minute);
    });
  }

  Future<void> _pickVisitTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _visitSlot.hour, minute: _visitSlot.minute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _kGold, onPrimary: _kCharcoal, surface: _kCream),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() {
      _visitSlot = DateTime(_visitSlot.year, _visitSlot.month, _visitSlot.day, picked.hour, picked.minute);
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    setState(() => _submitting = true);
    try {
      final DateTime now = DateTime.now();
      final BookingRequest req = BookingRequest(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        visitAt: _visitSlot,
        createdAt: now,
      );
      await TranquilityApi.submitAppointment(
        name: req.name,
        phone: req.phone,
        email: req.email,
        visitAt: req.visitAt,
      );
      await BookingLocalStore.append(req);
      await _refreshHistory();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully booked',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          backgroundColor: _kCharcoal,
        ),
      );
      Navigator.of(context).pop();
    } on TranquilityApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message, style: GoogleFonts.inter())),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save. Check your connection and try again.', style: GoogleFonts.inter()),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dateLine = _visitDateFmt.format(_visitSlot);
    final String timeLine = _visitTimeFmt.format(_visitSlot);

    return Scaffold(
      backgroundColor: _kCream,
      appBar: AppBar(
        title: Text('Book a visit', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, fontSize: 22)),
        backgroundColor: _kCharcoal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: <Widget>[
          Text(
            'Consultation forms',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _kCharcoal,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Complete an intake before your visit — saved on this device like your booking request.',
            style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: const Color(0xFF78716C)),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _kGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.spa_outlined, color: _kCharcoal),
              ),
              title: Text('Facial consultation', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
              subtitle: Text('Skin assessment & service intake', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF78716C))),
              trailing: const Icon(Icons.chevron_right_rounded, color: _kGold),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (BuildContext context) => const FacialConsultationPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _kGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop_outlined, color: _kCharcoal),
              ),
              title: Text('Head spa consultation', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
              subtitle: Text('Preferences & scalp care intake', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF78716C))),
              trailing: const Icon(Icons.chevron_right_rounded, color: _kGold),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (BuildContext context) => const HeadSpaConsultationPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Reserve your visit',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: _kCharcoal,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kGold.withOpacity(0.35)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Date & time',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: const Color(0xFF78716C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today_rounded, size: 18, color: _kGold.withOpacity(0.9)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateLine,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: _kCharcoal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Icon(Icons.schedule_rounded, size: 18, color: _kGold.withOpacity(0.9)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          timeLine,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: _kCharcoal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickVisitDate,
                          icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                          label: Text('Change date', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _kCharcoal,
                            side: BorderSide(color: _kGold.withOpacity(0.55)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickVisitTime,
                          icon: const Icon(Icons.access_time_rounded, size: 18),
                          label: Text('Change time', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _kCharcoal,
                            side: BorderSide(color: _kGold.withOpacity(0.55)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This in-app form replaces the previous online booking link. '
            'Tell us how to reach you; your request is stored only on this device until we connect a live scheduler.',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: const Color(0xFF57534E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Inspired by the prior Order Online Hub flow.',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.4,
              color: const Color(0xFF78716C),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 22),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Full name'),
                  validator: _validateName,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration('Phone number'),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: _fieldDecoration('Email'),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: _kCharcoal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.2, color: _kCharcoal),
                        )
                      : Text('Booking request', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          if (_history.isNotEmpty) ...<Widget>[
            const SizedBox(height: 28),
            Text(
              'Saved on this device',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: _kCharcoal),
            ),
            const SizedBox(height: 8),
            Text(
              '${_history.length} request${_history.length == 1 ? '' : 's'} (newest first)',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF78716C)),
            ),
            const SizedBox(height: 12),
            ..._history.take(8).map(
                  (BookingRequest r) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(r.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${_visitDateFmt.format(r.visitAt)} · ${_visitTimeFmt.format(r.visitAt)}\n'
                        '${r.phone}\n${r.email}',
                        style: GoogleFonts.inter(fontSize: 13, height: 1.35),
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        _shortDate(r.createdAt),
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF78716C)),
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  String _shortDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: const Color(0xFF57534E)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kGold, width: 1.4),
      ),
    );
  }
}
