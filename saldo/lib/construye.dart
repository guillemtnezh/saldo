import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

class Construye {
  List<Person> persons=[];
  final Future<Database> database=getDatabasesPath().then( (String path) {
    return openDatabase(
      join(path, 'saldo.db'),
      onCreate: (db, version) {
      // Ejecuta la sentencia CREATE TABLE en la base de datos
       return db.execute("CREATE TABLE persons(id INTEGER PRIMARY KEY, name TEXT, balance INTEGER)",);
      },
      version: 1,);
    }
  );
  int nextIdPerson=0;

  Future<void> makePersons() async{
    persons = await getPersons();
  }


  Future<List<Person>> getPersons() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Persons.
    final List<Map<String, dynamic>> maps = await db.query('persons');

    // Convierte List<Map<String, dynamic> en List<Person>.
    return List.generate(maps.length, (i) {
      if(nextIdPerson<maps[i]['id'])
        nextIdPerson=maps[i]['id'];
      return Person(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['balance'],
      );
    });
  }

  Future<void> insertPerson( Person p) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Inserta el Person en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Person se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'persons',
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<void> deletePerson(int id) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Person de la base de datos
    await db.delete(
      'persons',
      // Utiliza la cláusula `where` para eliminar un Person específico
      where: "id = ?",
      // Pasa el id Person a través de whereArg para prevenir SQL injection
      whereArgs: [id],
    );
  }
  void deleteAllPerson(){
    int i;
    for( i=0;i<persons.length;i++){
      deletePerson(persons[i].id);
    }
  }

  Future<void> addPerson(String nombre, int balance ) async{
    nextIdPerson++;
    Person p=new Person(nextIdPerson, nombre, balance);
    await insertPerson(p);
    //TODO: adicion a la app
  }

  String getDeben(){
    int i;
    int deben=0;
    for (i=0;i<persons.length;i++){
      if(persons[i].balance>0)
        deben=deben+persons[i].balance;
    }
    return deben.toString();
  }
  String getDebes(){
    int i;
    int debes=0;
    for (i=0;i<persons.length;i++){
      if(persons[i].balance<0)
        debes=debes+persons[i].balance;
    }
    return debes.toString();
  }

  Color makeEnable(Person p){
    Color x=Colors.black;
    if(p.balance==0)
      x=Colors.grey;
    return x;
  }
}





