String base_url_IITR_WIFI = "http://10.81.4.165:8000/api/";
String base_url_IMG = "http://10.76.0.51:8000/api/";
String base_url_Iphone =
    "http://10.74.2.7:8000/api/"; // this is of iirwifi really
String IP = "10.81.4.165:8000";
String using = base_url_IITR_WIFI;
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

// return bookings.when(data: (value) {
//       if ((value as List).isEmpty) {
//         return const Padding(
//           padding: EdgeInsets.only(top: 18.0),
//           child: Text(
//             "Go, get some bookings to see them here!",
//             style: TextStyle(
//               fontFamily: "Thasadith",
//               fontSize: 20,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       } else {
//         return ListView.separated(
//           physics: const NeverScrollableScrollPhysics(),
//           separatorBuilder: (BuildContext context, int index) {
//             return const SizedBox(
//               height: 30,
//             );
//           },
//           shrinkWrap: true,
//           itemCount: value.length,
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 ref.read(groupidProvider.notifier).state = value[index]["id"];
//                 ref.read(dataIndexProvider.notifier).state = value[index]["id"];
//                 if (value[index]["type"] == "individual") {
//                   context.go("/booking/individual/${value[index]["id"]}");
//                 } else {
//                   context.go("/booking/group/${value[index]["id"]}");
//                 }
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 130,
//                 color: const Color.fromRGBO(247, 230, 196, 1),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.network(
//                             "https://github-production-user-asset-6210df.s3.amazonaws.com/122373207/275466089-4e5a891c-8afd-4e9b-a0da-04ff0c39687c.png",
//                             height: 30)
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           value[index]["amenity"]["name"],
//                           style: const TextStyle(
//                             color: Color(0xFF606C5D),
//                             fontSize: 30,
//                             fontFamily: 'Thasadith',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           "${value[index]["time_of_slot"].hour}:${value[index]["time_of_slot"].minute}-${value[index]["end_time"].hour}:${value[index]["end_time"].minute}",
//                           style: const TextStyle(
//                             color: Color(0xFF606C5D),
//                             fontSize: 25,
//                             fontFamily: 'Thasadith',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           value[index]["amenity"]["venue"],
//                           style: const TextStyle(
//                             color: Color(0xFF606C5D),
//                             fontSize: 15,
//                             fontFamily: 'Thasadith',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         )
//                       ],
//                     ),
//                     const VerticalDivider(
//                       color: Color(0xFF606C5D),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           value[index]["type"].toString().capitalize(),
//                           style: const TextStyle(
//                             color: Color(0xFF606C5D),
//                             fontSize: 25,
//                             fontFamily: 'Thasadith',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }, error: (error, stackTrace) {
//       return const SizedBox();
//     }, loading: () {
//       return const Center(child: CircularProgressIndicator());
//     });