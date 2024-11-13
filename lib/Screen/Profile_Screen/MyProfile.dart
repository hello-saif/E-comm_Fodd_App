import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _email =TextEditingController();
  final TextEditingController _password=TextEditingController();
  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
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
        key: _formkey,
        child:Column(
          children: [
            SizedBox(
              height: 14,
            ),
            Center(
              child: Text('Login Page'),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),

                    )
                ),
              ),
            ),
            SizedBox(height: 14,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)
                    )
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            ElevatedButton(onPressed: (){
              if(_formkey.currentState!.validate()){
                _Login(_email.text.toString(),_password.text.toString());

              }

            }, child: Text('Login'))
          ],
        ),

      )
    );
  }

  Future<void> _Login(   String _e,_p ,)async {
    final response = await http.post(Uri.parse('https://reqres.in/api/login'),
    body: {
      'email':_e,
      'password':_p,
    }
    );
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      print(data['token']);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Test(
        email:_e,
        password:_p,
      )), (route) => false);
     }else if(response.statusCode==400){
      final errordata=jsonDecode(response.body);
      if(errordata.containsKey('error')){
        print('${errordata['error']}');
      }
    }
    else{
      print('failed');
    }


  }


}
class Test extends StatefulWidget {
  const Test({super.key, required String email, required password, });

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<dynamic> dad=[];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { 
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyProfile()), (route) => false);
        }, icon: Icon(CupertinoIcons.back),
          
        ),
        title: Text("ok"),
      ),
      body: ListView.builder(
        itemCount: dad.length,
          itemBuilder: (context ,index){
          final user=dad[index];
          final Address= user['hair']['color'];
          final Address1= user['hair']['type'];
          //coordinates
          final Address2 =user ['address']['coordinates']['lat'];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  '${user['image']}'
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${user['firstName']}'),
                      SizedBox(width: 5,),
                      Text('${Address}'),
                      SizedBox(width: 5,),
                      Text('${Address1}'),
                    ],
                  ),
                ],
              ),
              subtitle: Text('${Address2}'),
            ),
          );
          })
    );
  }
  Future<void>_testing()async{
    final response= await http.get(Uri.parse('https://dummyjson.com/users/'));
    if(response.statusCode==200){
      final data =jsonDecode(response.body);
      dad =data['users'];
      if (kDebugMode) {
        print(dad);
      }

    }else{
      print('error List');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _testing();
  }
}
