import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Resource/colors.dart';

class UserInputField extends StatelessWidget {
  UserInputField(
      {super.key,
      required this.title,
      this.controller,
      this.autofillHints,
      this.decoration,
      this.showForgotButton = false,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.inputFormatters,
      this.validator,
      this.readOnly = false,
      this.obscuringCharacter = '•',
      this.obscureText = false,
      this.maxLines,
      this.autovalidateMode,
      this.titleStyle,
      this.keyboardType,
      this.textInputAction,
      this.textFeildheight,
      this.textCapitalization = TextCapitalization.none});

  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? obscureText;
  final String? obscuringCharacter;
  final bool? readOnly;
  final bool showForgotButton;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final double? textFeildheight;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));

  final String title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle ??
              textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600, color: textColor),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: textFeildheight,
          child: TextFormField(
              autofillHints: autofillHints,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(letterSpacing: 1),
              autovalidateMode: autovalidateMode,
              onChanged: onChanged,
              onTap: onTap,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              onTapOutside: onTapOutside,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              onSaved: onSaved,
              validator: validator,
              inputFormatters: inputFormatters,
              readOnly: readOnly!,
              controller: controller,
              obscureText: obscureText!,
              maxLines: maxLines,
              obscuringCharacter: obscuringCharacter!,
              decoration:
                  decoration ?? InputDecoration(border: textFieldBorder)),
        ),
        const SizedBox(height: 10),
        showForgotButton
            ? Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    "Forgot password?",
                    style: textTheme.bodyMedium!.copyWith(letterSpacing: 1),
                  ),
                  onPressed: () {
                    context.go('/forgot');
                  },
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
