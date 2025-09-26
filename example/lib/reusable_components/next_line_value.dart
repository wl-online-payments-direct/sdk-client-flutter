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

import 'default_text.dart';

class NextLineValue extends StatelessWidget {
  final String label;
  final String value;

  const NextLineValue({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultText(
          label,
          textColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        DefaultText(
          value,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
