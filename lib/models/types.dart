class PokeTypes {
  String name;

  PokeTypes({required this.name});

  static List<PokeTypes> decodeJson(List<dynamic> jsonList){
    List<PokeTypes> typesList = [];
    for(var s in jsonList) {
      typesList.add(PokeTypes(
        name: s['type']['name'],
      ));
    }
    return typesList;
  }
}