import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key); // ✅ Use null safety

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat; // ✅ Declare as late if assigning later

  List<ChatModel> chatmodels = [
    ChatModel(
      name: "Dev Stack",
      isGroup: false,
      currentMessage: "Hi Everyone",
      time: "4:00",
      icon: Icons.person, // ✅ CORRECT, this is IconData

      id: 1,
      status: '',
    ),
    ChatModel(
      name: "Kishor",
      isGroup: false,
      currentMessage: "Hi Kishor",
      time: "13:00",
      icon: Icons.person, // ✅ CORRECT, this is IconData
      id: 2,
      status: '',
    ),
    ChatModel(
      name: "Collins",
      isGroup: false,
      currentMessage: "Hi Dev Stack",
      time: "8:00",
      icon: Icons.person, // ✅ CORRECT, this is IconData
      id: 3,
      status: '',
    ),
    ChatModel(
      name: "Balram Rathore",
      isGroup: false,
      currentMessage: "Hi Dev Stack",
      time: "2:00",
      icon: Icons.person, // ✅ CORRECT, this is IconData
      id: 4,
      status: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatmodels.length,
        itemBuilder: (context, index) {
          final selectedChat = chatmodels[index];
          return InkWell(
            onTap: () {
              setState(() {
                sourceChat = selectedChat;
                chatmodels.removeAt(index);
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homescreen(
                    chatmodels: chatmodels,
                    sourchat: sourceChat,
                  ),
                ),
              );
            },
            child: ButtonCard(
              name: selectedChat.name,
              icon: Icons.person, key: null,
            ),
          );
        },
      ),
    );
  }
}
