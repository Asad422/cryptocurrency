import 'package:cryptocurrency/repositories/crypto_coins/model/cryptocoin.dart';

abstract class  AbstractCoinsRepository{

  Future<List<CryptoCoin>> getCoinsList(String currency);
}