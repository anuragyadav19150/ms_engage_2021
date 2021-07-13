import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:ms_teams_clone/chat.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

// ignore: must_be_immutable
class IndexPage extends StatefulWidget {
  var _channelController1 = TextEditingController();
  var _channelControllerLog = TextEditingController();
  IndexPage(_channelNameController, userNameController) {
    this._channelController1 = _channelNameController;
    this._channelControllerLog = userNameController;
  }

  @override
  State<StatefulWidget> createState() =>
      IndexState(_channelController1, _channelControllerLog);
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  var _channelController = TextEditingController();
  var _channelControllerLog = TextEditingController();

  /// if channel textField is validated to have error
  // ignore: non_constant_identifier_names
  IndexState(_channelController1, _channelControllerLog1) {
    this._channelController = _channelController1;
    this._channelControllerLog = _channelControllerLog1;
  }

  // ignore: unused_field
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MicroSoft Teams Engage'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 475,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset('assets/ms.png'),
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  'Group Video Call Engage',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Container(
                      child: Image.asset('assets/vid.jpg'),
                      height: MediaQuery.of(context).size.height * 0.36,
                    ),

                    Row(
                      children: [
                        //  Padding(
                        //    padding: const EdgeInsets.symmetric(horizontal: 17),
                        // padding: const EdgeInsets.symmetric(horizontal: 50),
                        // Expanded(
                        RaisedButton(
                          onPressed: onJoin,
                          child: Text('Join Video Call'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          //  ),
                        ),
                        //  Padding(
                        //padding: const EdgeInsets.symmetric(horizontal: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                          child: RaisedButton(
                            //     disabledColor: Colors.red,
                            // disabledTextColor: Colors.black,
                            // padding: const EdgeInsets.all(20),
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp1(
                                      _channelController,
                                      _channelControllerLog),
                                ),
                              );
                            },
                            child: Text('MESSENGER'),
                            //  ),
                          ),
                        ),
                      ],
                    ),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(_channelController.text, _role,
              _channelController, _channelControllerLog),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
