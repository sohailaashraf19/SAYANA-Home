import 'package:hive/hive.dart';
import 'package:my_house_design/presentation/widgets/constants.dart';
import 'package:my_house_design/presentation/widgets/settings.dart';
import 'package:my_house_design/presentation/widgets/user_model.dart';


class Boxes { 
  static Box<UserModel> getUser() => 
      Hive.box<UserModel>(Constants.userBox);   
  static Box<Settings> getSettings() => 
      Hive.box<Settings>(Constants.settingsBox);
   
}