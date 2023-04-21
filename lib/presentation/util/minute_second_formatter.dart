import 'package:flutter/services.dart';

class MinuteSecondFormatter extends TextInputFormatter {

  final int fieldLength = 4;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    final novoTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength > fieldLength) {
      return oldValue;
    }

    switch (novoTextLength) {
      case 1:
        final minute = int.tryParse(newValue.text.substring(0, 1));
        if (minute != null) {
          if (minute >= 6) return oldValue;
        }
        break;
      case 2:
        final minute = int.tryParse(newValue.text.substring(0, 2));
        if (minute != null) {
          if (minute >= 60) return oldValue;
        }
        break;
      case 3:
        final second = int.tryParse(newValue.text.substring(2, 3));
        if (second != null) {
          if (second >= 6) return oldValue;
        }
        newText
            .write('${newValue.text.substring(0, usedSubstringIndex = 2)}:');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      case 4:
        final segundo = int.tryParse(newValue.text.substring(2, 4));
        if (segundo != null) {
          if (segundo >= 60) return oldValue;
        }
        newText
            .write('${newValue.text.substring(0, usedSubstringIndex = 2)}:');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      default:
    }

    if (novoTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

}