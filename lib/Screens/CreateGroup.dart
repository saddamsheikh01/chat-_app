import 'package:flutter/material.dart';
import 'package:chatapp/CustomUI/AvtarCard.dart';
import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/CustomUI/ContactCard.dart';
import 'package:chatapp/Model/ChatModel.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(name: "Dev Stack", status: "A full stack developer"),
    ChatModel(name: "Balram", status: "Flutter Developer..........."),
    ChatModel(name: "Saket", status: "Web developer..."),
    ChatModel(name: "Bhanu Dev", status: "App developer...."),
    ChatModel(name: "Collins", status: "React developer.."),
    ChatModel(name: "Kishor", status: "Full Stack Web"),
    ChatModel(name: "Testing1", status: "Example work"),
    ChatModel(name: "Testing2", status: "Sharing is caring"),
    ChatModel(name: "Divyanshu", status: "....."),
    ChatModel(name: "Helper", status: "Love you Mom Dad"),
    ChatModel(name: "Tester", status: "I find the bugs"),
  ];

  List<ChatModel> groupMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "New Group",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text(
              "Add participants",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF128C7E),
        onPressed: () {},
        child: const Icon(Icons.arrow_forward),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: groupMembers.isNotEmpty ? 90 : 10);
              }
              final contact = contacts[index - 1];
              return InkWell(
                onTap: () {
                  setState(() {
                    contact.select = !(contact.select ?? false);
                    if (contact.select == true) {
                      groupMembers.add(contact);
                    } else {
                      groupMembers.remove(contact);
                    }
                  });
                },
                child: ContactCard(contact: contact, key: null,),
              );
            },
          ),
          if (groupMembers.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: 75,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groupMembers.length,
                      itemBuilder: (context, index) {
                        final member = groupMembers[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              member.select = false;
                              groupMembers.remove(member);
                            });
                          },
                          child: AvatarCard(chatModel: member, key: null,),
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 1),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
