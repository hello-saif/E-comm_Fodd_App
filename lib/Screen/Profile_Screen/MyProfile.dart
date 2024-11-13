import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
                (route) => false);
          },
        ),
        title: const Text('Update Profile'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.ice_skating))],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('Login Page', style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: ' Enter your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: ' Enter your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login(_email.text.toString(), _password.text.toString());
                  }
                },
                child: const Icon(Icons.login)),
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Test1()),
                          (route) => false);
                },
                child: const Text(
                  'Register Now',
                  style: TextStyle(color: Colors.red, fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _login(String _email, _password) async {
    final response = await http.post(Uri.parse('https://reqres.in/api/login'),
        body: {'email': _email, 'password': _password});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['token']);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Test(email: _email, password: _password)),
          (route) => false);
    }else if(response.statusCode==400){
      final errordata=jsonDecode(response.body);
      if(errordata.containsKey('error')){
        print('${errordata['error']}');
      }
    } else {
      print('Login error');
    }
  }

}
class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {

  final TextEditingController _email1 = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Form(
        key: _formKey1,
        child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            const Text('Register Page', style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _email1,
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: ' Enter your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _password1,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: ' Enter your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    )),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if(_formKey1.currentState!.validate()){
                    _register(_email1.text.toString(),_password1.text.toString());
                  }

                },
                child: const Icon(Icons.login)),
          ],
        ),
      ),

    );
  }
  Future<void> _register(String _email1, _password1)async{
    final response = await http.post(Uri.parse('https://reqres.in/api/register'),
    body: {
      'email':_email1,
      'password':_password1
    });
    if(response.statusCode==200){
      final data =jsonDecode(response.body);
      print(data['token']);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyProfile()), (route) => false);
    }else{
      print('register error');
    }

  }
}

class Test extends StatefulWidget {
  const Test({
    super.key,
    required String email,
    required password,
  });

  @override
  State<Test> createState() => _TestState();
}
// https://dummyjson.com/users
class _TestState extends State<Test> {
   Map<String, dynamic>? onedata;
 // List<dynamic> dad=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
                (route) => false);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text("ok"),
      ),
      body: onedata==null ?Center(child: Text('Error'),) :Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
         child: ListTile(
           leading: CircleAvatar(
             backgroundImage: NetworkImage(
               '${onedata!['image']}'
             ),
           ),
           title: Text('${onedata!['firstName']}'),
         ),


        ),
      ),

    );
  }
  Future<void> maam()async{
    final response=await http.get(Uri.parse('https://dummyjson.com/users/3'));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      onedata =data;
      print(onedata);
    }else{
      print('Error List');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maam();
  }
}
