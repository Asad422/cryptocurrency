

import 'package:cryptocurrency/repositories/selected_coin_graphic/model/graphic_data_model.dart';
import 'package:dio/dio.dart';

class GraphicRepository{

  final Dio dio;

  GraphicRepository({required this.dio});
  
  Future<List<GraphicPriceModel>>
  getPrices({required String type, required String id,required String currency}) async{
   late String typeOfRequest;
    late int countOfTime;


    switch(type) {
      case '15 min' :

        typeOfRequest = 'histominute';
        countOfTime = 15;

        break;
    case '30 min' :

    typeOfRequest = 'histominute';
    countOfTime = 30;

    break;

    case 'hour' :

    typeOfRequest = 'histominute';
    countOfTime = 60;

    break;

    case 'day' :

    typeOfRequest = 'histohour';
    countOfTime = 24;

    break;

    case 'week' :

    typeOfRequest = 'histoday';
    countOfTime = 7;

    break;

    case 'month' :

    typeOfRequest = 'histoday';
    countOfTime = 31;

    break;

    case 'year' :

    typeOfRequest = 'histoday';
    countOfTime = 365;

    break;

    case '5 years' :

    typeOfRequest = 'histoday';
    countOfTime = 365*5;

    break;

    }

    List  <GraphicPriceModel>  list= [];
    try{
      Response response =  await dio.get('https://min-api.cryptocompare.com/data/v2/$typeOfRequest?fsym=$id&tsym=$currency&limit=$countOfTime');
      final data = response.data as Map<String,dynamic>;
      final List <dynamic>transitionData = data['Data']['Data'];

      transitionData.forEach((element) {
       list.add(GraphicPriceModel(
           timeStampTime: element['time'],
           price: element['close']));
      });

      return list;
    }
    catch(e){
      return [];
    }
  }

}