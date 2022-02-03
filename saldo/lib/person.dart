class Person {
  int id;
  String name;
  int balance=0;

  Person(this.id, this.name, this.balance);
  // Convierte en un Map. Las llaves deben corresponder con los nombres de las
  // columnas en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }
}









