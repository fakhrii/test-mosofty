
class Employee {
  int? id;
  String? name;
  String? lastName;

  Employee({
    this.id,
    this.name,
    this.lastName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['idperson'] ,
      name: json['prenom'] ,
      lastName:  json['nom'],
    );
  }

  Map<String, dynamic> toJson(Employee employee) {
    Map<String, dynamic> json = {
      if (employee.name != null) 'prenom': employee.name,
      if (employee.lastName != null) 'nom': employee.lastName,
    };
    return json;
  }
}
