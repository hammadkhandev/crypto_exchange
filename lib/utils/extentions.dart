import 'dart:io';

extension StringEx on String? {
  bool get isValid => this != null && this!.isNotEmpty;

  String toCapitalizeFirst() {
    return isValid ? "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}" : "";
  }

}

extension ListEx on List? {
  bool get isValid => this != null && this!.isNotEmpty;

  bool hasIndex(int index) {
    return this != null && this!.isNotEmpty && this!.length > index && index != -1;
  }
}

extension FileExtention on FileSystemEntity? {
  String get name => (this?.path.split("/").last) ?? "";
}
