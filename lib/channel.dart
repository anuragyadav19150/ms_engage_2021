import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:ms_teams_clone/src/pages/index.dart';

// ignore: camel_case_types
class channel extends StatefulWidget {
  channel({Key key}) : super(key: key);

  @override
  _channelState createState() => _channelState();
}

bool _isLogin = false;
bool _isInChannel = false;

var _userNameController = TextEditingController();

var _channelNameController = TextEditingController();

final _infoStrings = <String>[];

AgoraRtmClient _client;
// ignore: unused_element
AgoraRtmChannel _channel;

// ignore: camel_case_types
class _channelState extends State<channel> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('MicroSoft Teams Engage'),
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                //  height: 600,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/ms.png'),
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      // Padding(padding: EdgeInsets.only(top: 10)),
                      // Text(
                      //   ' Group Video Call Engage',
                      //   style: TextStyle(
                      //       color: Colors.deepPurple,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      Container(
                        child: Image.asset('assets/5.jpg'),
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      // Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                        child: Column(
                          children: [
                            _buildLogin(),
                            _buildJoinChannel(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance("2c40136406f04ab0a160c9573401ce25");
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
  }

  static TextStyle textStyle =
      TextStyle(fontSize: 15, color: Colors.blueAccent);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      _isLogin
          ? new Expanded(
              child: new Text('User Id: ' + _userNameController.text,
                  style: textStyle))
          : new Expanded(
              child: new TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(hintText: 'Input your Name'))),
      // ignore: deprecated_member_use
      new OutlineButton(
        child: Text(_isLogin ? 'Exit' : 'Enter', style: textStyle),
        onPressed: _toggleLogin,
      )
    ]);
  }

  Widget _buildJoinChannel() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      _isInChannel
          ? new Expanded(
              child: new Text('Channel: ' + _channelNameController.text,
                  style: textStyle))
          : new Expanded(
              child: new TextField(
                  controller: _channelNameController,
                  decoration: InputDecoration(hintText: 'Input channel id'))),
      // ignore: deprecated_member_use
      new RaisedButton(
        padding: const EdgeInsets.all(8),
        textColor: Colors.blue,
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IndexPage(_channelNameController, _userNameController),
            ),
          );
        },
        child: Text('LogIn'),
      ),
    ]);
  }

  void _toggleLogin() async {
    if (_isLogin) {
      try {
        await _client.logout();
        _log('Logout success.');

        setState(() {
          _isLogin = false;
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Logout error: ' + errorCode.toString());
      }
    } else {
      String userId = _userNameController.text;
      if (userId.isEmpty) {
        _log('Please input your user id to login.');
        return;
      }

      try {
        await _client.login(null, userId);
        _log('Login success: ' + userId);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
