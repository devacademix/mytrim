import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/review_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Review'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                      child: Row(
                        children: [Text('All Reviews'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'bold', fontSize: 14))],
                      ),
                    ),
                    Expanded(
                      child: value.ownerReviewsList.isEmpty
                          ? _EmptyState(message: 'No Reviews Found!'.tr)
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                              itemCount: value.ownerReviewsList.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = value.ownerReviewsList[index];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: ThemeProvider.cardDecoration(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.user!.cover.toString()}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 40, width: 40);
                                              },
                                              fit: BoxFit.cover,
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${item.user!.firstName} ${item.user!.lastName}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 13, color: ThemeProvider.blackColor),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star_rounded, color: item.rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor, size: 15),
                                                    Icon(Icons.star_rounded, color: item.rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor, size: 15),
                                                    Icon(Icons.star_rounded, color: item.rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor, size: 15),
                                                    Icon(Icons.star_rounded, color: item.rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor, size: 15),
                                                    Icon(Icons.star_rounded, color: item.rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor, size: 15),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(item.createdAt.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 11)),
                                        ],
                                      ),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
                                      Text(item.notes.toString(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 12.5, color: ThemeProvider.mutedTextColor, height: 1.4)),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
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
