import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/chat_controller.dart';
import 'package:owner/app/util/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(value.name, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  controller: value.scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      value.chatList.length,
                      (index) {
                        final item = value.chatList[index];
                        final isMe = item.senderId.toString() == value.uid.toString();
                        return _MessageBubble(message: item.message.toString(), time: item.updatedAt.toString(), isMe: isMe);
                      },
                    ),
                  ),
                ),
          bottomNavigationBar: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                        color: ThemeProvider.whiteColor,
                        border: Border.all(color: ThemeProvider.dividerColor),
                      ),
                      child: TextField(
                        controller: value.message,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                        decoration: InputDecoration(border: InputBorder.none, hintText: 'Message...'.tr, hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => value.sendMessage(),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: ThemeProvider.appColor,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.send_rounded, color: ThemeProvider.whiteColor, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.time, required this.isMe});

  final String message;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  decoration: BoxDecoration(
                    color: isMe ? ThemeProvider.appColor : ThemeProvider.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: isMe ? null : ThemeProvider.cardShadow,
                    border: isMe ? null : Border.all(color: ThemeProvider.dividerColor, width: 1),
                  ),
                  child: Text(message, style: TextStyle(color: isMe ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontSize: 14, height: 1.35)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(time, style: const TextStyle(fontSize: 10, color: ThemeProvider.subtleTextColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
