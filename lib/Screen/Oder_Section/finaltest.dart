import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderScreen7 extends StatefulWidget {
  const OrderScreen7({super.key});

  @override
  _OrderScreen7State createState() => _OrderScreen7State();
}

class _OrderScreen7State extends State<OrderScreen7> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {},
          ),
          title: const Text('Test'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      login(_email.text.toString(), _password.text.toString());
                    }
                  },
                  child: const Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                            (route) => false);
                  },
                  child: const Text('Please Register First'))
            ],
          ),
        ));
  }

  Future<void> login(String _email, _password) async {
    final response =
    await http.post(Uri.parse('https://reqres.in/api/login'), body: {
      'email': _email,
      'password': _password,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['token']);
      print('Login Success');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                email: _email,
                password: _password,
              )),
              (route) => false);
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      if (error.containsKey('error')) {
        print('${error['error']}');
      }
    } else {
      print('failed');
    }
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _email1 = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OrderScreen7()),
                    (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _email1,
                decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _password1,
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    SignUp( _email1.text.toString(), _password1.text.toString());
                  }
                },
                child: Text('SignUp'))
          ],
        ),
      ),
    );
  }

  Future<void> SignUp(String  _email1, _password1) async {
    final response = await http.post(
        Uri.parse('https://reqres.in/api/register'),
        body: {
          'email': _email1,
          'password': _password1
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['token']);
      print('Register Success');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OrderScreen7()), (route) => false);
    } else {
      print('Register Failed');
    }
  }
}

class Profile extends StatefulWidget {
  String email;
  String password;
  Profile({super.key, required this.email, required this.password});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _addtask = TextEditingController();

  Map<String,dynamic>? Users;
  Future<void> weather()async {
    final response= await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m'));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      Users=data['hourly'];
      print(Users);

    }else{
      print('Error Weather');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather();
  }

  @override
  Widget build(BuildContext context) {
    final counterprovider = Provider.of<CounterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
                    (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.email),
      ),
      body:
      Column(
        children: [
          //weather api.
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Users!=null ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: ${Users!['time'][1]}'),
                      Text('Temperature: ${Users!['temperature_2m'][0]} °C'),
                      Text('Humidity: ${Users!['relative_humidity_2m'][0]} %'),
                      Text('Wind: ${Users!['wind_speed_10m'][0]} km/h')
                    ],
                  ),
                ):
                const Center(child: CircularProgressIndicator(),)


              ],
            ),
          ),


          Row(
            children: [
              Text('Count Task: ${counterprovider.task.length.toString()}'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _name,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  )),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _addtask,
              decoration: InputDecoration(
                  hintText: 'Add Task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  )),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (_name.text.isNotEmpty && _addtask.text.isNotEmpty) {
                  counterprovider.addtask(_name.text, _addtask.text);
                  _addtask.clear();
                  _name.clear();
                }
              },
              child: Text('Add')),
          Expanded(
              child: ListView.builder(
                  itemCount: counterprovider.task.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            'Name: ${counterprovider.task[index]['task']}'),
                        subtitle: Text(
                            'Task: ${counterprovider.task[index]['name']}'),
                        trailing: IconButton(
                          onPressed: () {
                            counterprovider.removetask(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterProvider extends ChangeNotifier {
  List<Map<String, String>> _task = [];
  List<Map<String, String>> get task => _task;
  void addtask(String task, String name) {
    _task.add({'task': task, 'name': name});
    notifyListeners();
  }

  void removetask(int index) {
    _task.removeAt(index);
    notifyListeners();
  }
}
