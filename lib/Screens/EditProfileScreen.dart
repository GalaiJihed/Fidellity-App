import 'dart:io';

import 'package:app/Animation/FadeAnimation.dart';
import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/custom_shape.dart';
import 'package:app/utils/customappbar.dart';
import 'package:app/utils/responsive_ui.dart';
import 'package:app/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  int selected;
  bool _large;
  final int PASSWORD_LENGHT = 5;
  bool _medium;
  DateTime birthday;
  DBClient _dbClient;
  User _currentUser;
  TextEditingController firstNameC,
      lastNameC,
      emailC,
      addressC,
      passwordC,
      retypeC,
      birthdayC,
      cityC;
  File file;
  String imageName;
  var result;
  var image;
  Future<File> uploadedImage;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = -1;
    firstNameC = new TextEditingController();
    lastNameC = new TextEditingController();
    emailC = new TextEditingController();
    addressC = new TextEditingController();
    cityC = new TextEditingController();
    birthdayC = new TextEditingController();
    birthday = new DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dbClient = new DBClient();
      _currentUser = new User();
      _dbClient.getCurrentUser().then((user) {
        _currentUser = user;
        setState(() {
          firstNameC.text = _currentUser.firstName.toString();
          lastNameC.text = _currentUser.lastName.toString();
          emailC.text = _currentUser.email.toString();
          addressC.text = _currentUser.address.toString();
          cityC.text = _currentUser.city.toString();
          birthdayC.text = DateFormat('yMMMMd').format(_currentUser.birthDate);
        });
      });

      //print( ' ${_events.toString()} ');
    });
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
                SizedBox(
                  height: _height / 215,
                ),
                FadeAnimation(1.55, button()),
                SizedBox(
                  height: _height / 35,
                ),
                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
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
            FadeAnimation(1.35, birthdayTextFormField()),
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
                      birthdayC.text = DateFormat('yMMMMd').format(date);
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    Translations.of(context)
                        .text("txt_edit_profile_set_birthday"),
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
      hint: Translations.of(context).text("hint_edit_profile_first_name"),
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      textEditingController: lastNameC,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: Translations.of(context).text("hint_edit_profile_last_name"),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailC,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: Translations.of(context).text("hint_edit_profile_email"),
    );
  }

  Widget addressTextFormField() {
    return CustomTextField(
      textEditingController: addressC,
      keyboardType: TextInputType.text,
      icon: Icons.location_on,
      hint: Translations.of(context).text("hint_edit_profile_address"),
    );
  }

  Widget cityTextFormField() {
    return CustomTextField(
      textEditingController: cityC,
      keyboardType: TextInputType.text,
      icon: Icons.location_city,
      hint: Translations.of(context).text("hint_edit_profile_city"),
    );
  }

  Widget birthdayTextFormField() {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: TextFormField(
        controller: birthdayC,
        keyboardType: TextInputType.text,
        cursorColor: Theme.mainColorAccent,
        obscureText: false,
        enabled: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.cake, color: Theme.mainColorAccent, size: 20),
          hintText:
              Translations.of(context).text("txt_edit_profile_set_birthday"),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
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
            colors: <Color>[Theme.mainColorAccent, Theme.mainColor],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          Translations.of(context).text("txt_btn_edit_profile_update"),
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  signUp() async {
    String url = AppConfig.URL_EDIT_CLIENT;
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    int phone = _currentUser.phoneNumber;
    print(phone.toString());
    Map<String, String> headers = {"Content-type": "application/json"};
    // print(cityC.text);
    String city = cityC.text.trim();
    String firstName = firstNameC.text.trim();
    String lastName = lastNameC.text.trim();
    String email = emailC.text.trim();
    String address = addressC.text.trim();
    String imageN = imageName;

    String postalCode = "0000";
    String json;
    //Control
    if (city.isEmpty ||
        firstNameC.text.isEmpty ||
        lastNameC.text.isEmpty ||
        emailC.text.isEmpty ||
        addressC.text.isEmpty ||
        (birthday.isAtSameMomentAs(DateTime.now()))) {
      print('complete all fields');
    } else {
      if (!emailValidator(email)) {
        print('Email Invalid');
      } else {
        if (imageN != null) {
          json = '{"phoneNumber": "$phone","firstName": "$firstName",'
              '"lastName": "$lastName","address": "$address",'
              '"email": "$email","image": "$imageN",'
              '"postalCode": "$postalCode","birthDate": "$birthday",'
              '"city": "$city"}';
        } else {
          json = '{"phoneNumber": "$phone","firstName": "$firstName",'
              '"lastName": "$lastName","address": "$address",'
              '"email": "$email",'
              '"postalCode": "$postalCode","birthDate": "$birthday",'
              '"city": "$city"}';
        }

        // make POST request
        var response = await post(url, headers: headers, body: json);
        // check the status code for the result
        int statusCode = response.statusCode;
        if (statusCode == 204) {
          print('Success');
          _currentUser.firstName = firstName;
          _currentUser.lastName = lastName;
          _currentUser.email = email;
          _currentUser.address = address;
          _currentUser.city = city;
          _currentUser.birthDate = birthday;
          if (imageN != null) {
            _currentUser.image = imageName;
            uploadImage(file.path);
          }

          //update function db
          _dbClient.update(_currentUser);
          //_dbClient.getCurrentUser().then((onValue) => print(onValue));
          Navigator.pop(context, _dbClient.getCurrentUser());
        } else if (statusCode == 403) {
          print('Problem');
        } else {
          print('Error');
        }
      }
    }
  }

  checkPasswords(String password, String retype) {
    if (password != retype) {
      print('Incorrect Passwords');
      return false;
    } else {
      if (password.length < PASSWORD_LENGHT ||
          retype.length < PASSWORD_LENGHT) {
        print('Password not strong enough');
        return false;
      } else {
        return true;
      }
    }
  }

  emailValidator(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
        .hasMatch(email);
  }
}
