import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_flutter/blocs/words_bloc/words_bloc.dart';
import 'package:speech_to_text_flutter/models/listen_type.dart';
import 'package:speech_to_text_flutter/widgets/lottie_widget.dart';

class SpeechToTextPage extends StatefulWidget {
  final ListenType listenType;
  const SpeechToTextPage({Key? key, required this.listenType}) : super(key: key);

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  final _speechToText = SpeechToText();

  late Timer timer;

  @override
  void initState() {
    super.initState();
    _initSpeech();

    if (widget.listenType == ListenType.constantly) {
      timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (_speechToText.isAvailable) {
          if (_speechToText.isNotListening) {
            widget.listenType == ListenType.constantly ? _startListening() : _stopListening();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "tr_TR",
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _stopListening();
    context.read<WordsBloc>().add(
          CheckWord(
            word: result.recognizedWords,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final wordsBloc = context.read<WordsBloc>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => refreshWordsBloc(wordsBloc),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocConsumer<WordsBloc, WordsState>(
        listener: (context, state) {
          if (widget.listenType == ListenType.mixed) {
            if (state is WordsLoadSuccess) {
              if (_speechToText.isNotListening) {
                _startListening();
              }
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          if (state is WordsInitial) {
            refreshWordsBloc(wordsBloc);
          }
          if (state is WordsLoadSuccess) {
            if (state.isDone || state.words.isEmpty) {
              return emptyWordsView(wordsBloc);
            }
            return _loadSuccessView(state, size, wordsBloc);
          }
          if (state is WordsFailure) {
            return ElevatedButton(
              onPressed: () => refreshWordsBloc(wordsBloc),
              child: const Text("Hata. Yeniden dene"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Center emptyWordsView(WordsBloc wordsBloc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Kelimeler bitti',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              refreshWordsBloc(wordsBloc);
            },
            child: const Text("Verileri yenile"),
          ),
        ],
      ),
    );
  }

  Center _loadSuccessView(WordsLoadSuccess state, Size size, WordsBloc wordsBloc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Kelime: ${state.currentWord}',
                style: const TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          if (state.guessedWord.isNotEmpty) _guessedWordText(state),
          _listenButtonWidget(size),
          if (state.showNextButton) _nextButton(wordsBloc, state),
        ],
      ),
    );
  }

  Container _guessedWordText(WordsLoadSuccess state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Çeviri: ${state.guessedWord}',
        style: const TextStyle(
          fontSize: 30.0,
          color: Colors.red,
        ),
      ),
    );
  }

  ElevatedButton _nextButton(WordsBloc wordsBloc, WordsLoadSuccess state) {
    return ElevatedButton(
      onPressed: () {
        wordsBloc.add(
          CheckWord(
            word: state.currentWord,
          ),
        );
      },
      child: const Text("Bir sonraki kelimeye geç"),
    );
  }

  Center _listenButtonWidget(Size size) {
    return Center(
      child: ClipOval(
        child: Container(
          height: size.width * 0.3,
          width: size.width * 0.3,
          color: Colors.blue,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              if (_speechToText.isListening) const LottieWidget(),
              IconButton(
                onPressed: () {
                  if (widget.listenType != ListenType.constantly) {
                    _speechToText.isNotListening ? _startListening() : _stopListening();
                  }
                },
                icon: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshWordsBloc(WordsBloc wordsBloc) {
    wordsBloc.add(FetchWords());
  }
}
