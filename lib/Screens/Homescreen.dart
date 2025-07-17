import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Pages/CameraPage.dart';
import 'package:chatapp/Pages/ChatPage.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({
    super.key,
    required this.chatmodels,
    required this.sourchat,
  });

  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) => debugPrint(value),
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem(value: "New group", child: Text("New group")),
              PopupMenuItem(value: "New broadcast", child: Text("New broadcast")),
              PopupMenuItem(value: "WhatsApp Web", child: Text("WhatsApp Web")),
              PopupMenuItem(value: "Starred messages", child: Text("Starred messages")),
              PopupMenuItem(value: "Settings", child: Text("Settings")),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "CHATS"),
            Tab(text: "STATUS"),
            Tab(text: "CALLS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraPage(key: ValueKey('camera')),
          ChatPage(
            chatmodels: widget.chatmodels,
            sourchat: widget.sourchat,
          ),
          const Center(child: Text("STATUS")),
          const Center(child: Text("CALLS")),
        ],
      ),
    );
  }
}
