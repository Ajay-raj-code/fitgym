class HelperFunctions{
  static String getCurrentDate(){
   var t = DateTime.now();
   return "${t.day}-${t.month}-${t.year}";
  }
}