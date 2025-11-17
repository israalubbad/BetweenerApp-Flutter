import 'package:betweener_app/core/helpers/shared_prefs.dart';
import 'dart:io';

String? get token => SharedPrefsHelper().getValueFor<String>("token");

Map<String, String> get headers => {
  HttpHeaders.acceptHeader: 'application/json',
  if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
};

