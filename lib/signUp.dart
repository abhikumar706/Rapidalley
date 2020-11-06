// import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

class SignUp extends StatefulWidget {
  final String ref;
  @override
  const SignUp({
    Key key,
    this.ref = '',
  }) : super(key: key);

  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with WidgetsBindingObserver {
  final snackBar = SnackBar(
    content: Text(
      'Please fill Name and Number!',
      style: TextStyle(color: Colors.redAccent),
    ),
    action: SnackBarAction(
      label: 'Okay',
      onPressed: () {},
    ),
  );

  FocusNode focusPassword = FocusNode();
  FocusNode focusPassConf = FocusNode();
  FocusNode f1 = FocusNode();

  TextEditingController _controller1 = TextEditingController();

  dynamic _errorName;
  String nameRC;
  String mobNoRC;

  bool _loading = false;
  bool _pLoading = false;
  bool _buttonLoading = false;
  bool _buttonLoadingSU = false;

  bool initCalled = false;

  dynamic _password1;
  dynamic _password2;

  dynamic _errorPassword1;
  dynamic _errorPassword2;

  bool _password1Valid = true;
  bool _password2Valid = true;
  String _code = '';
  String errorText = '';

  dynamic _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _validatePassword1(String password1) {
    bool hasUppercase = password1.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password1.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password1.contains(new RegExp(r'[a-z]'));
    bool hasMinLength = password1.length >= 6;

    if (hasMinLength) {
      if (hasUppercase) {
        if (hasLowercase) {
          if (hasDigits) {
            setState(() {
              _password1Valid = true;
              _errorPassword1 = '';
            });
          } else {
            setState(() {
              _password1Valid = false;
              _errorPassword1 = 'Password should have a number!';
            });
          }
        } else {
          setState(() {
            _password1Valid = false;
            _errorPassword1 = 'Password should have lower case char!';
          });
        }
      } else {
        setState(() {
          _password1Valid = false;
          _errorPassword1 = 'Password should have upper case char!';
        });
      }
    } else {
      setState(() {
        _password1Valid = false;
        _errorPassword1 = 'Password should be of at least 6 character!';
      });
    }
  }

  void _validatePassword2(String password2) {
    if (password2 == this._password1) {
      setState(() {
        _password2Valid = true;
        _errorPassword2 = '';
      });
    } else {
      setState(() {
        _password2Valid = false;
        _errorPassword2 = 'Password does not match!';
      });
    }
  }

  Map<String, dynamic> signUpData() {
    return {
      'password': this._password1,
      'password_confirmation': this._password2,
    };
  }

  void signUp(BuildContext context) async {
    if (this._errorPassword1 == '' && this._errorPassword2 == '') {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Congrats!'),
            content: new Text('Your password meets our standards!',
                textAlign: TextAlign.center),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _password1Valid = false;
        _password2Valid = false;
        _errorPassword2 = 'Password does not match!';
      });
    }
  }

  Widget inputFields(BuildContext context, double width) {
    return Container(
      padding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Choose a password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: TextField(
              focusNode: focusPassword,
              onSubmitted: (term) {
                _fieldFocusChange(context, focusPassword, focusPassConf);
              },
              obscureText: true,
              style: TextStyle(fontSize: 20),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Password *',
                contentPadding: const EdgeInsets.all(0),
                border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0xffEC4D62), width: 3.0),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xff5a5a5a),
                ),
                errorText: this._password1Valid ? null : this._errorPassword1,
              ),
              onChanged: (text) {
                this._validatePassword1(text);
                setState(() {
                  this._password1 = text;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: TextField(
              focusNode: focusPassConf,
              obscureText: true,
              onSubmitted: (term) {
                _fieldFocusChange(context, focusPassConf, f1);
              },
              style: TextStyle(fontSize: 20),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                contentPadding: const EdgeInsets.all(0),
                border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0xffEC4D62), width: 3.0),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xff5a5a5a),
                ),
                errorText: this._password2Valid ? null : this._errorPassword2,
              ),
              onChanged: (text) {
                this._validatePassword2(text);
                setState(() {
                  this._password2 = text;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 0.0),
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: double.infinity,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Colors.amber[500],
              child: Text('Continue'),
              onPressed: () {
                // this.signUp(context);
                signUp(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _overlap = 0;
    // f1.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  double _overlap = 0;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    f1.dispose();
    focusPassword.dispose();
    focusPassConf.dispose();
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xff000000),
      ),
      body: Container(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.black,
                        child: Text('SIGN UP',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber[500])),
                      ),
                      Container(
                          width: width,
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  color: Colors.amber[500],
                                  child: SizedBox(
                                    height: 5,
                                    width: width / 2 - 23,
                                  )),
                              SizedBox(height: 5, width: 6),
                              Container(
                                  color: Colors.amber[500],
                                  child: SizedBox(
                                    height: 5,
                                    width: width / 2 - 23,
                                  )),
                            ],
                          )),
                      inputFields(context, width),
                    ],
                  ),
                  signUpButton(context),
                ]),
          ),
        ),
      ),
    );
  }
}
