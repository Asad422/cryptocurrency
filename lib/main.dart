import 'package:cryptocurrency/repositories/add_crypto_coin/abstract_add_crypto_coin.dart';
import 'package:cryptocurrency/repositories/add_crypto_coin/add_crypto_coin_rep.dart';
import 'package:cryptocurrency/repositories/crypto_coins/abstract_coinlist.dart';
import 'package:cryptocurrency/repositories/crypto_coins/coin_list_page.dart';
import 'package:cryptocurrency/repositories/crypto_coins/crypto_coins_rep.dart';
import 'package:cryptocurrency/repositories/selected_coin_graphic/graphic_rep.dart';
import 'package:cryptocurrency/repositories/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  SharedPreferences prefs = await SharedPreferences.getInstance();

  GetIt.instance.registerSingleton<StorageOfTheApp>(StorageOfTheApp(prefs: prefs));
  GetIt.instance.registerSingleton<AbstractCoinsRepository>(CryptoCoinsRepository(dio: Dio()));
  GetIt.instance.registerSingleton<AbstractAddCryptoCoinIdRepository>(AddCryptoCoinId(dio: Dio()));
  GetIt.instance.registerSingleton<GraphicRepository>(GraphicRepository(dio: Dio()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,


      ),
      home: CoinListPage(),
    );
  }
}
