
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:image_picker/image_picker.dart';

class CaptureView extends StatefulWidget {
  const CaptureView({super.key});
  @override
  _CaptureView createState() => _CaptureView();
}
class  _CaptureView extends State<CaptureView> {
  bool flag = false;
  XFile? teacherFile;
  XFile? studentFile;
  final dio = Dio();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }
  Future checkPhotos() async {
    setState(() {
      flag = true;
    });
    try{
      if(teacherFile == null || studentFile == null)
        return;
      final formData = FormData.fromMap({
        'teach_file': await MultipartFile.fromFile(teacherFile!.path ,filename: teacherFile!.name),
        'student_file': await MultipartFile.fromFile(studentFile!.path ,filename: studentFile!.name),
      });
      print(formData);
      // final response = await dio.post('http://137.184.0.54:8000/img', data: formData);
      // if(response.data['result'] == 'InValid Input Image'){
      //   AlertController.show('Error', 'Invalid Input Image', TypeAlert.error);
      // }else{
      //   setState(() {
      //     // generatedImg = response.data['result'];
      //     // generatedTxt = response.data['txt'];
      //   });
      // }
    }catch(e){
      print('error caught: $e');
    }
  }
  Future pickTeacherFile() async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        teacherFile = pickedFile;

      });

    }
  }
  Future pickStudentFile() async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        studentFile = pickedFile;
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
          title: const Text('Upload Image'),
        ), //AppBar
        body:
            Column(
              children: [
                Expanded(child: Container(
                width: MediaQuery.of(context).size.width - 20,
                child: ListView(
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
                            child: teacherFile == null ? Image.asset('assets/teacher.png',width: 180) : Image.file(File(teacherFile!.path),width: screenWidth - 20),
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
                              child: studentFile == null ? Image.asset('assets/student.png',width: 180) : Image.file(File(studentFile!.path),width: screenWidth - 20),
                              onTap: pickStudentFile,
                            )
                          ],
                        )
                    )
                  ],
                )
                )),
                if(flag == true) Center(child: Text('Score: 10 (25/25)',style: TextStyle(color: Colors.blue),)),
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

                    },
                    child: Text('Download as CSV',style: TextStyle(fontSize: 16)),
                  ),
                ))
              ],
            ) //Text
      );
  }
}
