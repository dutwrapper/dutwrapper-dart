enum LecturerGender {
  /// Unknown lecturer gender.
  unknown(-1),
  /// Male lecturer.
  male(0),
  /// Female lecturer.
  female(1);

  const LecturerGender(this.value);
  final int value;
}

enum LessonStatus {
  /// Unknown status for this subject.
  unknown(-1),
  /// This subject is only send notify to students and won't be changed.
  notify(0),
  /// This subject can't be performed as scheduled and will be make-up later.
  leaving(1),
  /// This subject scheduled a lesson for previous leaving lesson.
  makeUp(2);

  const LessonStatus(this.value);
  final int value;
}

enum NewsType {
  /// Unknown news type
  unknown(-1),
  /// Global news
  global(0),
  /// Subject news
  subject(1);

  const NewsType(this.value);
  final int value;
}

enum RequestCode {
  invalid(-3),
  exceptionThrown(-2),
  unknown(-1),
  successful(0),
  failed(1);

  const RequestCode(this.value);
  final int value;
}

enum NewsSearchMethod {
  /// Query news from news title.
  byTitle(0),
  /// Query news from news content.
  byContent(1);

  const NewsSearchMethod(this.value);
  final int value;
}

/// Account status while logging in.
enum LoginStatus {
  /// Unknown status. This might be code exception.
  unknown(-2),
  /// No internet connection.
  noInternet(-1),
  /// This acconut has logged in.
  loggedIn(0),
  /// Logged out or not logged in yet.
  loggedOut(1),
  /// This account has been locked.
  accountLocked(2);

  const LoginStatus(this.value);
  final int value;
}