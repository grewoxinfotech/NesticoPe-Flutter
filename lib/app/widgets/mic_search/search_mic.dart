import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicController extends GetxController {
  late stt.SpeechToText speech;
  var searchText = TextEditingController().obs;

  var isListening = false.obs;
  var lastWords = ''.obs;

  final StreamController<bool> _listeningStreamController =
      StreamController<bool>.broadcast();
  final StreamController<String> _wordsStreamController =
      StreamController<String>.broadcast();

  Stream<bool> get listeningStream => _listeningStreamController.stream;
  Stream<String> get wordsStream => _wordsStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();

    // Sync obs → stream automatically
    ever(isListening, (val) => _listeningStreamController.add(val));
    ever(lastWords, (val) => _wordsStreamController.add(val));
  }

  Future<void> listen() async {
    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (status) {
          isListening.value = status == 'listening';
          if (status == 'done') stopListening();
        },
        onError: (error) => null,
      );

      if (available) {
        isListening.value = true;

        speech.listen(
          localeId: "en_IN",
          // pauseFor: const Duration(seconds: 10),
          listenMode: stt.ListenMode.confirmation,
          onResult: (val) {
            lastWords.value = val.recognizedWords;
            searchText.value.text = val.recognizedWords;
            searchText.value.selection = TextSelection.fromPosition(
              TextPosition(offset: searchText.value.text.length),
            );

            if (val.finalResult) {
              stopListening();
            }
          },
        );
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    isListening.value = false;
    lastWords.value = '';
    speech.stop();
  }

  @override
  void onClose() {
    _listeningStreamController.close();
    _wordsStreamController.close();
    super.onClose();
  }
}
