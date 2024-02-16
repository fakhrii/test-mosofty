
class Mobile {
  int? id;
  String? name;
  String? num;
  String? employeeId;

  Mobile({
    this.id,
    this.name,
    this.num,
    this.employeeId,
  });

  factory Mobile.fromJson(Map<String, dynamic> json) {
    return Mobile(
      id: json['idtel'] ,
      name: json['nom'] ,
      num:  json['num'],
      employeeId: json['employeeId'],
    );
  }

  Map<String, dynamic> toJson(Mobile mobile) {
    Map<String, dynamic> json = {
      if (mobile.name != null) 'nom': mobile.name,
      if (mobile.num != null) 'num': mobile.num,
    };
    return json;
  }
}
