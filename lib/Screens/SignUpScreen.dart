import 'dart:io';

import 'package:app/Animation/FadeAnimation.dart';
import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/loginScreen.dart';
import 'package:app/models/Session.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/custom_shape.dart';
import 'package:app/utils/customappbar.dart';
import 'package:app/utils/responsive_ui.dart';
import 'package:app/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'PopUps/PopUp.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File file;
  String status = '';
  String base64Image;
  File tmpFile;
  String imageName;
  Future<File> uploadedImage;
  bool checkBoxValue = false;
  double _height;
  double _width;
  int selected;
  double _pixelRatio;
  bool _large;
  final int PASSWORD_LENGHT = 5;
  bool _medium;
  DateTime birthday;
  TextEditingController firstNameC,
      lastNameC,
      emailC,
      addressC,
      passwordC,
      retypeC,
      cityC;
  DBClient dbClient;
  Session session;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = -1;
    firstNameC = new TextEditingController();
    lastNameC = new TextEditingController();
    emailC = new TextEditingController();
    addressC = new TextEditingController();
    passwordC = new TextEditingController();
    retypeC = new TextEditingController();
    cityC = new TextEditingController();
    birthday = new DateTime.now();
    dbClient = new DBClient();
    session = new Session();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                FadeAnimation(1.5, acceptTermsTextRow()),
                SizedBox(
                  height: _height / 35,
                ),
                FadeAnimation(1.55, button()),
                FadeAnimation(1.6, signInTextRow()),

                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImageGallery() async {
    uploadedImage = ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      uploadedImage.then((onValue) {
        file = onValue;
        if (onValue != null) {
          imageName = path.basename(file.path);
          print(imageName);
        }
      });

      //path=image.toString().split("/");
      // print(path[path.length]);
      print("succes getting image ");
    });
  }

  getImageCamera() async {
    uploadedImage = ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      uploadedImage.then((onValue) {
        file = onValue;
        if (onValue != null) {
          imageName = path.basename(file.path);
          print(imageName);
        }
      });

      //path=image.toString().split("/");
      // print(path[path.length]);
      print("succes getting image ");
    });
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.mainColorAccent,
                ),
                title: Text(Translations.of(context).text("txt_take_photo")),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 0;
                  });
                  getImageCamera();
                  //print(selected);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.mainColorAccent,
                ),
                title: Text(Translations.of(context).text("txt_my_images")),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 1;
                  });
                  getImageGallery();
                  print(selected);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Theme.mainColorAccent,
                ),
                title: Text(Translations.of(context).text("txt_cancel")),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 2;
                  });
                  print(selected);
                },
              ),
            ],
          );
        });
  }

  uploadImage(filename) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(AppConfig.URL_UPLOAD_IMAGE));
    request.files.add(await http.MultipartFile.fromPath('image', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.mainColorAccent, Theme.mainColor],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.mainColorAccent, Theme.mainColor],
                ),
              ),
            ),
          ),
        ),
        FadeAnimation(
          1.1,
          GestureDetector(
              onTap: () async {
                await mainBottomSheet(context);

                // getImage();
              },
              child: FutureBuilder(
                  future: uploadedImage,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container(
                          height: _height / 5.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.0,
                                  color: Theme.shadowColor,
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 20.0),
                            ],
                            color: Theme.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            size: _large ? 40 : (_medium ? 33 : 31),
                            color: Theme.mainColorAccent,
                          ),
                        );
                        break;
                      case ConnectionState.waiting:
                        return Container(
                          height: _height / 5.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.0,
                                  color: Theme.shadowColor,
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 20.0),
                            ],
                            color: Theme.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            size: _large ? 40 : (_medium ? 33 : 31),
                            color: Theme.mainColorAccent,
                          ),
                        );
                        break;
                      case ConnectionState.active:
                        return Container(
                          height: _height / 5.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.0,
                                  color: Theme.shadowColor,
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 20.0),
                            ],
                            color: Theme.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            size: _large ? 40 : (_medium ? 33 : 31),
                            color: Theme.mainColorAccent,
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        if (null != snapshot.data) {
                          return Center(
                            child: Container(
                                height: _height / 5.5,
                                width: _width / 3.5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.blueGreyColor,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: Image.file(snapshot.data).image),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 0.0,
                                        color: Theme.shadowColor,
                                        offset: Offset(1.0, 10.0),
                                        blurRadius: 20.0),
                                  ],
                                )),
                          );
                          break;
                        } else {
                          return Container(
                            height: _height / 5.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.0,
                                    color: Theme.shadowColor,
                                    offset: Offset(1.0, 10.0),
                                    blurRadius: 20.0),
                              ],
                              color: Theme.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              size: _large ? 40 : (_medium ? 33 : 31),
                              color: Theme.mainColorAccent,
                            ),
                          );
                        }
                    }
                  })),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            FadeAnimation(1.2, firstNameTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.25, lastNameTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.3, emailTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.35, addressTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.35, cityTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.4, passwordTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(1.4, confirmPasswordTextFormField()),
            SizedBox(height: _height / 60.0),
            FadeAnimation(
              1.4,
              FlatButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1970, 1, 1),
                        maxTime: DateTime.now(), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      birthday = date;
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Set Birthday',
                    style: TextStyle(color: Theme.mainColorAccent),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      textEditingController: firstNameC,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      textEditingController: lastNameC,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Last Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailC,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget addressTextFormField() {
    return CustomTextField(
      textEditingController: addressC,
      keyboardType: TextInputType.text,
      icon: Icons.location_on,
      hint: "Address",
    );
  }

  Widget cityTextFormField() {
    return CustomTextField(
      textEditingController: cityC,
      keyboardType: TextInputType.text,
      icon: Icons.location_city,
      hint: "City",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      textEditingController: passwordC,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget confirmPasswordTextFormField() {
    return CustomTextField(
      textEditingController: retypeC,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock_open,
      hint: "Retype Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Theme.mainColorAccent,
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        signUp();
      },
      textColor: Theme.whiteColor,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Theme.mainColorAccent,
              Theme.mainColor,
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.mainColorAccent,
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  signUp() async {
    String url = AppConfig.URL_EDIT_CLIENT;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("PhoneNumber");
    Map<String, String> headers = {"Content-type": "application/json"};
    // print(cityC.text);
    String city = cityC.text.trim();
    String firstName = firstNameC.text.trim();
    String lastName = lastNameC.text.trim();
    String email = emailC.text.trim();
    String address = addressC.text.trim();
    String password = passwordC.text.trim();
    String rpassword = retypeC.text.trim();
    String postalCode = "0000";
    String imageN = imageName;
    String json;
    //Control
    if (city.isEmpty ||
        firstNameC.text.isEmpty ||
        lastNameC.text.isEmpty ||
        emailC.text.isEmpty ||
        addressC.text.isEmpty ||
        passwordC.text.isEmpty ||
        retypeC.text.isEmpty ||
        (birthday.isAtSameMomentAs(DateTime.now()))) {
      final action = Dialogs.yesAbortDialog(
          context, 'Fields', 'Complete all fields', DialogType.error);
    } else {
      if (!checkPasswords(password, rpassword)) {
      } else {
        if (!emailValidator(email)) {
          final action = Dialogs.yesAbortDialog(
              context, 'Email', 'Email Invalid', DialogType.error);
        } else {
          if (imageN != null) {
            json = '{"phoneNumber": "$phone","firstName": "$firstName",'
                '"lastName": "$lastName","address": "$address",'
                '"email": "$email","image": "$imageN",'
                '"postalCode": "$postalCode","birthDate": "$birthday",'
                '"city": "$city","password": "$password"}';
            if (imageN != null) {
              uploadImage(file.path);
            }
          } else {
            final action = await Dialogs.yesAbortDialog(
                context,
                'Select an Image',
                'Select an image to complete your profile.',
                DialogType.error);
          }
          // make POST request
          var response = await post(url, headers: headers, body: json);
          // check the status code for the result
          int statusCode = response.statusCode;
          if (statusCode == 204) {
            final action = await Dialogs.yesAbortDialog(context, 'Success',
                'Compte Created Successfully', DialogType.success);
            // ignore: unrelated_type_equality_checks
            if (action == DialogAction.yes) {
              dbClient.onDrop();
              dbClient.onDropStore();
              dbClient.onDropEvent();
              dbClient.ReCreate();
              session.removeToken();
              session.setLoggedOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          } else if (statusCode == 404) {
            final action = Dialogs.yesAbortDialog(context, 'PhoneNumber',
                'Phone Number not found', DialogType.error);
          } else if (statusCode == 400) {
            final action = Dialogs.yesAbortDialog(
                context, 'Error', 'Check your fields ', DialogType.error);
          } else {
            final action = Dialogs.yesAbortDialog(context, 'Error',
                'A problem has been Occured ', DialogType.error);
          }
        }
      }
    }
  }

  checkPasswords(String password, String retype) {
    if (password != retype) {
      print('Incorrect Passwords');
      final action = Dialogs.yesAbortDialog(
          context, 'Password', 'Incorrect Passwords', DialogType.error);
      return false;
    } else {
      if (password.length < PASSWORD_LENGHT ||
          retype.length < PASSWORD_LENGHT) {
        print('Password not strong enough');
        final action = Dialogs.yesAbortDialog(context, 'Password',
            'Password not strong enough', DialogType.warning);
        return false;
      } else {
        return true;
      }
    }
  }

  validatePassword(String password) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(password);

    if (!regex.hasMatch(password)) {
      final action = Dialogs.yesAbortDialog(
          context, 'Invalid', 'Enter valid password', DialogType.success);
      return false;
    } else
      return true;
  }

  emailValidator(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
        .hasMatch(email);
  }
}
