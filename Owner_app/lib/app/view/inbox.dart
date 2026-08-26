import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/inbox_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InboxController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            toolbarHeight: 50,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text('Messages'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView(itemCount: 5)
              : value.chatList.isEmpty
                  ? _EmptyState(message: 'No Conversations Found!'.tr)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        decoration: ThemeProvider.cardDecoration(),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: List.generate(
                            value.chatList.length,
                            (index) {
                              final chat = value.chatList[index];
                              final isLast = index == value.chatList.length - 1;
                              return chat.senderId.toString() == value.uid
                                  ? _ChatTile(
                                      name: '${chat.receiverName} ${chat.receiverLastName}',
                                      cover: chat.receiverCover.toString(),
                                      lastMessage: (chat.lastMessage ?? '').toString(),
                                      time: chat.updatedAt.toString(),
                                      isLast: isLast,
                                      onTap: () => value.onChat(chat.receiverId.toString(), '${chat.receiverName} ${chat.receiverLastName}'),
                                    )
                                  : _ChatTile(
                                      name: '${chat.senderFirstName} ${chat.senderLastName}',
                                      cover: chat.senderCover.toString(),
                                      lastMessage: (chat.lastMessage ?? '').toString(),
                                      time: chat.updatedAt.toString(),
                                      isLast: isLast,
                                      onTap: () => value.onChat(chat.senderId.toString(), '${chat.senderFirstName} ${chat.senderLastName}'),
                                    );
                            },
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.name, required this.cover, required this.lastMessage, required this.time, required this.onTap, required this.isLast});

  final String name;
  final String cover;
  final String lastMessage;
  final String time;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isLast ? ThemeProvider.transparent : ThemeProvider.dividerColor))),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: FadeInImage(
                image: NetworkImage('${Environments.apiBaseURL}storage/images/$cover'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png', height: 44, width: 44, fit: BoxFit.cover);
                },
                fit: BoxFit.cover,
                height: 44,
                width: 44,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.blackColor))),
                      const SizedBox(width: 8),
                      Text(time, style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                    ],
                  ),
                  if (lastMessage.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(lastMessage, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: ThemeProvider.subtleTextColor),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/no-data.png', width: 72, height: 72),
          const SizedBox(height: 18),
          Text(message, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
        ],
      ),
    );
  }
}
