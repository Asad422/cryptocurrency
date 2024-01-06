import 'dart:async';
import 'dart:ui';

import 'package:cryptocurrency/repositories/add_crypto_coin/add_crypto_coin_page.dart';
import 'package:cryptocurrency/repositories/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:vibration/vibration.dart';

import '../../commons/widgets.dart';
import '../selected_coin_graphic/graphic_page.dart';
import 'abstract_coinlist.dart';
import 'crypto_coins_rep.dart';
import 'model/cryptocoin.dart';


const List<String> list = <String>['USD', 'EUR', 'RUB',];

class CoinListPage extends StatefulWidget {
  const CoinListPage({super.key});

  @override
  State<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends State<CoinListPage> {
  List<CryptoCoin>? coins;
  String dropdownValue = list.first;
   Timer? timer;
  @override
  void initState() {
    GetIt.I<AbstractCoinsRepository>()
        .getCoinsList(dropdownValue)
        .then((value) {
      setState(() {
        coins = value;
      });
    });
  resetDataAndTimer();
    super.initState();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.add,color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddCryptoIdPage()));
        },
        ),
        actions: [
          DropdownMenu<String>(
            trailingIcon  : Icon(Icons.arrow_drop_down,color: Colors.white,),
            selectedTrailingIcon: Icon(Icons.arrow_drop_up,color: Colors.white,),
            width: 100,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none,

            ),

            initialSelection: list.first,
            onSelected: (String? value) {
              setState(() {
                dropdownValue = value!;
                timer?.cancel();
                GetIt.I<AbstractCoinsRepository>()
                    .getCoinsList(dropdownValue)
                    .then((value) {
                  setState(() {
                    coins = value;
                  });
                });
                resetDataAndTimer();
              });
            },
            dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text('YCC',style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Column(
        children: [
          Expanded(
            child:

            (coins != null)  ?

            ReorderableListView.builder(
              proxyDecorator: proxyDecorator,
              itemBuilder: (context,index){

    return Slidable(
      key: ValueKey(coins?[index]),
    endActionPane: ActionPane(
    motion: ScrollMotion(),
    children: [
    SlidableAction(
    onPressed: (context){
    GetIt.instance<StorageOfTheApp>().removeIdFromList(coins![index].name).then((value) {
    coins?.removeAt(index);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    value ? ScaffoldMessenger.of(context).showSnackBar(snackBarSuccessRemoving) : ScaffoldMessenger.of(context).showSnackBar(snackBarErrRemoving);
    setState(() {});
    });
    },
    backgroundColor: Colors.red.shade900,
    foregroundColor: Colors.white,
    icon: Icons.delete,

    ),
    ],
    ),
    child: GestureDetector(
    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CryptoPriceChart(idName: coins?[index].name ?? 'Err')));
    },
    child: ListTile(
    title: Text(coins![index].name,
    style:  TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),),
    subtitle:  Text(coins![index].price.toString(),
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w200,
    color: Colors.white
    )),
    trailing: Image.network('https://www.cryptocompare.com${coins![index].image}'),
    ),
    ),
    );
    }, itemCount: coins?.length ?? 0,
                onReorderStart: (index){
                  Vibration.vibrate(duration: 100);
                }
              , onReorder:
                (int oldIndex, int newIndex) {
                timer?.cancel();
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final CryptoCoin? item = coins?.removeAt(oldIndex);
                coins?.insert(newIndex, item!);

              GetIt.instance<StorageOfTheApp>().reorderList(coins?.map((e) => e.name).toList() );
              resetDataAndTimer();

              });
            },)
    :Center(
              child:

              CircularProgressIndicator(
                color: Colors.white,

              )

            )
          ),
        ],
      ),
    );
  }

  resetDataAndTimer(){
    timer?.cancel();
    timer =  Timer.periodic(
        const Duration(seconds: 10), (timer) {
      GetIt.I<AbstractCoinsRepository>()
          .getCoinsList(dropdownValue)
          .then((value) {
        setState(() {
          coins = value;
        });
      });
    });
  }
  Widget proxyDecorator(
      Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color:Colors.black ,
          shadowColor: Colors.black,
          child: child,
        );
      },
      child: child,
    );
  }
}
