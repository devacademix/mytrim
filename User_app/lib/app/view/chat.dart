import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/chat_controller.dart';
import 'package:user/app/util/theme.dart';

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
              : value.chatList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), shape: BoxShape.circle),
                            child: const Icon(Icons.chat_bubble_outline, size: 34, color: ThemeProvider.appColor),
                          ),
                          const SizedBox(height: 16),
                          Text('No messages yet'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textSecondary)),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      controller: value.scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          value.chatList.length,
                          (index) {
                            final bool isMine = value.chatList[index].senderId.toString() == value.uid.toString();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                        decoration: BoxDecoration(
                                          color: isMine ? ThemeProvider.appColor : ThemeProvider.whiteColor,
                                          border: isMine ? null : Border.all(color: ThemeProvider.borderColor, width: 1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(18),
                                            topRight: const Radius.circular(18),
                                            bottomLeft: Radius.circular(isMine ? 18 : 4),
                                            bottomRight: Radius.circular(isMine ? 4 : 18),
                                          ),
                                          boxShadow: isMine ? null : ThemeProvider.cardShadow,
                                        ),
                                        child: Text(
                                          value.chatList[index].message.toString(),
                                          style: TextStyle(color: isMine ? ThemeProvider.whiteColor : ThemeProvider.textPrimary, fontSize: 14, height: 1.35),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
          bottomNavigationBar: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                        color: ThemeProvider.whiteColor,
                        border: Border.all(color: ThemeProvider.borderColor, width: 1),
                      ),
                      child: TextField(
                        controller: value.message,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                        decoration: InputDecoration(border: InputBorder.none, hintText: 'Message...'.tr, hintStyle: const TextStyle(color: ThemeProvider.textSecondary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => value.sendMessage(),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(color: ThemeProvider.appColor, shape: BoxShape.circle),
                      child: const Icon(Icons.near_me, color: ThemeProvider.whiteColor, size: 20),
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
