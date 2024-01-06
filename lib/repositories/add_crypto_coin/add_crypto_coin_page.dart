

import 'package:cryptocurrency/repositories/add_crypto_coin/abstract_add_crypto_coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../crypto_coins/abstract_coinlist.dart';

class AddCryptoIdPage extends StatefulWidget {
  const AddCryptoIdPage({super.key});

  @override
  State<AddCryptoIdPage> createState() => _AddCryptoIdState();
}


class _AddCryptoIdState extends State<AddCryptoIdPage>with TickerProviderStateMixin  {
  late final AnimationController _controller;
  TextEditingController controllerText = TextEditingController();
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: ()=>Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        title: Text('Add crypto coin',style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 14
                ),
                controller: controllerText,
                decoration: InputDecoration(
                    label: Text('Enter crypto id (BTC,ETH)'),
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                await GetIt.instance<AbstractAddCryptoCoinIdRepository>().ifIdExist(controllerText.text).then((value) {
                  if(value == 'success' ){
                    showDialog(context: context, builder: (context){
                      return Lottie.asset(
                        'assets/animation.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward().then((value) => Navigator.pop(context));
                        },
                      );
                    });
                  }
                  else if (value == 'failure'){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('There is no coin with ${controllerText.text} id'),
                        )
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Check your internet connection'),
                        )
                    );
                  }
                });
                controllerText.clear();
                setState(() {});
              }, child: Text('Add coin to a list'))
            ],
          ),
        ),
      ),
    );
  }
}
