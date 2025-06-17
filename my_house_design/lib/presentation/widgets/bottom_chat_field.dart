import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_house_design/presentation/widgets/chat_provider.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/preview_images_widget.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key, required this.chatProvider});

  final ChatProvider chatProvider;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> { 
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFoucs = FocusNode(); 
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    textController.dispose();
    textFieldFoucs.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage({
    required String message, 
    required ChatProvider chatProvider, 
    required bool isTextOnly,
  }) async {
    try {
      await chatProvider.sentMessage(
        message: message, 
        isTextOnly: isTextOnly,
      );
    } catch(e) {
      log('error : $e');
    } finally {
      textController.clear();
      widget.chatProvider.setImagesFileList(listValue: []);
      textFieldFoucs.unfocus();
    }
  }

  void pickImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      widget.chatProvider.setImagesFileList(listValue: pickedImages);
    } catch (e) {
      log('error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImages = widget.chatProvider.imagesFileList != null && 
        widget.chatProvider.imagesFileList!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).textTheme.titleLarge!.color!,
        ),
      ),
      child: Column(
        children: [
          if(hasImages) const PreviewImagesWidget(),
          Row(
            children: [
              IconButton(
  onPressed: () {
    if (hasImages) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: boxColor,
            title: Text('Delete Images'),
            content: Text('Are you sure you want to delete the images?'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context); 
                },   
                child: Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor),  
                ),
               
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  widget.chatProvider.setImagesFileList(listValue: []);
                  Navigator.pop(context); 
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: primaryColor),  
                ),
              ),
            ],
          );
        },
      );
    } else {
      pickImage();
    }
  },
  icon: Icon(hasImages ? Icons.delete_forever : Icons.image),
),

              const SizedBox(width: 5,),
              Expanded(
                child: TextField(
                  focusNode: textFieldFoucs,
                  controller: textController,
                  textInputAction: TextInputAction.send,
                  cursorColor: primaryColor,
                  onSubmitted: (String value) {
                    if(value.isNotEmpty) {
                    sendChatMessage(
                      message: textController.text, 
                      chatProvider: widget.chatProvider, 
                      isTextOnly: hasImages ? false : true,
                      );
                  }
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: 'Enter a prompt...',
                      filled: true, 
                      fillColor: boxColor, 
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
          
                  if(textController.text.isNotEmpty) {
                    sendChatMessage(
                      message: textController.text, 
                      chatProvider: widget.chatProvider, 
                      isTextOnly: hasImages ? false : true,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF003664), 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(5.0),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_upward, color: Colors.white,),
                  ), 
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }
}