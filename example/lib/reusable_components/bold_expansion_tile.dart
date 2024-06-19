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
import 'package:online_payments_sdk_example/reusable_components/default_text.dart';

class BoldExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;

  const BoldExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: DefaultText(
        title,
        fontWeight: FontWeight.bold,
        textColor: Colors.white,
      ),
      collapsedBackgroundColor: backgroundColor,
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      iconColor: Colors.white,
      children: children,
    );
  }
}
