


import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data.dart';

class StorageOfTheApp {
  final SharedPreferences prefs;

  StorageOfTheApp({required this.prefs});


  Future<List<String>> getIds() async{
    List<String>? data =  prefs.getStringList('ids');
    if(data == null) {
      data = listOfIds;
     await prefs.setStringList('ids', data);
    }
   return data;
  }
   addIdToList(String id) async{
    List<String>? data =  prefs.getStringList('ids') ?? listOfIds ;
      if(data.contains(id)){}
      else{
        data.add(id);
        await prefs.setStringList('ids', data);
      }
  }
  Future<bool> removeIdFromList(String id) async{
    List<String>? data =  prefs.getStringList('ids')  ?? listOfIds;
      if(data.contains(id)){
        data.remove(id);
        await prefs.setStringList('ids', data);
        return true;
      }
        else{
          return false;
      }
  }

  void reorderList(List<String>? ids)async{
    await prefs.setStringList('ids', ids ?? listOfIds);
  }
}