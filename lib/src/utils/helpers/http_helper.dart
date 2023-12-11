import 'dart:convert';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import '../enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';

class HttpHelper {
  static Future<Response> makeRequest(
      RequestTypes types, RequestGroup type, String suffix,
      [var postData]) async {
    late Uri url;
    switch (type) {
      case RequestGroup.amenity:
        url = Uri.parse("${using}amenity/$suffix");
        break;
      case RequestGroup.booking:
        url = Uri.parse("${using}booking/$suffix");
        break;
      case RequestGroup.event:
        url = Uri.parse("${using}event/$suffix");
        break;
      case RequestGroup.group:
        url = Uri.parse("${using}group/$suffix");
        break;
      case RequestGroup.team:
        url = Uri.parse("${using}team/$suffix");
        break;
      case RequestGroup.user:
        url = Uri.parse("${using}user/$suffix");
        break;
      case RequestGroup.other:
        url = Uri.parse(using + suffix);
      case RequestGroup.full:
        url = Uri.parse(suffix);
      default:
        break;
    }

    switch (types) {
      case RequestTypes.get:
        var response = await http.get(url);
        return (Response(
            response.statusCode, jsonDecode(response.body.toString())));
      case RequestTypes.post:
        var response = await http.post(url, body: postData);
        return Response(
            response.statusCode, jsonDecode(response.body.toString()));
      case RequestTypes.delete:
        var response = await http.delete(url, body: postData);
        return Response(
            response.statusCode, jsonDecode(response.body.toString()));
      default:
        return Response(404, "Method not found");
    }
  }
}
