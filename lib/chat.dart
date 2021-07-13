import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtm/agora_rtm.dart';

// ignore: must_be_immutable
class MyApp1 extends StatefulWidget {
  var _channelNameController2 = TextEditingController();
  var _channelControllerLog3 = TextEditingController();
  MyApp1(_channelController1, _channelControllerLog) {
    this._channelNameController2 = _channelController1;
    this._channelControllerLog3 = _channelControllerLog;
  }
  _MyApp1State createState() =>
      _MyApp1State(_channelNameController2, _channelControllerLog3);
}

class _MyApp1State extends State<MyApp1> {
  bool _isLogin = false;
  bool _isInChannel = false;

  var _userNameController = TextEditingController();
  final _peerUserIdController = TextEditingController();
  final _peerMessageController = TextEditingController();
  var _channelNameController = TextEditingController();
  final _channelMessageController = TextEditingController();

  _MyApp1State(_channelController1, _channelControllerLog) {
    this._channelNameController = _channelController1;
    this._userNameController = _channelControllerLog;
  }

  final _infoStrings = <String>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // debugShowCheckedModeBanner: false,
          appBar: AppBar(
            title: const Text('MicroSoft Teams Engaged'),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildGetMembers(),
                _buildSendChannelMessage(),
                _buildInfoList(),
                Row(
                  children: [
                    Container(
                      child: Image.asset('assets/ms2.png'),
                      height: MediaQuery.of(context).size.height * 0.072,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance("2c40136406f04ab0a160c9573401ce25");
    _toggleLogin();
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) {
      _log(
          "Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      _log("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _log("Channel msg: " + member.userId + ", msg: " + message.text);
    };
    return channel;
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _channelMessageController,
              decoration: InputDecoration(hintText: 'Input channel message'))),
      new RawMaterialButton(
        onPressed: _toggleSendChannelMessage,
        child: Icon(
          Icons.send,
          //  color: muted ? Colors.white : Colors.blueAccent,
          size: 20.0,
        ),
        shape: CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.blueAccent,
        padding: const EdgeInsets.all(12.0),
      ),
    ]);
  }

  Widget _buildGetMembers() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(45, 10, 0, 5),
      child: Row(children: <Widget>[
        new OutlineButton(
          child: Text('Get Members in Channel', style: textStyle),
          onPressed: _toggleGetMembers,
        )
      ]),
    );
  }

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
            child: ListView.builder(
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    )));
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
        _toggleJoinChannel();
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }

  void _toggleQuery() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to query.');
      return;
    }
    try {
      Map<dynamic, dynamic> result =
          await _client.queryPeersOnlineStatus([peerUid]);
      _log('Query result: ' + result.toString());
    } catch (errorCode) {
      _log('Query error: ' + errorCode.toString());
    }
  }

  void _toggleSendPeerMessage() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send message.');
      return;
    }

    String text = _peerMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      _log(message.text);
      await _client.sendMessageToPeer(peerUid, message, false);
      _log('Send peer message success.');
    } catch (errorCode) {
      _log('Send peer message error: ' + errorCode.toString());
    }
  }

  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel.leave();
        _log('Leave channel success.');
        _client.releaseChannel(_channel.channelId);
        _channelMessageController.text = null;

        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Leave channel error: ' + errorCode.toString());
      }
    } else {
      String channelId = _channelNameController.text;
      if (channelId.isEmpty) {
        _log('Please input channel id to join.');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel.join();
        _log('Join channel success.');

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        _log('Join channel error: ' + errorCode.toString());
      }
    }
  }

  void _toggleGetMembers() async {
    try {
      List<AgoraRtmMember> members = await _channel.getMembers();
      _log('Members: ' + members.toString());
    } catch (errorCode) {
      _log('GetMembers failed: ' + errorCode.toString());
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }
    try {
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log((_userNameController.text + " - " + text));
    } catch (errorCode) {
      _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
