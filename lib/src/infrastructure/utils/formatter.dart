/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

void _fillBuffer(
  int index,
  int offset,
  List<String> buffer,
  List<String> tempMask,
  List<String> valuec,
) {
  if (!(index + offset < valuec.length && index < tempMask.length)) {
    return;
  }

  final maskChar = index < tempMask.length ? tempMask[index] : null;
  final valueIdx = index + offset;
  final valueChar = valueIdx < valuec.length ? valuec[valueIdx] : null;

  if (maskChar == null || valueChar == null) {
    return;
  }

  if ((maskChar == '9' && (int.tryParse(valueChar) != null || valueChar == 'X') && valueChar != ' ') ||
      maskChar == '*') {
    // Digit or wildcard slot: accept the value character
    buffer.add(valueChar);
  } else if (valueChar == maskChar) {
    // Value matches the literal mask character
    buffer.add(valueChar);
  } else if (maskChar != '9' && maskChar != '*') {
    // Insert literal mask character, re-consume the value character next iteration
    buffer.add(maskChar);
    offset--;
  } else {
    // Remove invalid character and retry the same mask position
    valuec.removeAt(index + offset);
    index--;
  }

  _fillBuffer(index + 1, offset, buffer, tempMask, valuec);
}

/// Utility class for applying and removing display masks on payment field values.
///
/// Masks use `9` for digit slots, `*` for any-character slots, and `{`/`}` to
/// mark replaceable regions (used by [removeMask] to extract raw input).
/// All other characters in the mask are treated as literals.
class Formatter {
  const Formatter._();

  /// Applies [mask] to [value], inserting literal mask characters at the
  /// appropriate positions. Returns [value] unchanged when [mask] is null.
  static String? applyMask(String? mask, String? value) {
    if (value == null) return null;

    final buffer = <String>[];
    final valueChars = value.split('');

    if (mask != null) {
      // Strip braces — they are only used by removeMask to mark replaceable regions
      final maskChars = mask.split('').where((c) => c != '{' && c != '}').toList();
      _fillBuffer(0, 0, buffer, maskChars, valueChars);
    } else {
      buffer.addAll(valueChars);
    }

    return buffer.join();
  }

  /// Returns the maximum number of raw input characters allowed by [mask],
  /// or -1 when no mask is specified.
  static int getMaxLengthBasedOnMask(String? mask) {
    if (mask == null) return -1;
    final numberOfBraceChars = RegExp(r'[{}]').allMatches(mask).length;
    return mask.length - 1 - numberOfBraceChars;
  }

  /// Strips the mask characters from [value], returning only the raw user input
  /// that was entered inside `{...}` regions of [mask].
  ///
  /// When [mask] is null the trimmed [value] is returned as-is.
  static String removeMask(String? mask, String? value) {
    if (mask == null) return (value ?? '').trim();

    final buffer = <String>[];
    final valueChars = value?.split('') ?? [];
    var valueIndex = -1;
    var inMask = false;

    for (final char in mask.split('')) {
      valueIndex++;

      if (char == '{' || char == '}') {
        valueIndex--; // braces don't consume a value character
        inMask = char == '{';
        continue;
      }

      if (inMask && valueIndex < valueChars.length) {
        final valueChar = valueChars[valueIndex];
        if (valueChar.isNotEmpty) {
          buffer.add(valueChar);
        }
      }
    }

    return buffer.join().trim();
  }
}
