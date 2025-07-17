import 'package:flutter/cupertino.dart';

class ChatModel {
  final String name;
  final String status;
  bool? select;
  bool? isGroup;
  String? time;
  String? currentMessage;
  int? id;
  IconData? icon;

  ChatModel({
    required this.name,
    required this.status,
    this.select = false,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.id,
    this.icon,
  });
}
