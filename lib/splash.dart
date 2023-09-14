
import 'package:flutter/material.dart';
import 'package:gramapict/capture.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
class SplashView extends StatefulWidget {
  SplashView({super.key});
  @override
  _SplashView createState() => _SplashView();
}
class  _SplashView extends State<SplashView> {
  // String email = '';


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return   Column(
      children: [
        SizedBox(height: screenHeight/2 - 200),
        Image.asset(
            'assets/back.png',
            fit: BoxFit.fitWidth,
            width: 300,
        ),
        SizedBox(height:30),
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 20, // Set the desired width here
              height : 50,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color.fromRGBO(96, 11, 156, 1), // Set the desired background color
                  foregroundColor: Colors.white, // Set the desired font color
                ),
                onPressed: ()  {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CaptureView()));
                },
                child: Text('Start',style: TextStyle(fontSize: 16)),
              ),
            ),
            Container(
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
                onPressed: () {
                  SystemNavigator.pop();
                  // Add your button's onPressed logic here
                },
                child: Text('Exit',style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ))
      ],
    );
  }
}
