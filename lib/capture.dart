
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gramapict/result.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

class CaptureView extends StatefulWidget {
  const CaptureView({super.key});
  @override
  _CaptureView createState() => _CaptureView();
}
class  _CaptureView extends State<CaptureView> {
  bool flag = true;
  XFile? teacherFile;
  XFile? studentFile;
  String scoreString = '';
  final dio = Dio();
  String result_img_1 = '';
  String result_img_2 = '';
  List<dynamic> result_1_array = [];
  List<dynamic> result_2_array = [];
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  String generateRandomString(int length) {
    const String charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    String result = '';

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(charset.length);
      result += charset[randomIndex];
    }

    return result;
  }
  Future checkPhotos() async {
    setState(() {
      flag = true;
    });
    try{
      if(teacherFile == null || studentFile == null)
        return;
      setState(() {
        flag = false;
      });
      final formData = FormData.fromMap({
        'teach_file': await MultipartFile.fromFile(teacherFile!.path ,filename: generateRandomString(10) + '.png' ),
        'student_file': await MultipartFile.fromFile(studentFile!.path ,filename: generateRandomString(10) + '.png'),
      });

      final response = await dio.post('http://109.123.231.170:8000', data: formData);
      if(response.data['result'] == 'InValid Input Image'){

      }else{

          final result1 = response.data['result1'];
          final result2 = response.data['result2'];
          final url1 = response.data['url1'];
          final url2 = response.data['url2'];

          String img_url_1 = 'http://109.123.231.170:8000/?filename=$url1';
          String img_url_2 = 'http://109.123.231.170:8000/?filename=$url2';

          int count = 0;
          for(int i = 0 ; i < 25; i ++){
            if (result1[i]== result2[i]) count ++;
          }

          double d = (count * 10 / 25).toDouble();
          double roundedD = double.parse(d.toStringAsFixed(2));
          setState(() {
            scoreString = 'Score: ${(roundedD).toDouble()} ($count/25)';
            result_img_1 = img_url_1;
            result_img_2 = img_url_2;
            result_1_array = result1 ;
            result_2_array = result2 ;
          });
      }
      setState(() {
        flag = true;
      });
    }catch(e){
      print('error caught: $e');
    }
  }
  Future pickTeacherFile() async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        teacherFile = pickedFile;
        result_img_1 = '';
      });

    }
  }
  Future pickStudentFile() async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        studentFile = pickedFile;
        result_img_2 = '';
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Analyze Test'),
        ), //AppBar
        body:
            Column(
              children: [
                Expanded(child: Container(
                width: MediaQuery.of(context).size.width - 20,
                child: flag == false ? Center(child:CircularProgressIndicator()) : ListView(
                  children: [
                    SizedBox(
                      width: screenWidth - 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Teacher',style: TextStyle(
                              fontSize: 20
                          )),
                          GestureDetector(
                            child: teacherFile == null ? Image.asset('assets/teacher.png',width: 180) : (result_img_1 == '' ? Image.file(File(teacherFile!.path),width: screenWidth - 20) : Image.network(result_img_1)),
                            onTap: pickTeacherFile,
                          )

                        ],
                      )
                    ),
                    SizedBox(
                        width: screenWidth - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Student',style: TextStyle(
                                fontSize: 20
                            )),
                            GestureDetector(
                              child: studentFile == null ? Image.asset('assets/student.png',width: 180) : (result_img_2 == '' ? Image.file(File(studentFile!.path),width: screenWidth - 20) : Image.network(result_img_2)),
                              onTap: pickStudentFile,
                            )
                          ],
                        )
                    )
                  ],
                )
                )),
                if(flag == true) Center(child: Text(scoreString,style: TextStyle(color: Colors.blue),)),
                SizedBox(height: 5),
                Center(child: Container(
                  width: MediaQuery.of(context).size.width - 20, // Set the desired width here
                  height : 50,
                  margin: EdgeInsets.only(bottom: 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(96, 11, 156, 1), // Set the desired background color
                      foregroundColor: Colors.white, // Set the desired font color
                    ),
                    onPressed: checkPhotos,
                    child: Text('Check',style: TextStyle(fontSize: 16)),
                  ),
                )),
                SizedBox(height: 10),
                Center(child: Container(
                  width: MediaQuery.of(context).size.width - 20, // Set the desired width here
                  height : 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(96, 11, 156, 1), // Set the desired background color
                      foregroundColor: Colors.white, // Set the desired font color
                    ),
                    onPressed: (){
                      if(result_1_array.length == 0 || result_2_array.length == 0) {
                        return;
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ResultView(result1: result_1_array, result2: result_2_array)));
                    },
                    child: Text('Download as CSV',style: TextStyle(fontSize: 16)),
                  ),
                ))
              ],
            ) //Text
      );
  }
}
