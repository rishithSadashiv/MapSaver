import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:web_socket_channel/io.dart';
import 'my_json.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sender'),
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
  String latitude = '';
  String longitude = '';
  var location = new Location();
  final nameController = TextEditingController();
  final channel = IOWebSocketChannel.connect('ws://192.168.43.151:3000');
  int _counter = 0;
  Map<String, double> userLocation;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return   Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ],
            );
          },
        )




      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _getLocation().then((value) {
            setState(() {
              userLocation = value;
            });
          });
          if(userLocation == null){
            channel.sink.add(nameController.text+'-geo:13.3379,77.1173');
          } else{
            channel.sink.add(jsonEncode(DazzJson(nameController.text,userLocation['latitude'].toString(),userLocation['latitude'].toString())));
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.map),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = (await location.getLocation()) as Map<String, double>;
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
