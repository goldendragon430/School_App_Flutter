
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

class ResultView extends StatefulWidget {
  final XFile image;

  ResultView({super.key, required this.image});
  @override
  _ResultView createState() => _ResultView();
}
class  _ResultView extends State<ResultView> {
  bool  isGenerating = false;
  String generatedImg = '';
  String generatedTxt = '';
  final dio = Dio();

  double _linePosition = 0.0;
  Timer? _timer;
  final double _lineSpeed = 1.0;
  final double _lineHeight = 2.0;
  double _lineWidth = 200.0;
  double _containerHeight = 200.0;
  final Color _lineColor = Colors.green;
  final Duration _timerDuration = Duration(milliseconds: 20);
  String email = '';
  TextEditingController emailEditController = TextEditingController();
  bool isEmailValid(String email) {
    // Regular expression pattern for email validation
    final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lineWidth = MediaQuery.of(context).size.width; // Get screen width
    _containerHeight = MediaQuery.of(context).size.height - 200; // Get screen width
    // _startTimer();
  }
  void sendRequest(context) async{
    final formData = FormData.fromMap({
      'des_email' : email ,
      'docfile': await MultipartFile.fromFile(widget.image.path ,filename: widget.image.name),
    });
    setState(() {
      isGenerating = true;
    });
    _startTimer();
    try{
      final response = await dio.post('http://137.184.0.54:8000/img', data: formData);
      if(response.data['result'] == 'InValid Input Image'){
         AlertController.show('Error', 'Invalid Input Image', TypeAlert.error);
      }else{
        setState(() {
          generatedImg = response.data['result'];
          generatedTxt = response.data['txt'];
        });
      }
    }catch(e){
      print('error caught: $e');
    }
    setState(() {
      isGenerating = false;
    });
    _timer?.cancel();
  }
  void sendEmailRequest() async{
    final formData = FormData.fromMap({
      'des_email' : email ,
      'img_url' : generatedImg,
      'img_txt' : generatedTxt
    });
    try{
      final response = await dio.post('http://137.184.0.54:8000/email', data: formData);
      if(response.data['result'] == 'success'){
        AlertController.show('Success', 'Sent Email', TypeAlert.success);
      }else{
        AlertController.show('Error', 'Server error', TypeAlert.error);
      }
    }catch(e){
      print('error caught: $e');
    }
  }
  void generateImage(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          child: AlertDialog(
            title: Text('Email generated image:',style: TextStyle(fontSize: 20),),
            content:
                   TextFormField(
                      controller: emailEditController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14
                      ),
                      decoration: InputDecoration(
                        hintText: 'Please enter your email',
                      ),
                      onChanged: (value){
                        setState(() {
                          email = value;
                        });
                      },
                    ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if(isEmailValid(email) == false){
                    emailEditController.text = 'inValid Email';
                    return;
                  }
                  sendEmailRequest();
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    email = '';
                  });

                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _startTimer() {
    _timer = Timer.periodic(_timerDuration, (timer) {
      setState(() {
        _linePosition += _lineSpeed;
        if (_linePosition > _containerHeight) {
          _linePosition = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('OCR and Generate Image'),
        ), //AppBar
        body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(child: Center(child:
                          GestureDetector(
                                child: generatedImg == '' ?Image.file(File(widget.image.path), fit: BoxFit.cover, width: screenWidth - 20,height :screenHeight - 20): Image.network(generatedImg),
                                onTap: () {
                                  print(generatedImg);
                                  if(generatedImg != '')
                                      generateImage(context);
                                },
                            )
                      )),
                      Center(child: Container(
                        width: MediaQuery.of(context).size.width - 20, // Set the desired width here
                        height : 50,
                        margin: EdgeInsets.only(top:10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color.fromRGBO(214, 19, 95, 1), // Set the desired background color
                            foregroundColor: Colors.white, // Set the desired font color
                          ),
                          onPressed:(){
                            Navigator.pop(context);
                          },
                          child: Text('Recapture',style: TextStyle(fontSize: 16)),
                        ),
                      )),
                      Center(child: Container(
                        width: MediaQuery.of(context).size.width - 20, // Set the desired width here
                        height : 50,
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color.fromRGBO(214, 19, 95, 1), // Set the desired background color
                            foregroundColor: Colors.white, // Set the desired font color
                          ),
                          onPressed:(){

                            if(isGenerating == false)
                              sendRequest(context);
                          },
                          child: Text(isGenerating?'Generating':'Generate',style: TextStyle(fontSize: 16)),
                        ),
                      ))
                    ],
                  ), //Text
                  if(isGenerating)
                    Positioned(
                    top: _linePosition,
                    child: AnimatedContainer(
                      duration: _timerDuration,
                      height: _lineHeight,
                      width: _lineWidth,
                      color: _lineColor,
                    ),
                  ),
                ],
              ),

    );
  }
}
