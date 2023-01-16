// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on LoginStoreBase, Store {
  late final _$isPhoneLoadingAtom =
      Atom(name: 'LoginStoreBase.isPhoneLoading', context: context);

  @override
  bool get isPhoneLoading {
    _$isPhoneLoadingAtom.reportRead();
    return super.isPhoneLoading;
  }

  @override
  set isPhoneLoading(bool value) {
    _$isPhoneLoadingAtom.reportWrite(value, super.isPhoneLoading, () {
      super.isPhoneLoading = value;
    });
  }

  late final _$isEmailLoadingAtom =
      Atom(name: 'LoginStoreBase.isEmailLoading', context: context);

  @override
  bool get isEmailLoading {
    _$isEmailLoadingAtom.reportRead();
    return super.isEmailLoading;
  }

  @override
  set isEmailLoading(bool value) {
    _$isEmailLoadingAtom.reportWrite(value, super.isEmailLoading, () {
      super.isEmailLoading = value;
    });
  }

  late final _$isOtpLoadingAtom =
      Atom(name: 'LoginStoreBase.isOtpLoading', context: context);

  @override
  bool get isOtpLoading {
    _$isOtpLoadingAtom.reportRead();
    return super.isOtpLoading;
  }

  @override
  set isOtpLoading(bool value) {
    _$isOtpLoadingAtom.reportWrite(value, super.isOtpLoading, () {
      super.isOtpLoading = value;
    });
  }

  late final _$isUserInfoLoadingAtom =
      Atom(name: 'LoginStoreBase.isUserInfoLoading', context: context);

  @override
  bool get isUserInfoLoading {
    _$isUserInfoLoadingAtom.reportRead();
    return super.isUserInfoLoading;
  }

  @override
  set isUserInfoLoading(bool value) {
    _$isUserInfoLoadingAtom.reportWrite(value, super.isUserInfoLoading, () {
      super.isUserInfoLoading = value;
    });
  }

  late final _$isPhoneDoneAtom =
      Atom(name: 'LoginStoreBase.isPhoneDone', context: context);

  @override
  bool get isPhoneDone {
    _$isPhoneDoneAtom.reportRead();
    return super.isPhoneDone;
  }

  @override
  set isPhoneDone(bool value) {
    _$isPhoneDoneAtom.reportWrite(value, super.isPhoneDone, () {
      super.isPhoneDone = value;
    });
  }

  late final _$isEmailDoneAtom =
      Atom(name: 'LoginStoreBase.isEmailDone', context: context);

  @override
  bool get isEmailDone {
    _$isEmailDoneAtom.reportRead();
    return super.isEmailDone;
  }

  @override
  set isEmailDone(bool value) {
    _$isEmailDoneAtom.reportWrite(value, super.isEmailDone, () {
      super.isEmailDone = value;
    });
  }

  late final _$isOtpDoneAtom =
      Atom(name: 'LoginStoreBase.isOtpDone', context: context);

  @override
  bool get isOtpDone {
    _$isOtpDoneAtom.reportRead();
    return super.isOtpDone;
  }

  @override
  set isOtpDone(bool value) {
    _$isOtpDoneAtom.reportWrite(value, super.isOtpDone, () {
      super.isOtpDone = value;
    });
  }

  late final _$otpScaffoldKeyAtom =
      Atom(name: 'LoginStoreBase.otpScaffoldKey', context: context);

  @override
  GlobalKey<ScaffoldState> get otpScaffoldKey {
    _$otpScaffoldKeyAtom.reportRead();
    return super.otpScaffoldKey;
  }

  @override
  set otpScaffoldKey(GlobalKey<ScaffoldState> value) {
    _$otpScaffoldKeyAtom.reportWrite(value, super.otpScaffoldKey, () {
      super.otpScaffoldKey = value;
    });
  }

  late final _$authTokenAtom =
      Atom(name: 'LoginStoreBase.authToken', context: context);

  @override
  String get authToken {
    _$authTokenAtom.reportRead();
    return super.authToken;
  }

  @override
  set authToken(String value) {
    _$authTokenAtom.reportWrite(value, super.authToken, () {
      super.authToken = value;
    });
  }

  late final _$emailLoginAsyncAction =
      AsyncAction('LoginStoreBase.emailLogin', context: context);

  @override
  Future<void> emailLogin(BuildContext context, String email) {
    return _$emailLoginAsyncAction.run(() => super.emailLogin(context, email));
  }

  late final _$phoneLoginAsyncAction =
      AsyncAction('LoginStoreBase.phoneLogin', context: context);

  @override
  Future<void> phoneLogin(BuildContext context, String phone, String? appSig) {
    return _$phoneLoginAsyncAction
        .run(() => super.phoneLogin(context, phone, appSig));
  }

  late final _$validateOtpAndLoginAsyncAction =
      AsyncAction('LoginStoreBase.validateOtpAndLogin', context: context);

  @override
  Future<void> validateOtpAndLogin(
      BuildContext context, String smsCode, String phone) {
    return _$validateOtpAndLoginAsyncAction
        .run(() => super.validateOtpAndLogin(context, smsCode, phone));
  }

  late final _$validateEmailAndLoginAsyncAction =
      AsyncAction('LoginStoreBase.validateEmailAndLogin', context: context);

  @override
  Future<void> validateEmailAndLogin(
      BuildContext context, String smsCode, String email) {
    return _$validateEmailAndLoginAsyncAction
        .run(() => super.validateEmailAndLogin(context, smsCode, email));
  }

  @override
  String toString() {
    return '''
isPhoneLoading: ${isPhoneLoading},
isEmailLoading: ${isEmailLoading},
isOtpLoading: ${isOtpLoading},
isUserInfoLoading: ${isUserInfoLoading},
isPhoneDone: ${isPhoneDone},
isEmailDone: ${isEmailDone},
isOtpDone: ${isOtpDone},
otpScaffoldKey: ${otpScaffoldKey},
authToken: ${authToken}
    ''';
  }
}
