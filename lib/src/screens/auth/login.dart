import 'dart:convert';
import 'package:book_my_spot_frontend/src/utils/api/amenity_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../services/storageManager.dart';
import '../../constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 29,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    'Email',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF747474),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: TextField(
                        onChanged: (value) {
                          ref.read(emailProvider.notifier).state = value;
                        },
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFEDF8FF),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFC8E3FF),
                                ),
                                borderRadius: BorderRadius.circular(9)),
                            hintText: 'Enter Your email',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Color(0xFF747474),
                            ),
                            filled: true),
                      ),
                    )),
                const SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    'Password',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF747474),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: TextField(
                        obscureText: true,
                        onChanged: (value) {
                          ref.read(passwordProvider.notifier).state = value;
                        },
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFEDF8FF),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFC8E3FF),
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            hintText: 'Enter Your Password',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 10,
                              color: const Color(0xFF747474),
                            ),
                            filled: true),
                      ),
                    )),
                const SizedBox(height: 74),
                const Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 22),
                  child: Divider(
                      color: Color.fromRGBO(200, 227, 255, 1), thickness: 1),
                ),
                const SizedBox(
                  height: 68,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      context.go("/webview");
                    },
                    child: Container(
                        width: 34,
                        height: 34,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFC8E3FF),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: Color(0xFFB1DAFF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Card(
                            child: SvgPicture.asset(
                                "assets/svgs/channelilogo.svg"))),
                  ),
                ),
                const SizedBox(
                  height: 42,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4898C6)),
                        onPressed: () async {
                          try {
                            
                            await AmenityAPIEndpoint.AmenityAuth(context, ref);
                          } on AuthException catch (e) {
                            Future.microtask(
                                () => e.errorHandler(ref));
                          }
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFEDF8FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
