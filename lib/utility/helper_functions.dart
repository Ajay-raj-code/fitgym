class HelperFunctions{
  static String getCurrentDate(){
   var t = DateTime.now();
   return "${t.day}-${t.month}-${t.year}";
  }
  static int compareVersions(String v1, String v2) {
    List<String> a = v1.split('.');
    List<String> b = v2.split('.');

    int length = a.length > b.length ? a.length : b.length;

    for (int i = 0; i < length; i++) {
      int partA = i < a.length ? int.parse(a[i]) : 0;
      int partB = i < b.length ? int.parse(b[i]) : 0;

      if (partA > partB) return 1;    // v1 > v2
      if (partA < partB) return -1;   // v1 < v2
    }

    return 0; // v1 == v2
  }
}