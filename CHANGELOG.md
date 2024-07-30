# DUTWRAPPER CHANGE LOG

This file will list all version log for modified, added or removed functions of dutwrapper (Dart language).

## 1.0.0
- Functions in `Account` class have no more `RequestResult` returns. This class has been removed.
  - Introducing `AccountSession` class. This will resolve login failed in the future (if not too much).
  - Rework `Login` function using `AccountSession` class.
- Moved all functions in `model` to `account_object.dart`, `account_session_object.dart`, `news_object.dart` and `utils_object.dart`.
  - Another class in `model` will moved to root.
- Optimize codes.
- Updated dependencies to latest version.

## 0.4.4
- Fixed a issue cause can't login account to sv.dut.udn.vn.

## 0.4.3
- Fixed issues cause point T10 and T4 displays incorrectly.

## 0.4.2
- New function for Account: `Account training status`.

## 0.4.1
- New function for Account: `Account Information`.

## 0.4.0
- Re-organizing model class.
- New function for Account: Subject fee
- New function for DutUtils: `getCurrentSchoolYear`: Get current school year in DUT.

## 0.3.4
- Fixed a issue in sv.udn.vn in subject news cause return empty list instead of throwing exceptions.
- Improve code in Account library.

## 0.3.1
- Fixed a issue in sv.dut.udn.vn subject code fault (ex. 20Nh92, ...) will fail this library.

## 0.3.0
- Ported: Account (Subject Schedule).

## 0.2.0
- Ported: Account (Login, Logout, Is Logged In, Generate Session ID).

## 0.1.0
- Ported: News Global and News Subject.
