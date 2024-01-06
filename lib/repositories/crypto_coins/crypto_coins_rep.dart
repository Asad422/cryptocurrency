


import 'package:cryptocurrency/repositories/crypto_coins/model/cryptocoin.dart';
import 'package:cryptocurrency/repositories/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'abstract_coinlist.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository{
  final Dio dio;
  CryptoCoinsRepository({required this.dio});
  @override
  Future<List<CryptoCoin>> getCoinsList(String currency) async {




     List <String> listOfIds = [];
    await GetIt.instance<StorageOfTheApp>().getIds().then((value) => listOfIds = value);
    if(listOfIds.isEmpty) {
      return [];
    }
    Response response =  await dio.get('https://min-api.cryptocompare.com/data/pricemultifull?fsyms=${listOfIds.join(',')}&tsyms=USD,EUR,RUB');
    final data = response.data['DISPLAY'] as Map<String,dynamic>;
    final dataList = data.entries.map((e) =>
        CryptoCoin(
            name: e.key,
            price: (e.value as Map<String,dynamic>)[currency]['PRICE'],
            image:  (e.value as Map<String,dynamic>)[currency]['IMAGEURL']
        )).toList();
    // dataList.sort((a,b) => a.name.compareTo(b.name));
    return dataList;
  }
}
