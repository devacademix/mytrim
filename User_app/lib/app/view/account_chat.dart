import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/account_chat_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class AccountChatScreen extends StatefulWidget {
  const AccountChatScreen({super.key});

  @override
  State<AccountChatScreen> createState() => _AccountChatScreenState();
}

class _AccountChatScreenState extends State<AccountChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Inbox'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.parser.haveLoggedIn() == false
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/search.png', width: 60, height: 60),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => value.onLoginRoutes(),
                        child: Text('Opps, Please Login or Register first!'.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ),
                    ],
                  ),
                )
              : value.apiCalled == false
                  ? SkeletonListView(itemCount: 5)
                  : value.chatList.isEmpty
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 90, width: 90, child: Image.asset("assets/images/no-data.png", fit: BoxFit.cover)),
                              const SizedBox(height: 20),
                              Text('No conversations yet'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                              const SizedBox(height: 6),
                              Text('Your chats with salons will show up here'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 13, color: ThemeProvider.textSecondary)),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            children: List.generate(
                              value.chatList.length,
                              (index) {
                                return value.chatList[index].senderId.toString() == value.uid
                                    ? _chatTile(
                                        onTap: () => value.onChat(value.chatList[index].receiverId.toString(), '${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName}'),
                                        cover: value.chatList[index].receiverCover.toString(),
                                        name: '${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName}',
                                        time: value.chatList[index].updatedAt.toString(),
                                      )
                                    : _chatTile(
                                        onTap: () => value.onChat(value.chatList[index].senderId.toString(), '${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName}'),
                                        cover: value.chatList[index].senderCover.toString(),
                                        name: '${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName}',
                                        time: value.chatList[index].updatedAt.toString(),
                                      );
                              },
                            ),
                          ),
                        ),
        );
      },
    );
  }

  Widget _chatTile({required VoidCallback onTap, required String cover, required String name, required String time}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: ThemeProvider.cardDecoration(radius: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage(
                height: 44,
                width: 44,
                image: NetworkImage('${Environments.apiBaseURL}storage/images/$cover'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png', height: 44, width: 44, fit: BoxFit.cover);
                },
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.5, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                  const SizedBox(height: 3),
                  Text(time, style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: ThemeProvider.textSecondary.withOpacity(0.6), size: 20),
          ],
        ),
      ),
    );
  }
}
