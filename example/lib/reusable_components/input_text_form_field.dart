/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modal_bottom_sheet.dart';

class InputTextFormField extends ConsumerStatefulWidget {
  final String? label;
  final String? hint;
  final String? tooltipText;
  final String? value;
  final Function(String) onInputChanged;
  final Function(String?)? validate;

  const InputTextFormField({
    super.key,
    this.label,
    this.tooltipText,
    this.hint,
    required this.value,
    required this.onInputChanged,
    this.validate,
  });

  @override
  ConsumerState<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends ConsumerState<InputTextFormField> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When using the 'Paste session JSON response'-feature, this if-statement ensures that the pasted JSON is also shown in the TextFormField
    // All other times, this if-statement will be skipped
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (textEditingController.text != widget.value) {
        textEditingController.text = widget.value ?? '';
      }
    });

    return Column(
      children: [
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorMaxLines: 3,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(color: Colors.black54),
            suffixIcon: (widget.tooltipText != null)
                ? _Tooltip(
                    tooltipText: widget.tooltipText!,
                  )
                : null,
          ),
          onChanged: (value) => widget.onInputChanged(value),
          validator: (value) => widget.validate?.call(value),
        )
      ],
    );
  }
}

class _Tooltip extends StatelessWidget {
  final String tooltipText;

  const _Tooltip({required this.tooltipText});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipText,
      child: IconButton(
        icon: const Icon(Icons.info_outlined),
        color: Colors.black54,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ModalBottomSheet(
                text: tooltipText,
              );
            },
          );
        },
      ),
    );
  }
}
