import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'tranquility_api.dart';

/// Aligns with [TranquilityApp] / booking styling.
const Color _cGold = Color(0xFFC49B63);
const Color _cCharcoal = Color(0xFF1A1A1A);
const Color _cCream = Color(0xFFF8F5F0);
const Color _cMuted = Color(0xFF57534E);
const Color _cSubtle = Color(0xFF78716C);

InputDecoration _inputDeco(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.inter(color: _cMuted),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _cGold, width: 1.4),
    ),
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 8),
    child: Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _cCharcoal,
        height: 1.15,
      ),
    ),
  );
}

Widget _fieldLabel(String s) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      s,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _cCharcoal,
        height: 1.35,
      ),
    ),
  );
}

Widget _multiChips({
  required Set<String> selected,
  required List<String> options,
  required void Function(String value, bool selected) onChanged,
}) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: options.map((String o) {
      final bool on = selected.contains(o);
      return FilterChip(
        label: Text(o, style: GoogleFonts.inter(fontSize: 12.5)),
        selected: on,
        onSelected: (bool v) => onChanged(o, v),
        selectedColor: _cGold.withOpacity(0.35),
        checkmarkColor: _cCharcoal,
        side: BorderSide(color: on ? _cGold : Colors.black.withOpacity(0.12)),
      );
    }).toList(),
  );
}

Widget _radioRow<T>({
  required T? groupValue,
  required List<T> values,
  required List<String> labels,
  required void Function(T?) onChanged,
}) {
  return Column(
    children: List<Widget>.generate(values.length, (int i) {
      return RadioListTile<T>(
        dense: true,
        contentPadding: EdgeInsets.zero,
        value: values[i],
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(labels[i], style: GoogleFonts.inter(fontSize: 14, color: _cMuted)),
      );
    }),
  );
}

/// Facial consultation — matches paper intake (Tranquility Hydrotherapy).
class FacialConsultationPage extends StatefulWidget {
  const FacialConsultationPage({super.key});

  @override
  State<FacialConsultationPage> createState() => _FacialConsultationPageState();
}

