import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

// substitute your server's IP and port
const YOUR_SERVER_IP = 'SERVER_IP';
const YOUR_SERVER_PORT = 'SERVER_PORT':
const URL = 'ws://$YOUR_SERVER_IP:$YOUR_SERVER_PORT';

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

  final IOWebSocketChannel channel = IOWebSocketChannel.connect(URL);
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    

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
                return snapshot.hasData ? 
                  Text(
                    snapshot.data.toString(),
                    style: Theme.of(context).textTheme.display1
                  )
                  :
                  CircularProgressIndicator();
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
