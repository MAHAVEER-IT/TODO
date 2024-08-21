import 'package:flutter/material.dart';
import 'package:todo/auth.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  bool _passwordview = true;

  String? _passwordError;

  String? _emailError;

  String? finalEmail;

  RegExp emailRegExp = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  String? email;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 110.0),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigoAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                '                 \t\t Hello !\n Wellcome Back  to TODO 📋',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: width * 0.9,
                child: Form(
                  child: TextFormField(
                    controller: _email,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      labelText: 'Email',
                      errorText: _emailError,
                      suffixIcon: Icon(
                        Icons.mail_lock_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: width * 0.9,
                child: Form(
                  child: TextFormField(
                    controller: _password,
                    style: TextStyle(color: Colors.white),
                    obscureText: _passwordview,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.5)),
                        labelText: 'password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordview
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordview = !_passwordview;
                            });
                          },
                        ),
                        errorText: _passwordError),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!emailRegExp.hasMatch(_email.text)) {
                    _emailError = 'Invalid Email';
                    print('Email error');
                  } else {
                    _emailError = null;
                  }
                  if (_password.text.length < 5) {
                    _passwordError = 'password must be have 6 letters';
                    print('password error');
                  } else {
                    _passwordError = null;
                  }

                  await Authentication().Sinin(
                    email: _email.text,
                    password: _password.text,
                    context: context,
                  );
                },
                child: Text('LOGIN'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                ' Or Sing in with',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: width * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    print('google is clicked');
                    await signInWithGoogle(context: context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google.png',
                        height: 22,
                        width: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Login With Google')
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Dont have a Accound ?'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
