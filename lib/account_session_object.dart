import 'dart:convert';

class AccountSession {
  String? sessionId;
  String? viewState;
  String? viewStateGenerator;

  AccountSession.createDefault();

  AccountSession({
    required this.sessionId,
    required this.viewState,
    required this.viewStateGenerator,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'session_id': sessionId});
    result.addAll({'view_state': viewState});
    result.addAll({'view_state_generator': viewStateGenerator});

    return result;
  }

  factory AccountSession.fromMap(Map<String, dynamic> map) {
    return AccountSession(
      sessionId: map['session_id'],
      viewState: map['view_state'],
      viewStateGenerator: map['view_state_generator'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountSession.fromJson(String source) =>
      AccountSession.fromMap(json.decode(source));

  void ensureValidSessionId() {
    if (sessionId == null) {
      throw Exception("Session ID is null.");
    }
  }

  void ensureValidLoginForm() {
    ensureValidSessionId();
    if (viewState == null) {
      throw Exception("viewState is null. This is required when login.");
    }
    if (viewStateGenerator == null) {
      throw Exception("viewStateGenerator is null. This is required when login.");
    }

  }
}

class AuthInfo {
  final String? username;
  final String? password;

  AuthInfo.createDefault()
      : username = null,
        password = null;

  AuthInfo({
    required this.username,
    required this.password,
  });

  void ensureValidAuthInfo() {
    if (username == null || password == null) {
      throw Exception("Username or password is null.");
    }
    if (username!.length < 6 || password!.length < 6) {
      throw Exception("Username or password is less than 6 characters.");
    }
  }
}
