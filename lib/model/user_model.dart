class UserModel {
  String _firstName;
  String _lastName;
  String _mobile;
  String _timeSlot;

  UserModel(this._firstName, this._lastName, this._mobile, this._timeSlot);

  String get timeSlot => _timeSlot;

  set timeSlot(String value) {
    _timeSlot = value;
  }

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }
}
