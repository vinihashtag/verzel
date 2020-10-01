import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final Icon prefixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final Function(String) validator;
  final Function onEditingComplete;
  final Function onTap;
  final bool enabled;
  final bool autocorrect;
  final bool readOnly;
  final bool obscureText;
  final bool filled;
  final int maxLines;
  final TextInputAction textInputAction;
  final Widget suffixIcon;
  final Color colorLabel;
  final TextAlign textAlign;
  final bool autovalidate;

  const CustomTextField(
      {Key key,
      this.labelText,
      this.inputFormatters,
      this.prefixIcon,
      this.keyboardType,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.enabled,
      this.readOnly,
      this.maxLines,
      this.textInputAction,
      this.onTap,
      this.suffixIcon,
      this.hintText,
      this.obscureText,
      this.onEditingComplete,
      this.autocorrect,
      this.colorLabel,
      this.textAlign,
      this.filled,
      this.autovalidate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        cursorColor: colorLabel ?? Get.theme.primaryColor,
        initialValue: initialValue,
        inputFormatters: inputFormatters ?? [],
        keyboardType: keyboardType,
        controller: controller,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
        focusNode: focusNode,
        onChanged: onChanged,
        onSaved: onSaved,
        onTap: onTap,
        autovalidate: autovalidate ?? false,
        onEditingComplete: onEditingComplete,
        autocorrect: autocorrect ?? true,
        readOnly: readOnly ?? false,
        enabled: enabled ?? true,
        validator: validator,
        maxLines: maxLines,
        obscureText: obscureText ?? false,
        textInputAction: textInputAction,
        textAlign: textAlign ?? TextAlign.left,
        decoration: InputDecoration(
            fillColor: Colors.grey[300],
            filled: filled ?? false,
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            hintText: hintText,
            hintStyle:
                TextStyle(color: Colors.black26, fontWeight: FontWeight.w600),
            hintMaxLines: 2,
            errorMaxLines: 2,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon),
      ),
    );
  }
}
