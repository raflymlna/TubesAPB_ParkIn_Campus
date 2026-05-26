import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef PlateChanged = void Function(String plate);

class LicensePlateInput extends StatefulWidget {
  final PlateChanged? onChanged;
  final String? initial;

  const LicensePlateInput({Key? key, this.onChanged, this.initial})
    : super(key: key);

  @override
  State<LicensePlateInput> createState() => _LicensePlateInputState();
}

class _LicensePlateInputState extends State<LicensePlateInput> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();

  @override
  void initState() {
    super.initState();
    if ((widget.initial ?? '').isNotEmpty) _setFromInitial(widget.initial!);
    _c1.addListener(_emit);
    _c2.addListener(_emit);
    _c3.addListener(_emit);
  }

  void _setFromInitial(String s) {
    final parts = s.split(RegExp(r"\s+|-"));
    if (parts.isNotEmpty)
      _c1.text = parts.length > 0 ? parts[0].toUpperCase() : '';
    if (parts.length > 1) _c2.text = parts[1];
    if (parts.length > 2) _c3.text = parts[2].toUpperCase();
  }

  String _fullPlate() {
    final a = _c1.text.trim();
    final b = _c2.text.trim();
    final c = _c3.text.trim();
    final parts = [a, b, c].where((p) => p.isNotEmpty).toList();
    return parts.join(' ');
  }

  void _emit() {
    widget.onChanged?.call(_fullPlate());
    setState(() {});
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _f1.dispose();
    _f2.dispose();
    _f3.dispose();
    super.dispose();
  }

  TextInputFormatter _upperCaseLettersOnly() =>
      FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'));

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 12,
                child: _buildField(
                  controller: _c1,
                  focusNode: _f1,
                  maxLength: 2,
                  hint: 'B',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    _upperCaseLettersOnly(),
                    UpperCaseTextFormatter(),
                  ],
                  onComplete: () => _f2.requestFocus(),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 30,
                child: _buildField(
                  controller: _c2,
                  focusNode: _f2,
                  maxLength: 4,
                  hint: '1234',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onComplete: () => _f3.requestFocus(),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 20,
                child: _buildField(
                  controller: _c3,
                  focusNode: _f3,
                  maxLength: 3,
                  hint: 'AMN',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    _upperCaseLettersOnly(),
                    UpperCaseTextFormatter(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _fullPlate().isEmpty ? 'Preview: -' : _fullPlate(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required int maxLength,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onComplete,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        border: InputBorder.none,
        hintText: hint,
      ),
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      onChanged: (v) {
        // keep uppercase for letter fields
        if (inputFormatters != null &&
            inputFormatters.any((f) => f is UpperCaseTextFormatter)) {
          final up = v.toUpperCase();
          if (up != v) {
            controller.value = controller.value.copyWith(
              text: up,
              selection: TextSelection.collapsed(offset: up.length),
            );
          }
        }
        if (v.length >= maxLength) onComplete?.call();
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    return newValue.copyWith(text: upper, selection: newValue.selection);
  }
}
