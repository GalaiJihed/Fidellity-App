import 'package:shared_preferences/shared_preferences.dart';

class Session{
  static final String KEY_IS_LOGGEDIN = "isLoggedIn";
  String token;
  String token_notification;
  Session({ this.token});

  Future<String>getToken() async
  {

     SharedPreferences prefs  = await SharedPreferences.getInstance() ;
      this.token= prefs.getString('token');
     return   prefs.getString('token');
  }

  getMyToken(){
    getToken();
    return this.token;
  }
  setToken(String token)
  async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     this.token = token;
    prefs.setString('token', token);
    //print(prefs.getString('token'));
  }
  removeToken() async {

     SharedPreferences prefs  = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
   Future<bool>isLoggedIn() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGEDIN) ?? false;
  }

  setLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool(KEY_IS_LOGGEDIN,true);
  }
  setLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(KEY_IS_LOGGEDIN,false);
  }


  //Token notification
  Future<String>getTokenNotification() async
  {

    SharedPreferences prefs  = await SharedPreferences.getInstance() ;
    this.token_notification= prefs.getString('token_notification');
    return   prefs.getString('token_notification');
  }


  setTokenNotification(String tokenNotification)
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.token_notification = tokenNotification;
    prefs.setString('token_notification', token_notification);
    //print(prefs.getString('token'));
  }
  removeTokenNotification() async {

    SharedPreferences prefs  = await SharedPreferences.getInstance();
    prefs.remove('token_notification');
  }


}