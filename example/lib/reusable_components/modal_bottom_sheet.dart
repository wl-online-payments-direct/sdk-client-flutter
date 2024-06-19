/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:flutter/material.dart';

import 'default_padding.dart';
import 'default_text.dart';

class ModalBottomSheet extends StatelessWidget {
  final String text;

  const ModalBottomSheet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Center(
        child: DefaultPadding.all(
          size: 20,
          child: DefaultText(text),
        ),
      ),
    );
  }
}
