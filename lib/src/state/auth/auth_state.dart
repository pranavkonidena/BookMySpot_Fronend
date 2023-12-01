import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';

final authTokenProvider = FutureProvider<Response?>((ref) async {
  Uri uri = ref.watch(uriProvider);
  if (!uri.toString().contains("channeli")) {
    Response response =
        await HttpHelper.makeRequest(RequestTypes.get,RequestGroup.full, uri.toString());
    return Response(response.statusCode, response.data);
  } else {
    return null;
  }
});