
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_house_design/presentation/widgets/api_service.dart';
import 'package:my_house_design/presentation/widgets/constants.dart';
import 'package:my_house_design/presentation/widgets/message.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _inChatMessages = [];
  final PageController _pageController = PageController();
  List<XFile>? _imagesFileList = [];
  int _currentIndex = 0;
  String _currentChatId = '';

  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  String _modelType = 'gemini-1.5-flash-latest';
  bool _isLoading = false;

  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  Future<void> setModel({required bool isTextOnly}) async {
    _model = isTextOnly
        ? _textModel ?? GenerativeModel(
            model: setCurrentModel(newModel: 'gemini-1.5-flash-latest'),
            apiKey: ApiService.apiKey,
          )
        : _visionModel ?? GenerativeModel(
            model: setCurrentModel(newModel: 'gemini-1.5-flash-latest'),
            apiKey: ApiService.apiKey,
          );
    notifyListeners();
  }

  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    await setModel(isTextOnly: isTextOnly);
    setLoading(value: true);

    String chatId = getChatId();
    List<Content> history = await getHistory(chatId: chatId);
    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    final userMessageId = const Uuid().v4();
    final userMessage = Message(
      messageId: userMessageId,
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    await sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
    );
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
  }) async {
    final languageSystemPrompt = Content.text(
        "إنت مساعد ذكي، متخصص في كل ما يخص فرش و تجهيز المنازل، المكاتب، الفيلات، والفنادق. بتفهم كويس في العفش، الديكور، الأجهزة الكهربائية، وأنواع المراتب، وتنسيق الألوان.أي حد يسألك عن حاجة لها علاقة بتجهيز المكان من الألف للياء، رد عليه بنصايح بسيطة وواضحة باللهجة المصرية، كأنك بتكلمه في محادثة ودية، رد عليه بطريقة  سهلة و بسيطة، كأنك بتكلمه وشه لوشك، طب لو هو دخل كلمك بأي لغة تانية انت هتقدر تحدد دي انهي لغة و ترد عليه بنفس اللغه اللي كلمك بيها . ماتجاوبش علي أي أسئلة مش متعلقة بالمجال ده ،اللي هو تخصصك و بس   ",
      
    );   
    final fullHistory = [languageSystemPrompt, ...history];

    final chatSession = _model!.startChat(
      history: isTextOnly ? fullHistory : null,
    );

    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    final modelMessageId = const Uuid().v4();
    final assistantMessage = userMessage.copyWith(
      messageId: modelMessageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(assistantMessage);
    notifyListeners();

    chatSession.sendMessageStream(content).asyncMap((event) => event).listen(
      (event) {
        _inChatMessages
            .firstWhere((m) =>
                m.messageId == assistantMessage.messageId &&
                m.role.name == Role.assistant.name)
            .message
            .write(event.text);
        notifyListeners();
      },
      onDone: () => setLoading(value: false),
      onError: (error, stackTrace) {
        log("Error while streaming: $error");
        setLoading(value: false);
      },
    );
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      try {
        final imageFutures = _imagesFileList?.map((imageFile) async {
          final bytes = await imageFile.readAsBytes();
          return bytes;
        }).toList();

        final imageBytes = await Future.wait(imageFutures!);
        final prompt = TextPart(message);
        final imageParts = imageBytes
            .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
            .toList();

        return Content.multi([prompt, ...imageParts]);
      } catch (e) {
        log("❌ Error while reading image: $e");
        rethrow;
      }
    }
  }

  List<String> getImagesUrls({required bool isTextOnly}) {
    if (!isTextOnly && imagesFileList != null) {
      return imagesFileList!.map((img) => img.path).toList();
    }
    return [];
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    for (var message in inChatMessages) {
      if (message.role == Role.user) {
        history.add(Content.text(message.message.toString()));
      } else {
        history.add(Content.model([TextPart(message.message.toString())]));
      }
    }
    return history;
  }

  String getChatId() {
    return currentChatId.isEmpty ? const Uuid().v4() : currentChatId;
  }

  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);
  }
}
