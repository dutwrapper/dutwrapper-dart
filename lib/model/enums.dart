enum LecturerGender {
  male(0),
  female(1),
  other(2);

  const LecturerGender(this.value);
  final int value;
}

enum LessonStatus {
  unknown(-1),
  leaving(0),
  makeUp(1);

  const LessonStatus(this.value);
  final int value;
}

enum NewsType {
  unknown(-1),
  global(0),
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

enum NewsSearchType {
  byTitle(0),
  byContent(1);

  const NewsSearchType(this.value);
  final int value;
}
