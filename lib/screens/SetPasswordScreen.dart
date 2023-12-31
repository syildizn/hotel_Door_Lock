import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SetPassword extends StatefulWidget {
  static String routeName = 'SetPasswordScreen';
  const SetPassword({Key? key}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {

  TextEditingController _kodController = TextEditingController();
  String _feedbackMessage = '';

  Future<void> _sendRequest(String kod) async {
    final ipAddress = '192.168.68.112'; // ESP32'nin IP adresi
    final url = Uri.http(ipAddress, '/kapikodu', {'kod': kod});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _feedbackMessage = 'Şifre Değişti';
      });
    } else if (response.statusCode == 401) {
      setState(() {
        _feedbackMessage = 'Şifre değişirken hata oluştu';
      });
    } else {
      setState(() {
        _feedbackMessage = 'Bir hata oluştu';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şifre Değiştir'),
        actions: [
          IconButton(
              onPressed: () {
               // Navigator.pushNamed(context, SetPassword.routeName);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _kodController,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0),),
                  labelText: 'Kapının Yeni Kodu',fillColor:Colors.orangeAccent ,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String kod = "SET${_kodController.text}";
                  print("$kod");
                  _sendRequest(kod);
                },
                child: Text('Şifreyi Değiştir'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _feedbackMessage,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
