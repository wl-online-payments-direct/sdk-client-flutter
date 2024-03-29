/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
/// Library containing the classes required for validate functionality.
library validator;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:online_payments_sdk/src/models.dart';
import 'package:online_payments_sdk/src/model/requests/requests.dart';
import 'dart:async';

part 'native/validation/validation_classes.dart';
part 'native/validation/validation_method_channel.dart';
part 'native/validation/validation_sdk_interface.dart';
