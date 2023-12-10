import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_my_spot_frontend/src/utils/api/amenity_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';

// ignore: must_be_immutable
class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});

  late String email;
  late String password;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Center(
                  child: AutoSizeText(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge,
                    minFontSize: 25,
                    maxFontSize: 30,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 33,
                ),
                Center(
                    child: Text(
                  "For amenity admins",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 33,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: AutoSizeText(
                    'Email',
                    style: Theme.of(context).textTheme.labelMedium,
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
                          setState(() {
                            widget.email = value;
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFEDF8FF),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFC8E3FF),
                                ),
                                borderRadius: BorderRadius.circular(9)),
                            hintText: 'Enter Your email',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            filled: true),
                      ),
                    )),
                const SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text('Password',
                      style: Theme.of(context).textTheme.labelMedium),
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
                          setState(() {
                            widget.password = value;
                          });
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
                            hintStyle: Theme.of(context).textTheme.labelSmall,
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
                  height: 14,
                ),
                Center(
                    child: Text(
                  "For students",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
                const SizedBox(
                  height: 34,
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
                            await AmenityAPIEndpoint.amenityAuth(
                                context,  ref, widget.email, widget.password);
                          } on AuthException catch (e) {
                            Future.microtask(() => e.errorHandler(ref));
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
