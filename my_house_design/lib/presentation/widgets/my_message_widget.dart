import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/message.dart';
import 'package:my_house_design/presentation/widgets/preview_images_widget.dart';


class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    super.key,
    required this.message,
    });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.7,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            if(message.imagesUrls.isNotEmpty)
            PreviewImagesWidget(
              message: message,
            ),
            MarkdownBody(
              selectable: true,
              data: message.message.toString(),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Colors.white), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

