import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../services/storageManager.dart';
import '../../constants/constants.dart';

final emailProvider = StateProvider<String>((ref) => "default");
final passwordProvider = StateProvider<String>((ref) => "default");

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Future<void> checkTokenAndNavigate() async {
    String? token = getToken();
    String? admintoken = getAdminToken();
    if (admintoken != "null") {
      context.go("/head");
    } else if (token != "null") {
      context.go("/");
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      checkTokenAndNavigate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var email = ref.watch(emailProvider);
    var password = ref.watch(passwordProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: TextField(
                        onChanged: (value) {
                          ref.read(emailProvider.notifier).state = value;
                        },
                        decoration: const InputDecoration(
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
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: TextField(
                        onChanged: (value) {
                          ref.read(passwordProvider.notifier).state = value;
                        },
                        decoration: const InputDecoration(
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
                      onPressed: () async {
                        var authHeaders = {
                          "email": email,
                          "password": password,
                        };
                        var response = await http.post(
                            Uri.parse("${using}amenity/head/auth"),
                            body: authHeaders);
                        if (response.statusCode == 200) {
                          var token = jsonDecode(response.body.toString());
                          saveAdminToken(token);
                          context.go("/head");
                        } else {
                          if (response.statusCode != 401) {
                            const snackBar = SnackBar(
                              content: Text(
                                  'Error while logging u in, please try later'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            const snackBar = SnackBar(
                              content: Text(
                                  'Invalid credentials , please try again'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(39, 158, 255, 100),
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
                    onPressed: () async {
                      context.go("/webview");
                    },
                    child: const Padding(
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
                ),
              ],
            )),
      ),
    );
  }
}
