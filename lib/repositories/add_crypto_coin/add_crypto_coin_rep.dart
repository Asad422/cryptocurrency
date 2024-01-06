

import 'package:cryptocurrency/repositories/add_crypto_coin/abstract_add_crypto_coin.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../storage/storage.dart';

class AddCryptoCoinId implements AbstractAddCryptoCoinIdRepository{
  final Dio dio;

  AddCryptoCoinId({required this.dio});
  @override
  ifIdExist(String id) async {
    try{
      Response response =  await dio.
      get('https://min-api.cryptocompare.com/data/pricemultifull?fsyms='
          '${id.toUpperCase()}&tsyms=USD');

      final data = response.data as Map<String,dynamic>;
      if(data['Response'] != 'Error'){
        await GetIt.instance<StorageOfTheApp>().addIdToList(id);
        return 'success';
      }
      else{
        return 'failure';
      }
    }
    catch(e){
      return e.toString();
    }

  }

}