class _FacialConsultationPageState extends State<FacialConsultationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _q2Other = TextEditingController();
  final TextEditingController _q3Other = TextEditingController();
  final TextEditingController _q6Other = TextEditingController();
  final TextEditingController _signature = TextEditingController();

  DateTime? _serviceDate;
  DateTime? _signDate;

  static const List<String> _services = <String>[
    'ALGOMASK+ Customized Clinical Facial — 60 mins',
    'HYDROLIFTING Professional Treatment — 70 mins',
    'BOTINOL Treatment — 80 mins',
    'Oxygenating Professional Treatment — 70 mins',
    'Collagen-90 Clinical Treatment — 80 mins',
    'Facial & Scalp Hydrotherapy Combo',
  ];
  final Set<String> _servicesChosen = <String>{};

  static const List<String> _q1Opts = <String>['Dry', 'Oily', 'Combination', 'Sensitive', 'Normal'];
  final Set<String> _q1 = <String>{};

  static const List<String> _q2Opts = <String>[
    'Acne',
    'Blackheads / whiteheads',
    'Hyperpigmentation (dark spots)',
    'Broken capillaries',
    'Redness / sensitivity',
    'Dryness / flakiness',
    'Fine lines / wrinkles',
  ];
  final Set<String> _q2 = <String>{};

  static const List<String> _q3Opts = <String>[
    'Cleanser',
    'Toner',
    'Serum',
    'Moisturizer',
    'Sunscreen',
    'Makeup',
    'Exfoliator',
  ];
  final Set<String> _q3 = <String>{};

  String? _q4Makeup;
  String? _q5RegularFacials;
  final Set<String> _q6 = <String>{};
  static const List<String> _q6Opts = <String>[
    'Pregnant or nursing',
    'Skin disorders or contagious conditions',
    'Heart disease, diabetes, or other chronic conditions',
    'Recent laser treatments, peels, or cosmetic surgeries',
  ];

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _q2Other.dispose();
    _q3Other.dispose();
    _q6Other.dispose();
    _signature.dispose();
    super.dispose();
  }

  Future<void> _pickServiceDate() async {
    final DateTime now = DateTime.now();
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: _serviceDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (d != null) setState(() => _serviceDate = d);
  }

  Future<void> _pickSignDate() async {
    final DateTime now = DateTime.now();
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: _signDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (d != null) setState(() => _signDate = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final Map<String, dynamic> data = <String, dynamic>{
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim(),
      'serviceDate': _serviceDate?.toIso8601String(),
      'services': _servicesChosen.toList(),
      'skinType': _q1.toList(),
      'concerns': _q2.toList(),
      'concernsOther': _q2Other.text.trim(),
      'products': _q3.toList(),
      'productsOther': _q3Other.text.trim(),
      'makeupToday': _q4Makeup,
      'regularFacials': _q5RegularFacials,
      'conditions': _q6.toList(),
      'conditionsOther': _q6Other.text.trim(),
      'signature': _signature.text.trim(),
      'signDate': _signDate?.toIso8601String(),
    };
    try {
      await TranquilityApi.submitConsultation(kind: 'facial', payload: data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Consultation submitted', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          backgroundColor: _cCharcoal,
        ),
      );
      Navigator.of(context).pop();
    } on TranquilityApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message, style: GoogleFonts.inter())));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save. Check your connection.', style: GoogleFonts.inter())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat.yMMMd();
    return Scaffold(
      backgroundColor: _cCream,
      appBar: AppBar(
        title: Text('Facial consultation', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, fontSize: 20)),
        backgroundColor: _cCharcoal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 48,
                  child: SvgPicture.asset('assets/images/logo.svg', fit: BoxFit.contain),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Facial Consultation',
                        style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: _cCharcoal),
                      ),
                      Text(
                        'Client consultation form',
                        style: GoogleFonts.inter(fontSize: 14, color: _cSubtle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle("Client's information"),
            TextFormField(controller: _name, decoration: _inputDeco('Full name'), validator: (String? v) => (v == null || v.trim().length < 2) ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _phone, decoration: _inputDeco('Phone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextFormField(controller: _email, decoration: _inputDeco('Email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _fieldLabel('Service date'),
            OutlinedButton.icon(
              onPressed: _pickServiceDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(_serviceDate == null ? 'Choose date' : df.format(_serviceDate!), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(foregroundColor: _cCharcoal, side: BorderSide(color: _cGold.withOpacity(0.55)), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
            ),
            const SizedBox(height: 22),
            _sectionTitle('Service you booked'),
            _fieldLabel('Select all that apply'),
            _multiChips(
              selected: _servicesChosen,
              options: _services,
              onChanged: (String v, bool sel) => setState(() {
                if (sel) {
                  _servicesChosen.add(v);
                } else {
                  _servicesChosen.remove(v);
                }
              }),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Skin assessment'),
            _fieldLabel('Q1 · Skin type (select all that apply)'),
            _multiChips(selected: _q1, options: _q1Opts, onChanged: (String v, bool s) => setState(() => s ? _q1.add(v) : _q1.remove(v))),
            const SizedBox(height: 14),
            _fieldLabel('Q2 · Current skin concerns (select all that apply)'),
            _multiChips(selected: _q2, options: _q2Opts, onChanged: (String v, bool s) => setState(() => s ? _q2.add(v) : _q2.remove(v))),
            TextFormField(controller: _q2Other, decoration: _inputDeco('Other (please specify)')),
            const SizedBox(height: 14),
            _fieldLabel('Q3 · Do you currently use any of the following?'),
            _multiChips(selected: _q3, options: _q3Opts, onChanged: (String v, bool s) => setState(() => s ? _q3.add(v) : _q3.remove(v))),
            TextFormField(controller: _q3Other, decoration: _inputDeco('Other products (specify)')),
            const SizedBox(height: 14),
            _fieldLabel('Q4 · Are you wearing makeup today?'),
            _radioRow<String>(
              groupValue: _q4Makeup,
              values: const <String>['none', 'light', 'full'],
              labels: const <String>['No makeup', 'Light makeup', 'Full makeup'],
              onChanged: (String? v) => setState(() => _q4Makeup = v),
            ),
            const SizedBox(height: 8),
            _fieldLabel('Q5 · Do you receive facials regularly?'),
            _radioRow<String>(
              groupValue: _q5RegularFacials,
              values: const <String>['yes', 'no'],
              labels: const <String>['Yes', 'No'],
              onChanged: (String? v) => setState(() => _q5RegularFacials = v),
            ),
            const SizedBox(height: 8),
            _fieldLabel('Q6 · Do you have any of the following conditions? (If yes, please specify)'),
            _multiChips(selected: _q6, options: _q6Opts, onChanged: (String v, bool s) => setState(() => s ? _q6.add(v) : _q6.remove(v))),
            TextFormField(controller: _q6Other, decoration: _inputDeco('Other (specify)')),
            const SizedBox(height: 22),
            _sectionTitle('Disclaimer'),
            Text(
              'I confirm that the information provided above is true and accurate. I understand that my esthetician will use this information to create a treatment plan suitable for my skin condition and health status.',
              style: GoogleFonts.inter(fontSize: 13, height: 1.5, color: _cMuted),
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _signature, decoration: _inputDeco('Client signature (type your name)')),
            const SizedBox(height: 12),
            _fieldLabel('Date'),
            OutlinedButton.icon(
              onPressed: _pickSignDate,
              icon: const Icon(Icons.edit_calendar_outlined, size: 18),
              label: Text(_signDate == null ? 'Choose date' : df.format(_signDate!), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(foregroundColor: _cCharcoal, side: BorderSide(color: _cGold.withOpacity(0.55)), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: _cGold,
                foregroundColor: _cCharcoal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.2, color: _cCharcoal))
                  : Text('Submit consultation', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Head spa & skin care — client consultation form.
class HeadSpaConsultationPage extends StatefulWidget {
  const HeadSpaConsultationPage({super.key});

  @override
  State<HeadSpaConsultationPage> createState() => _HeadSpaConsultationPageState();
}

class _HeadSpaConsultationPageState extends State<HeadSpaConsultationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _q8Other = TextEditingController();
  final TextEditingController _q9Specify = TextEditingController();
  final TextEditingController _q12Other = TextEditingController();

  DateTime? _serviceDate;

  static const List<String> _services = <String>[
    'Facial & Scalp Hydrotherapy — 60 mins',
    'Facial & Relaxing Scalp Hydrotherapy — 90 mins',
    'Relaxing Scalp Hydrotherapy — 60 mins',
    'Relaxing & Hydrating Scalp Hydrotherapy — 90 mins',
    'Treatment — hair loss / dandruff / sensitive',
    'Professional skincare',
  ];
  final Set<String> _servicesChosen = <String>{};
  final Set<String> _addons = <String>{};

  String? _q1Experience;
  String? _q2Forehead;
  String? _q3Pressure;
  String? _q4Rhythm;
  String? _q5Water;
  String? _q6Steam;
  String? _q7Scent;
  final Set<String> _q8Scalp = <String>{};
  static const List<String> _q8Opts = <String>[
    'Dandruff',
    'Itchiness',
    'Oily scalp',
    'Dry scalp',
    'Hair loss',
    'Sensitive scalp',
  ];
  String? _q9Allergies;
  String? _q10Health;
  String? _q11Dryness;
  String? _q12Referral;

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _q8Other.dispose();
    _q9Specify.dispose();
    _q12Other.dispose();
    super.dispose();
  }

  Future<void> _pickServiceDate() async {
    final DateTime now = DateTime.now();
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: _serviceDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (d != null) setState(() => _serviceDate = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final Map<String, dynamic> data = <String, dynamic>{
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim(),
      'serviceDate': _serviceDate?.toIso8601String(),
      'services': _servicesChosen.toList(),
      'addons': _addons.toList(),
      'q1': _q1Experience,
      'q2_foreheadMassage': _q2Forehead,
      'q3_pressure': _q3Pressure,
      'q4_rhythm': _q4Rhythm,
      'q5_water': _q5Water,
      'q6_steamEye': _q6Steam,
      'q7_scent': _q7Scent,
      'q8_scalp': _q8Scalp.toList(),
      'q8_other': _q8Other.text.trim(),
      'q9_allergies': _q9Allergies,
      'q9_specify': _q9Specify.text.trim(),
      'q10_pregnancyOrUnder18': _q10Health,
      'q11_blowDry': _q11Dryness,
      'q12_referral': _q12Referral,
      'q12_other': _q12Other.text.trim(),
    };
    try {
      await TranquilityApi.submitConsultation(kind: 'head_spa', payload: data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultation submitted', style: GoogleFonts.inter(fontWeight: FontWeight.w600)), backgroundColor: _cCharcoal),
      );
      Navigator.of(context).pop();
    } on TranquilityApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message, style: GoogleFonts.inter())));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save. Check your connection.', style: GoogleFonts.inter())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat.yMMMd();
    return Scaffold(
      backgroundColor: _cCream,
      appBar: AppBar(
        title: Text('Head spa consultation', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, fontSize: 20)),
        backgroundColor: _cCharcoal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 72, height: 48, child: SvgPicture.asset('assets/images/logo.svg', fit: BoxFit.contain)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Head spa & skin care', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: _cCharcoal)),
                      Text('Client consultation form', style: GoogleFonts.inter(fontSize: 14, color: _cSubtle)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle("Client's information"),
            TextFormField(controller: _name, decoration: _inputDeco('Full name'), validator: (String? v) => (v == null || v.trim().length < 2) ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _phone, decoration: _inputDeco('Phone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextFormField(controller: _email, decoration: _inputDeco('Email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _fieldLabel('Service date'),
            OutlinedButton.icon(
              onPressed: _pickServiceDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(_serviceDate == null ? 'Choose date' : df.format(_serviceDate!), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(foregroundColor: _cCharcoal, side: BorderSide(color: _cGold.withOpacity(0.55)), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
            ),
            const SizedBox(height: 22),
            _sectionTitle('Service you booked'),
            _multiChips(selected: _servicesChosen, options: _services, onChanged: (String v, bool s) => setState(() => s ? _servicesChosen.add(v) : _servicesChosen.remove(v))),
            const SizedBox(height: 14),
            _fieldLabel('Enhancement add-ons (optional)'),
            _multiChips(
              selected: _addons,
              options: const <String>['Hand mask — \$20', 'Foot mask — \$20'],
              onChanged: (String v, bool s) => setState(() => s ? _addons.add(v) : _addons.remove(v)),
            ),
            const SizedBox(height: 20),
            Text(
              'To provide you with the best personalized head spa experience, please help us understand your preferences and needs:',
              style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: _cMuted, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            _fieldLabel('Q1 · Previous experience'),
            _radioRow<String>(
              groupValue: _q1Experience,
              values: const <String>['here', 'elsewhere', 'first'],
              labels: const <String>['Yes, at Tranquility Hydrotherapy', 'Yes, but at another spa', 'No, this is my first time'],
              onChanged: (String? v) => setState(() => _q1Experience = v),
            ),
            _fieldLabel('Q2 · Forehead massage'),
            _radioRow<String>(groupValue: _q2Forehead, values: const <String>['yes', 'no'], labels: const <String>['Yes', 'No'], onChanged: (String? v) => setState(() => _q2Forehead = v)),
            _fieldLabel('Q3 · Massage pressure'),
            _radioRow<String>(
              groupValue: _q3Pressure,
              values: const <String>['light', 'medium', 'strong'],
              labels: const <String>['Light', 'Medium', 'Strong'],
              onChanged: (String? v) => setState(() => _q3Pressure = v),
            ),
            _fieldLabel('Q4 · Massage rhythm'),
            _radioRow<String>(
              groupValue: _q4Rhythm,
              values: const <String>['slow', 'med', 'fast'],
              labels: const <String>['Slow', 'Medium', 'Fast'],
              onChanged: (String? v) => setState(() => _q4Rhythm = v),
            ),
            _fieldLabel('Q5 · Water temperature'),
            _radioRow<String>(
              groupValue: _q5Water,
              values: const <String>['98', '100', '102', '104'],
              labels: const <String>['98°F (slightly cool)', '100°F (comfortable)', '102°F (slightly warm)', '104°F (hot)'],
              onChanged: (String? v) => setState(() => _q5Water = v),
            ),
            _fieldLabel('Q6 · Steam eye mask'),
            _radioRow<String>(groupValue: _q6Steam, values: const <String>['yes', 'no'], labels: const <String>['Yes', 'No'], onChanged: (String? v) => setState(() => _q6Steam = v)),
            _fieldLabel('Q7 · Essential oil scent'),
            _radioRow<String>(
              groupValue: _q7Scent,
              values: const <String>['tangerine', 'lemongrass', 'lavender', 'bergamot'],
              labels: const <String>['Tangerine', 'Lemongrass', 'Lavender', 'Bergamot'],
              onChanged: (String? v) => setState(() => _q7Scent = v),
            ),
            _fieldLabel('Q8 · Scalp concerns (select all that apply)'),
            _multiChips(selected: _q8Scalp, options: _q8Opts, onChanged: (String v, bool s) => setState(() => s ? _q8Scalp.add(v) : _q8Scalp.remove(v))),
            TextFormField(controller: _q8Other, decoration: _inputDeco('Other (specify)')),
            _fieldLabel('Q9 · Allergies or sensitivities'),
            _radioRow<String>(groupValue: _q9Allergies, values: const <String>['yes', 'no'], labels: const <String>['Yes (specify below)', 'No'], onChanged: (String? v) => setState(() => _q9Allergies = v)),
            TextFormField(controller: _q9Specify, decoration: _inputDeco('If yes, please specify')),
            _fieldLabel('Q10 · Pregnancy or under 18'),
            _radioRow<String>(groupValue: _q10Health, values: const <String>['yes', 'no'], labels: const <String>['Yes', 'No'], onChanged: (String? v) => setState(() => _q10Health = v)),
            _fieldLabel('Q11 · Post-service hair dryness'),
            _radioRow<String>(
              groupValue: _q11Dryness,
              values: const <String>['100', '80', '50', 'none'],
              labels: const <String>['100% dry', '80% dry', '50% dry', 'No blow dry'],
              onChanged: (String? v) => setState(() => _q11Dryness = v),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Blow-drying is included within your service time for natural drying only. We do not provide styling, straightening, or curling.',
                style: GoogleFonts.inter(fontSize: 12, height: 1.45, color: _cSubtle),
              ),
            ),
            _fieldLabel('Q12 · How did you hear about us?'),
            _radioRow<String>(
              groupValue: _q12Referral,
              values: const <String>['google', 'facebook', 'instagram', 'tiktok', 'friend', 'email', 'other'],
              labels: const <String>['Google', 'Facebook', 'Instagram', 'TikTok', 'Friend or family', 'Email or newsletter', 'Other'],
              onChanged: (String? v) => setState(() => _q12Referral = v),
            ),
            TextFormField(controller: _q12Other, decoration: _inputDeco('If other, specify')),
            const SizedBox(height: 20),
            Text(
              'Thank you for completing this form! Your preferences will help us deliver a relaxing and customized experience.',
              style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: _cMuted),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: _cGold,
                foregroundColor: _cCharcoal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.2, color: _cCharcoal))
                  : Text('Submit consultation', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
