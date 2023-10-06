import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4BE9FF), Color(0xD30A90F2)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'UbuntuCondensed',
                    height: 0.03,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 13,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'TitilliumWeb',
                    height: 0.07,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 39,
              ),
              const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.0, right: 28),
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Color.fromRGBO(190, 255, 247, 100),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Your email',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(135, 145, 150, 100)),
                          filled: true),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 26,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'TitilliumWeb',
                    height: 0.07,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 39,
              ),
              const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.0, right: 28),
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Color.fromRGBO(190, 255, 247, 100),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Your password',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(135, 145, 150, 100)),
                          filled: true),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 26,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: 30, left: MediaQuery.of(context).size.width - 140),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromRGBO(39, 158, 255, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Color(0xFFDAE2F9),
                            fontSize: 20,
                            fontFamily: 'Titillium Web',
                            height: 0.05,
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 13,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Text(
                  'Not an admin?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Titillium Web',
                    fontWeight: FontWeight.w400,
                    height: 0.05,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 28.0, top: 15, right: 30),
                child: Divider(thickness: 2, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(left: 28.0, top: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                      padding: EdgeInsets.only(left: 70.0, right: 70),
                      child: Text(
                        'Sign in with Channeli',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Titillium Web',
                          fontWeight: FontWeight.w400,
                          
                        ),
                      )),
                ),
              )
            ],
          )),
    );
  }
}
