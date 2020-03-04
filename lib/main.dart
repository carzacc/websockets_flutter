import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as statusCodes;

const URL = 'ws://192.168.1.167:3000';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FauxLoginPage(),
    );
  }
}

class FauxLoginPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  void goToMainPage(String nickname, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementPage(nickname)
      )
    );
  }

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Nickname"
              ),
              onSubmitted: (nickname) => goToMainPage(nickname, context),
            ),
            FlatButton(
              onPressed: () => goToMainPage(controller.text, context),
              child: Text("Log In")
            )
          ],
        ),
      )
    );
}

class AnnouncementPage extends StatelessWidget {
  AnnouncementPage(this.nickname);

  final String nickname;

  IOWebSocketChannel channel;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect(URL);
    controller = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    channel = IOWebSocketChannel.connect(URL);

    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: Theme.of(context).textTheme.display1
                );
              },
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter your message here"
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          channel.sink.add("$nickname: ${controller.text}");
        }
      ),
    );
  }
}
