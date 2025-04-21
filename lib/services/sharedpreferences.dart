import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String accessTokenKey = "TOKENKEY";
  static String tokenTypeKey = "TOKENTYPEKEY";
  static String idKey = "IDKEY";
  static String firstNameKey = "FIRSTNAMEKEY";
  static String emailKey = "EMAILKEY";
  static String usernameKey = "USERNAMEKEY";
  /////////////////// set the shared preferences //////////////////////////////
  /*
  prefs.setString(accessTokenKey, getAccessTokenId);
  Key = Value
   */
  Future<bool> saveAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(accessTokenKey, value);
  }

  Future<bool> saveTokenType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(tokenTypeKey, value);
  }

  Future<bool> saveId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(idKey, value);
  }

  Future<bool> saveFirstName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firstNameKey, value);
  }

  Future<bool> saveEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(emailKey, value);
  }

  Future<bool> saveUsername(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usernameKey, value);
  }

  ////////////////////// get the preferences //////////////////////////////////
  Future<String?> getAccessTokenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<String?> getTokenType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenTypeKey);
  }

  Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(idKey);
  }

  Future<String?> getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firstNameKey);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  // clear the share preference
  Future<void> clearSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
