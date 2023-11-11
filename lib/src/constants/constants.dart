String base_url_IITR_WIFI = "http://10.81.4.165:8000/api/";
String base_url_IMG = "http://10.76.0.51:8000/api/";
String base_url_Iphone =
    "http://10.74.2.7:8000/api/"; // this is of iirwifi really
String IP = "10.76.0.51:8000";
String using = base_url_IMG;
String omniportURL =
    "https://channeli.in/oauth/authorise/?client_id=yjvukprsgUyGAHIrpBRRAkhYDe8EWWyfEserwFYL&redirect_uri=http://$IP/api/user/auth&state=random";

Map<int, String> days = {
  7: "Sunday",
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday"
};

Map<int, String> months = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};



// Padding(
//                   padding: EdgeInsets.only(
//                       right: 30, left: MediaQuery.of(context).size.width - 140),
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         var authHeaders = {
//                           "email": email,
//                           "password": password,
//                         };
//                         var response = await http.post(
//                             Uri.parse("${using}amenity/head/auth"),
//                             body: authHeaders);
//                         if (response.statusCode == 200) {
//                           var token = jsonDecode(response.body.toString());
//                           saveAdminToken(token);
//                           context.go("/head");
//                         } else {
//                           if (response.statusCode != 401) {
//                             const snackBar = SnackBar(
//                               content: Text(
//                                   'Error while logging u in, please try later'),
//                             );
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           } else {
//                             const snackBar = SnackBar(
//                               content: Text(
//                                   'Invalid credentials , please try again'),
//                             );
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           }
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                           foregroundColor:
//                               const Color.fromRGBO(39, 158, 255, 100),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5))),
//                       child: const Center(
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 16.0),
//                           child: Text(
//                             'Sign in',
//                             style: TextStyle(
//                               color: Color(0xFFDAE2F9),
//                               fontSize: 20,
//                               fontFamily: 'Titillium Web',
//                               height: 0.05,
//                             ),
//                           ),
//                         ),
//                       )),
//                 ),
