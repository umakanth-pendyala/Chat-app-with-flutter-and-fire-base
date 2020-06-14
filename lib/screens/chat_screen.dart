import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseUser loggedInUser;
String index;

class ChatScreen extends StatefulWidget {
  static const String chatScreenRoute = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth
      .instance; // this is a static instance and may be thats why i got access to same user even on this page.
  final _fireStore = Firestore.instance;
  String userMessage;
  final messageTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void printDocumentsInDataBase() async {
    try {
      var messages = await _fireStore.collection('messages').getDocuments();
      for (var message in messages.documents) {
        print(message.data);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    try {
      await for (var snapshot
          in _fireStore.collection('messages').snapshots()) {
        for (var document in snapshot.documents) {
          print(document.data);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
//                printDocumentsInDataBase();
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').orderBy('creation',descending: true).snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('i have data');
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                else {
                  print('i dont have any data');
                }
                print(snapshot.data.documents);
                final messages = snapshot.data.documents;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message.data['text'];
                  final messageSender = message.data['sender'];

                  final currentUser = loggedInUser.email;

                  final messageBubble = MessageBubble(
                    messageText: messageText,
                    messageSender: messageSender,
                    isMe: currentUser == messageSender,
                  );
                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        userMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (userMessage != null) {
                        messageTextController.clear();
                        //Implement send functionality.
                        _fireStore.collection('messages').add(
                            {'sender': loggedInUser.email, 'text': userMessage, 'created': Timestamp.now()});
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText, messageSender;
  final bool isMe;

  MessageBubble({this.messageText, this.messageSender, this.isMe});

  @override
  Widget build(BuildContext context) {

    Color getSutableColor() {
      if (isMe == true) {
        return Colors.lightBlueAccent;
      }
      else {
        return Color(0xFFeC5252);
      }
    }

    CrossAxisAlignment setAlignment () {
      if (isMe == true) {
        return CrossAxisAlignment.end;
      }
      else {
        return CrossAxisAlignment.start;
      }
    }

    BorderRadius setRadius () {
      if (isMe == true) {
        return BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30));
      } else {
        return BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: setAlignment(),
        children: <Widget>[
          Text(messageSender, style: TextStyle(color: Colors.grey, fontSize: 13.0),),
          Material(
            borderRadius: setRadius(),
            color: getSutableColor(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
            '$messageText',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
              )),
        ],
      ),
    );
    ;
  }
}
