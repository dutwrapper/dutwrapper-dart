import 'package:collection/collection.dart';
import 'package:html/dom.dart';

extension ElementParser on Element? {
  String? getValue() {
    return this?.attributes["value"];
  }

  String getValueOrEmpty() {
    return this?.attributes["value"] ?? "";
  }

  String? getText() {
    return (this == null)
        ? null
        : (this!.text.isEmpty)
        ? null
        : this!.text;
  }

  String getTextOrEmpty() {
    return getText() ?? "";
  }

  bool isTextEmpty() {
    return getTextOrEmpty().isEmpty;
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

  Document? convertToDocument() {
    return (this != null) ? Document.html(this!.innerHtml) : null;
  }
}
