import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saldo/person.dart';
import 'construye.dart';
import 'person.dart';

void main() => runApp(SALDO());

Construye constructor = new Construye();

class SALDO extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SALDO'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/persons': (context) => MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/addperson': (context) => AddPersonPage(),
        '/deuda': (context) => DeudaPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    constructor.makePersons();
    List<Person> c = constructor.persons;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: (){
                print(constructor.persons.length.toString());
                setState(() {
                  //constructor.deleteAllPerson();
                  constructor.makePersons();
                });
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            alignment: Alignment.topCenter,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage('images/SALDO.png'),
            fit: BoxFit.fitWidth,
          )),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(30),
            children:
              c.map(
                    (data) => Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.perm_identity,
                          size: 30,
                          color: Colors.orangeAccent,
                        ),
                        title: Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            color: constructor.makeEnable(data),
                          ),
                        ),
                        subtitle: Text(
                          data.balance.toString() + '€',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: constructor.makeEnable(data),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/deuda', arguments: data);
                        },
                      ),
                    )
              ).toList(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/addperson');
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlue,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 50,
                  child: Text(
                    'TE DEBEN: ' + constructor.getDeben() + '€',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Poppins'),
                  )),
              Container(
                  height: 50,
                  child: Text(
                    'LO DEBES: ' + constructor.getDebes() + '€',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Poppins'),
                  )),
            ],
          ),
        )
    );
  }
}


class DeudaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Person arg = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          arg.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar persona',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('¿Estás seguro?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        constructor.deletePerson(arg.id);

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Sí, borrar.'),
                    ),
                    FlatButton(
                      onPressed: () {
                        //¿nada?
                        Navigator.pop(context);
                      },
                      child: Text('No.'),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 2.5 / 2,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                    bottomLeft: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 300,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0),
                          bottomLeft: const Radius.circular(5.0),
                          bottomRight: const Radius.circular(5.0),
                        )),
                    child: Center(
                      child: Text(
                        arg.name,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    arg.balance.toString()+'€',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                      '#'+arg.id.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter { tedebe, ledebes }
class AddPersonPage extends StatefulWidget {
  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}
class _AddPersonPageState extends State<AddPersonPage> {
  SingingCharacter _character = SingingCharacter.tedebe;
  final myNombre = TextEditingController();
  final myBalance = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myNombre.dispose();
    myBalance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Añadir persona a la lista',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Añadir persona',
            onPressed: () {
              int x = int.parse(myBalance.text);
              if (_character == SingingCharacter.ledebes)
                x = -x;
              constructor.addPerson(myNombre.text, x);
              //constructor.makeConcepts(0);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio:  2/ 2,
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 300,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                            bottomLeft: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                          )),
                      child: Center(
                        child: Text(
                          'NOMBRE:',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: myNombre,
                      decoration: InputDecoration(
                        labelText: 'nombre',
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                            bottomLeft: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                          )),
                      child: Center(
                        child: Text(
                          'Balance:',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: myBalance,
                      decoration: InputDecoration(
                        labelText: 'balance',
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Te debe',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      leading: Radio(
                        value: SingingCharacter.tedebe,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Le debes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      leading: Radio(
                        value: SingingCharacter.ledebes,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),]
      ),
    );
  }
}

/*
class AddDeudaPage extends StatefulWidget {
  AddDeudaPage({Key key}) : super(key: key);

  @override
  _AddDeudaPageState createState() => _AddDeudaPageState();
}
class _AddDeudaPageState extends State<AddDeudaPage> {
  SingingCharacter _character = SingingCharacter.tedebe;
  final myConcepto = TextEditingController();
  final myImporte = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myConcepto.dispose();
    myImporte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Person arg = ModalRoute.of(context).settings.arguments;
    print(arg.name + 'en añadir');// imprime en el terminal

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Añadir deuda a ' + arg.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Añadir concepto',
              onPressed: () {
                print('añado');
                int x = int.parse(myImporte.text);
                if (_character == SingingCharacter.ledebes) x = -x;
                constructor.addConcept(
                    arg, myConcepto.text, x); //añado concepto
                //constructor.makeConcepts(0);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 2.5 / 2,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0),
                          bottomLeft: const Radius.circular(5.0),
                          bottomRight: const Radius.circular(5.0),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 300,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              )),
                          child: Center(
                            child: Text(
                              'CONCEPTO:',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: myConcepto,
                          decoration: InputDecoration(
                            labelText: 'concepto',
                          ),
                        ),
                        Container(
                          width: 300,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              )),
                          child: Center(
                            child: Text(
                              'IMPORTE:',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: myImporte,
                          decoration: InputDecoration(
                            labelText: 'importe',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Te debe',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              leading: Radio(
                value: SingingCharacter.tedebe,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Le debes',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              leading: Radio(
                value: SingingCharacter.ledebes,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
          ],
        ));
  }
}
*/

