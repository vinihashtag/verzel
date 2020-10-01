enum StatusScreen {
  initial,
  loading,
  error,
  generic,
  ok,
}

extension StatusScreenExtension on StatusScreen {
  static var _value;
  get value => _value;
  set value(value) => _value = value;
}

enum DATABASE { name, version }

class DatabaseHelperEnum {
  static dynamic getValue(DATABASE databaseName) {
    switch (databaseName) {
      case DATABASE.name:
        return "verzel.db";
      case DATABASE.version:
        return 1;
      default:
        return "";
    }
  }
}
