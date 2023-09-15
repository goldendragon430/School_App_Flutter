import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ResultView extends StatefulWidget {
  final List<dynamic> result1;
  final List<dynamic> result2;
  ResultView({super.key, required this.result1, required this.result2});
  @override
  _ResultView createState() => _ResultView();
}
class  _ResultView extends State<ResultView> {
  String result = '';
  int count = 0;
  List<dynamic> src1 = [];
  List<dynamic> src2 = [];
  String ID = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      src1 = widget.result1;
      src2 = widget.result2;
      result = '';
      count = 0;
      for(int i = 1; i <= 25; i++){
        if(src1[i-1] != src2[i-1]){
          result+='$i:${src2[i - 1]} ';
          count ++;
        }
      }
    });
  }
  @override
  void dispose() {

    super.dispose();
  }
  Future<void> _showMyDialog(context,String path) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(path),
               ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _generateCsvFile(context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if(ID == '')
      return;
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("Result");
    for (int i = 0; i < 25; i ++)
      row.add(src2[i]);
    rows.add(row);
    List<dynamic> row2 = [];
    row2.add("Wrong");

    for(int i = 1; i <= 25; i++){
      if(src1[i-1] != src2[i-1]){
        row2.add('F');
      }
      else{
        row2.add('T');
      }
    }
    rows.add(row2);

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File(file + "/$ID.csv");

    f.writeAsString(csv);
    _showMyDialog(context,file + "/$ID.csv");

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    TextEditingController nameEditController = TextEditingController();
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Download CSV'),
        ), //AppBar
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 50,
                width: screenWidth - 20,
                child:
                Container(
                    margin:EdgeInsets.only(left:20),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Student ID',
                      ),
                      onChanged: (value){
                        setState(() {
                          ID = value;
                        });
                      },
                    )
                )

            ),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text('Wrong Picked:', style: TextStyle(fontSize: 24)),
                Text(result, style: TextStyle(fontSize: 20, color: Colors.red)),
                Text('Total: $count out of 25', style: TextStyle(fontSize: 24))

              ],
            )),
            Center(child: Container(
              width: MediaQuery.of(context).size.width - 20, // Set the desired width here
              height : 50,
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color.fromRGBO(96, 11, 156, 1), // Set the desired background color
                  foregroundColor: Colors.white, // Set the desired font color
                ),
                onPressed: (){
                  _generateCsvFile(context);
                },
                child: Text('Save',style: TextStyle(fontSize: 16)),
              ),
            )),
            Center(child: Container(
              width: MediaQuery.of(context).size.width - 20, // Set the desired width here
              height : 50,
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color.fromRGBO(96, 11, 156, 1), // Set the desired background color
                  foregroundColor: Colors.white, // Set the desired font color
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel',style: TextStyle(fontSize: 16)),
              ),
            ))
          ],
        ),

    );
  }
}
