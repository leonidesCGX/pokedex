class Stat {
  String name;
  int value;

  Stat({required this.name, required this.value});

  static List<Stat> decodeJson(List<dynamic> jsonList){
    List<Stat> statList = [];
    for(var s in jsonList) {
      statList.add(Stat(
        name: s['stat']['name'],
        value: s['base_stat'],
      ));
    }
    return statList;
  }
}