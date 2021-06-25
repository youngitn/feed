import 'package:dio/dio.dart';

import 'http_service.dart';

const BASE_URL = "https://www.travel.taipei/open-api/swagger/docs/V1";
const API_KEY = "fb12a31181aa4498ba52877978913275";


class HttpServiceImpl implements HttpService{

  Dio? _dio = Dio();

  @override
  Future<Response> getRequest(String url) async{
    // TODO: implement getRequest

    Response response;
    try {
      response = await _dio!.get(url);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  initializeInterceptors(){
    _dio!.interceptors.add(InterceptorsWrapper(
        onError: (DioError e, handler){
          return  handler.next(e);
        },
        onRequest: (options, handler){


        },
        onResponse: (response,handler){
          print("${response.statusCode} ${response.statusMessage} ${response.data}");
        }
    ));
  }

  @override
  void init() {
    _dio = Dio(BaseOptions(
        baseUrl: BASE_URL,
        headers: {"Authorization" : "Bearer $API_KEY"}
    ));

    initializeInterceptors();
  }

}