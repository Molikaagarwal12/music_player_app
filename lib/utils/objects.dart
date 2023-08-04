import 'dart:core';

extension ObjectExtension on Object {
  Object? get type {
    return this.runtimeType;
  }
}