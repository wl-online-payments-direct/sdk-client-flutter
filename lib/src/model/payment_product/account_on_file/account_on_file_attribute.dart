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
import 'package:json_annotation/json_annotation.dart';

part 'account_on_file_attribute.g.dart';

/// Represents an AccountOnFileAttribute object.
@JsonSerializable(explicitToJson: true)
class AccountOnFileAttribute {
  @JsonKey()
  String key;
  @JsonKey()
  String value;
  @JsonKey()
  AccountOnFileAttributeStatus? status;

  AccountOnFileAttribute({this.key = "", this.value = "", this.status});

  factory AccountOnFileAttribute.fromJson(Map<String, dynamic> json) =>
      _$AccountOnFileAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AccountOnFileAttributeToJson(this);

  /// Returns whether an [AccountOnFileAttribute] can be edited based on its [AccountOnFileAttributeStatus].
  bool isEditingAllowed() {
    return status?.isEditingAllowed ?? false;
  }
}

/// Enum containing all the possible statuses for a [AccountOnFileAttribute].
enum AccountOnFileAttributeStatus {
  @JsonValue("READ_ONLY")
  readOnly,
  @JsonValue("CAN_WRITE")
  canWrite,
  @JsonValue("MUST_WRITE")
  mustWrite
}

/// Extension that returns whether an [AccountOnFileAttribute] can be edited based on its [AccountOnFileAttributeStatus].
extension AccountOnFileAttributeStatusX on AccountOnFileAttributeStatus {
  bool get isEditingAllowed {
    switch (this) {
      case AccountOnFileAttributeStatus.readOnly:
        return false;
      default:
        return true;
    }
  }
}
