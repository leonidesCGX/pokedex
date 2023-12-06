class Abilities {
  String name;

  Abilities({required this.name});

  static List<Abilities> decodeJson(List<dynamic> jsonList){
    List<Abilities> statList = [];
    for(var s in jsonList) {
      statList.add(Abilities(
        name: s['ability']['name'],
      ));
    }
    return statList;
  }
}