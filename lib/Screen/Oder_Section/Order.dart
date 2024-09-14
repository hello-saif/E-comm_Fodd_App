import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Enter Your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    login(_email.text.toString(), _password.text.toString());
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text('you have no account? please Register  Now'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login successful: Token: ${data['token']}');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Next(email: email, password: password),
          ),
          (route) => false,
        );
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('error')) {
          print('Error: ${errorData['error']}');
        }
      } else {
        print('Failed login');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _Email = TextEditingController();
  final TextEditingController _Password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderScreen()));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _Email,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Please send email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14))),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _Password,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Please send password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14))),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _Register(
                            _Email.text.toString(), _Password.text.toString());
                      }
                    },
                    child: const Text('Submit'))
              ],
            ),
          ),
        ));
  }

  Future<void> _Register(String _Email, _Password) async {
    try {
      final response = await http.post(
          Uri.parse('https://reqres.in/api/register'),
         // headers: {'Content-Type': 'application/json'},
          body: {'email': _Email, 'password': _Password});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['token']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OrderScreen()),
            (route) => false);
      } else {
        print("Register Failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class Next extends StatefulWidget {
  final String email;
  final String password;
  const Next({super.key, required this.email, required this.password});

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
                (route) => false);
          },
        ),
      ),
      body: Data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weather:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time: ${Data!['hourly']['time'][0]}'),
                          const SizedBox(height: 10),
                          Text(
                              'Temperature: ${Data!['hourly']['temperature_2m'][0]}°C'),
                          const SizedBox(height: 5),
                          Text(
                              'Humidity: ${Data!['hourly']['relative_humidity_2m'][0]}%'),
                          const SizedBox(height: 5),
                          Text(
                              'Wind Speed: ${Data!['hourly']['wind_speed_10m'][0]} m/s'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Map<String, dynamic>? Data;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(); // Fetch the weather data when the screen is initialized
  }

  Future<void> fetchWeatherData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=52.'
              '52&longitude=13.41&current=temperature_2m,wind_spee'
              'd_10m&hourly=temperature_2m,relative_humidity_2m,wind_'
              'speed_10m'));
      if (response.statusCode == 200) {
        setState(() {
          Data = jsonDecode(response.body);
        });
      } else {
        if (kDebugMode) {
          print('Failed to load weather data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }
}
