
import 'package:cryptocurrency/repositories/selected_coin_graphic/graphic_rep.dart';
import 'package:cryptocurrency/repositories/selected_coin_graphic/model/graphic_data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vibration/vibration.dart';

import '../crypto_coins/coin_list_page.dart';


const List<String> typeOfGraphic = [
  '15 min',
  '30 min',
  'hour',
  'day',
  'week',
  'month',
  'year',
];
class CryptoPriceChart extends StatefulWidget {

  final String idName;

  const CryptoPriceChart({super.key, required this.idName});

  @override
  State<CryptoPriceChart> createState() => _CryptoPriceChartState();
}

class _CryptoPriceChartState extends State<CryptoPriceChart> {
   List<GraphicPriceModel> priceData=[];
   String dropdownValue = list.first;
   DateTime today= DateTime.now();
   double perCent = 0;
   int selectedIndex = 0;
   String formattedDay ='';
    dynamic currentPrice;
    dynamic wasPrice;
  @override
  void initState() {

    formattedDay = DateFormat('dd-MM-yy').format(today);
    setState(() {
    });
    GetIt.instance<GraphicRepository>().getPrices(type: typeOfGraphic[selectedIndex], id: widget.idName,currency: dropdownValue).then((value) {
      priceData = value;
      currentPrice = priceData.last.price;

      wasPrice = priceData[0].price;

       perCent = calculateMoreOrNot(double.tryParse(priceData[0].price.toString())!,double.tryParse(priceData.last.price.toString())!);

      setState(() {});
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          actions: [

            Container(
              child:currentPrice == null ?

              Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )): Text(currentPrice.toString(),style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20
              ),),
            ),

            SizedBox(width: 10,),




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
                dropdownValue = value!;


                  GetIt.instance<GraphicRepository>().getPrices(type: typeOfGraphic[selectedIndex], id: widget.idName,currency: dropdownValue).then((value) {

                  setState(() {
                    priceData = value;

                    perCent= calculateMoreOrNot(
                        double.tryParse(priceData[0].price.toString())!,
                        double.tryParse(priceData.last.price.toString())!
                    );
                    currentPrice = priceData.last.price;
                    wasPrice = priceData[0].price;
                  });
                });
              },
              dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ],

          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: ()=>Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          title: Text(widget.idName,style: TextStyle(
              color: Colors.white
          ),),
        ),
      backgroundColor:Colors.grey[900],
      body:

      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDay,style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400
              ),),
              Text(perCent.toStringAsFixed(3) + ' %',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: perCent >= 0 ?  Colors.green : Colors.red,
                  fontSize: 20
              ),),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  width: context.screenWidth,
                  height: 300,
                  child: priceData.isEmpty ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ): LineChart(

                    LineChartData(

                      backgroundColor: Colors.transparent,


                      lineTouchData: LineTouchData(


                        touchCallback: (FlTouchEvent event, LineTouchResponse? response){
                          Vibration.vibrate(duration: 50);
                              int millisecondsSinceEpoch = response?.lineBarSpots?[0].x.toInt() ?? priceData.last.timeStampTime;
                              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch * 1000);
                              String convertedTime = DateFormat('dd-MM-yy').format(dateTime);


                              setState(() {
                                perCent= calculateMoreOrNot(
                                    double.tryParse(priceData[0].price.toString())!,
                                    response?.lineBarSpots?[0].y ?? double.tryParse(priceData.last.price.toString())!
                                );
                                currentPrice = response?.lineBarSpots?[0].y ?? priceData.last.price;
                                formattedDay = convertedTime;
                                wasPrice = priceData[0].price;
                              });

                        },
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.transparent,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((lineBarSpot) {
                              return LineTooltipItem(
                                '',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),

                        enabled: true,
                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                    const FlLine(
                    color: Colors.white,
                    ),
                    FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                    radius: 6,
                    color: priceData[0].price  <= priceData.last.price ? Colors.green : Colors.red,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                    ),
                    ),
                    );
                    }).toList();},

                      ),

                      lineBarsData: [
                        LineChartBarData(

                          barWidth: 3,
                          color: priceData[0].price  <= priceData.last.price ? Colors.green : Colors.red,
                          spots: [
                            for (int i = 0; i < priceData.length; i++)
                              FlSpot(double.tryParse(priceData[i].timeStampTime.toString()) ?? 1,double.tryParse(priceData[i].price.toString())!,),
                          ] ,
                          isCurved: false,
                          dotData: FlDotData(show: false
                          ),
                          belowBarData: BarAreaData(show: true),

                        ),

                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),

                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Container(

                height: 30,
                width: context.screenWidth,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    itemCount: typeOfGraphic.length,
                    itemBuilder: (context,index){

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIndex == index ? Colors.grey : Colors.white
                    ),
                      onPressed: (){


                          if(index != selectedIndex){
                            selectedIndex = index;
                            GetIt.instance<GraphicRepository>().getPrices(type: typeOfGraphic[selectedIndex], id: widget.idName,currency: dropdownValue).then((value) {

                              setState(() {
                                priceData = value;
                                perCent= calculateMoreOrNot(
                                    double.tryParse(priceData[0].price.toString())!,
                                    double.tryParse(priceData.last.price.toString())!
                                );
                                currentPrice = priceData.last.price;
                                wasPrice = priceData[0].price;
                              });
                            });
                          }
                      },
                      child: Text(

                      typeOfGraphic[index],
                        style: TextStyle(
                          color: selectedIndex == index ? Colors.white : Colors.black
                        ),
                  ));
                }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10,);
                },),
              ),

              SizedBox(height: 50,),

             wasPrice == null || currentPrice == null ?

             Center(
               child: CircularProgressIndicator(
                 color: Colors.white,
               )):

             Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: priceData.last.price < wasPrice? Colors.green:Colors.red,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(wasPrice.toString(),style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20
                              ),),
                            ),
                          ),
                        ),
                      ),

                      Icon(Icons.arrow_forward,size: 30,color: Colors.white,),


                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                                color: priceData.last.price >= wasPrice? Colors.green:Colors.red,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                children: [
                                  Text(

                                  priceData.isNotEmpty? priceData.last.price.toString() : '0'

                                  .toString(),style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Text(
                      '${(priceData.last.price - wasPrice).runtimeType == int ? (priceData.last.price - wasPrice).toString() : (priceData.last.price - wasPrice).toStringAsFixed(3)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: priceData.last.price >= wasPrice? Colors.green:Colors.red
                      ),

                    ),
                  )
                ],
              )

            ],
          ),
        ),
      )
    );
  }

  double calculateMoreOrNot(double start,double end ){

    final perCent = ((end * 100) / start ) - 100;

   return perCent;
  }
}



