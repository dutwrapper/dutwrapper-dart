import 'dart:convert';

import 'lib_exception.dart';

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
      throw DutWrapperException(
        message: "Session ID is null.",
        reason: DutWrapperExceptionReason.notAuthorized,
      );
    }
  }

  void ensureValidLoginForm() {
    ensureValidSessionId();
    if (viewState == null) {
      throw DutWrapperException(
        message: "viewState is null. This is required when login.\n"
            "You might generate session again to do this.",
        reason: DutWrapperExceptionReason.parameterException,
      );
    }
    if (viewStateGenerator == null) {
      throw DutWrapperException(
        message: "viewStateGenerator is null. This is required when login.\n"
            "You might generate session again to do this.",
        reason: DutWrapperExceptionReason.parameterException,
      );
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
      throw DutWrapperException(
        message: "Username or password is null.",
        reason: DutWrapperExceptionReason.parameterException,
      );
    }
    if (username!.length < 6 || password!.length < 6) {
      throw DutWrapperException(
        message: "Username or password must be greater than 6 characters.",
        reason: DutWrapperExceptionReason.parameterException,
      );
    }
  }
}
