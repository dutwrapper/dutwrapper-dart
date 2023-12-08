import 'package:html/dom.dart';
import 'package:collection/collection.dart';

extension ElementParser on Element? {
  String? getValue() {
    return this?.attributes["value"];
  }

  String getValueOrEmpty() {
    return this?.attributes["value"] ?? "";
  }

  String? getText() {
    return this?.text;
  }

  String getTextOrEmpty() {
    return getText() ?? "";
  }

  Element? getSelectedOptionInComboBox() {
    if (this == null) {
      return null;
    }

    var optionList = this!.getElementsByTagName('option');
    if (optionList.isEmpty) {
      return null;
    }

    return optionList.firstWhereOrNull(
        (element) => element.attributes.containsKey('selected'));
  }

  bool isGridChecked() {
    return this?.attributes['class']?.contains('GridCheck') ?? false;
  }

  bool isChecked() {
    return this?.attributes.containsKey('checked') ?? false;
  }

  bool isSelected() {
    return this?.attributes.containsKey("selected") ?? false;
  }
}
