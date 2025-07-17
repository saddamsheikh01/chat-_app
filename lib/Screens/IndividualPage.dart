import 'package:chatapp/CustomUI/OwnMessgaeCrad.dart';
import 'package:chatapp/CustomUI/ReplyCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IndividualPage extends StatefulWidget {
  const IndividualPage({
    super.key,
    required this.chatModel,
    required this.sourchat,
  });

  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  final List<MessageModel> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() => show = false);
      }
    });

    connect();
  }

  void connect() {
    socket = IO.io(
      "http://192.168.0.106:5000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint("Connected to socket.io server");
      socket.emit("signin", widget.sourchat.id);

      socket.on("message", (msg) {
        setMessage("destination", msg["message"]);
        scrollToBottom();
      });
    });
  }

  void sendMessage(String message, int sourceId, int targetId) {
    setMessage("source", message);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
    });
  }

  void setMessage(String type, String message) {
    final messageModel = MessageModel(
      type: type,
      message: message,
      time: DateTime.now().toString().substring(10, 16),
    );

    setState(() => messages.add(messageModel));
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: WillPopScope(
            onWillPop: () async {
              if (show) {
                setState(() => show = false);
                return false;
              }
              return true;
            },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) return const SizedBox(height: 70);
                        return messages[index].type == "source"
                            ? OwnMessageCard(
                          message: messages[index].message,
                          time: messages[index].time,
                          key: ValueKey("own_$index"),
                        )
                            : ReplyCard(
                          message: messages[index].message,
                          time: messages[index].time,
                          key: ValueKey("reply_$index"),
                        );
                      },
                    ),
                  ),
                  _buildInputField(),
                  if (show) _buildEmojiPicker(),
                ],
              )

          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      leadingWidth: 70,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_back, size: 24),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey,
              child: SvgPicture.asset(
                widget.chatModel.isGroup! ? "assets/groups.svg" : "assets/person.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
            ),
          ],
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.chatModel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Text("last seen today at 12:05", style: TextStyle(fontSize: 13)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        PopupMenuButton<String>(
          onSelected: (value) => debugPrint(value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: "View Contact", child: Text("View Contact")),
            const PopupMenuItem(value: "Media", child: Text("Media, links, and docs")),
            const PopupMenuItem(value: "Search", child: Text("Search")),
            const PopupMenuItem(value: "Wallpaper", child: Text("Wallpaper")),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: _controller,
                focusNode: focusNode,
                onChanged: (value) => setState(() => sendButton = value.trim().isNotEmpty),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a message",
                  prefixIcon: IconButton(
                    icon: Icon(show ? Icons.keyboard : Icons.emoji_emotions_outlined),
                    onPressed: () {
                      focusNode.unfocus();
                      setState(() => show = !show);
                    },
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => bottomSheet(),
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF128C7E),
            child: IconButton(
              icon: Icon(sendButton ? Icons.send : Icons.mic, color: Colors.white),
              onPressed: () {
                if (sendButton) {
                  sendMessage(_controller.text.trim(), widget.sourchat.id!, widget.chatModel.id!);
                  _controller.clear();
                  setState(() => sendButton = false);
                  scrollToBottom();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() => _controller.text += emoji.emoji);
        },
        config: const Config(
          columns: 7,
          emojiSizeMax: 32,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.SMILEYS,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 278,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundColor: color, child: Icon(icon, color: Colors.white)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
