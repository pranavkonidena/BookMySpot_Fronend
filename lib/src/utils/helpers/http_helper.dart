import 'dart:convert';

import '../enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:book_my_spot_frontend/src/models/response.dart';

class HttpHelper {
  static Future<Response> getRequest(
    RequestGroup type,
    String suffix,
  ) async {
    late Uri url;
    switch (type) {
      case RequestGroup.amenity:
        url = Uri.parse(using + "amenity/" + suffix);
        break;
      case RequestGroup.booking:
        url = Uri.parse(using + "booking/" + suffix);
        break;
      case RequestGroup.event:
        url = Uri.parse(using + "event/" + suffix);
        break;
      case RequestGroup.group:
        url = Uri.parse(using + "group/" + suffix);
        break;
      case RequestGroup.team:
        url = Uri.parse(using + "team/" + suffix);
        break;
      case RequestGroup.user:
        url = Uri.parse(using + "user/" + suffix);
        break;
      case RequestGroup.other:
        url = Uri.parse(suffix);
      default:
        break;
    }

    var response = await http.get(url);
    return (Response(
        response.statusCode, jsonDecode(response.body.toString())));
  }
}
