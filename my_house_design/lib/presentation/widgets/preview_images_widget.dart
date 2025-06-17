import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/widgets/chat_provider.dart';
import 'package:my_house_design/presentation/widgets/message.dart';
import 'package:provider/provider.dart';

class PreviewImagesWidget extends StatelessWidget {
  const PreviewImagesWidget({super.key, this.message});
  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageToShow = message != null
            ? message!.imagesUrls
            : chatProvider.imagesFileList?.map((file) => file.path).toList() ?? [];

        final padding = message != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 8.0);

        if (messageToShow.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: padding,
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: messageToShow.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(messageToShow[index]),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}