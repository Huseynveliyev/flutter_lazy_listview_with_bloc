import 'dart:developer' as devtools show log;

//! log extention
extension Log on Object {
  void log() => devtools.log(toString());
}
