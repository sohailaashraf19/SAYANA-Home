import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_house_design/presentation/widgets/color.dart';


class AssistanceMessageWidget extends StatelessWidget {
  const AssistanceMessageWidget({
    super.key,
    required this.message,
    });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.9,
        ),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 8),
        child: message.isEmpty ? const SizedBox(
          width: 50,
          child: SpinKitThreeBounce(
            color: Colors.blueGrey,
            size: 20.0,
          ),
        ) : MarkdownBody(
          selectable: true,
          data: message,
        )
      ),
    );
  }
}