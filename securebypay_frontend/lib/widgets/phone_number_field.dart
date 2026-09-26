import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/country.dart';

/// A single merged input — matching the Figma design exactly — that
/// combines a country dial-code picker ("+234 ⌄") with the phone
/// number field inside one bordered box, instead of two separate
/// input boxes side by side.
class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final Country initialCountry;
  final ValueChanged<Country> onCountryChanged;
  final String? errorText;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.onCountryChanged,
    this.initialCountry = kDefaultCountry,
    this.errorText,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late Country _selected = widget.initialCountry;
  bool _focused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final picked = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _CountryPickerSheet(selected: _selected),
    );
    if (picked != null) {
      setState(() => _selected = picked);
      widget.onCountryChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.errorText != null
                  ? AppColors.danger
                  : (_focused ? AppColors.primaryPurple : AppColors.inputBorder),
              width: _focused ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              InkWell(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                onTap: _pickCountry,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selected.flagEmoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(_selected.dialCode, style: AppTextStyles.body),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              Container(height: 24, width: 1, color: AppColors.inputBorder),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: '8012345678',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(widget.errorText!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
        ],
      ],
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final Country selected;
  const _CountryPickerSheet({required this.selected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = kCountries.where((c) {
      final q = _query.toLowerCase();
      return c.name.toLowerCase().contains(q) || c.dialCode.contains(q);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  autofocus: false,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Search country or code',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final country = filtered[index];
                    final isSelected = country == widget.selected;
                    return ListTile(
                      leading: Text(country.flagEmoji, style: const TextStyle(fontSize: 20)),
                      title: Text(country.name, style: AppTextStyles.body),
                      trailing: Text(
                        country.dialCode,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(country),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}