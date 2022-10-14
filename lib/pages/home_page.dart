import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_flutter/models/listen_type.dart';
import 'package:speech_to_text_flutter/pages/speech_to_text_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: const Text("Sürekli dinle"),
              subtitle:
                  const Text("Dinleme kapandığında otomatik olarak yeniden başlatılır. Dinleme işlemi durdurulamaz."),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _stopListening();

                _pushToListeningPage(
                  context: context,
                  listenType: ListenType.constantly,
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Karışık"),
              subtitle: const Text("Tahmin ettikçe dinleme işlemi yeniden başlar."),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _stopListening();

                _pushToListeningPage(
                  context: context,
                  listenType: ListenType.mixed,
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Sadece basarsam"),
              subtitle: const Text(
                  "Tahmin ettikten sonra dinleme işlemi sıfırlanır. Dinleme, butona basılmadıkça başlamaz. "),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _stopListening();

                _pushToListeningPage(
                  context: context,
                  listenType: ListenType.byOnlyTap,
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _pushToListeningPage({required BuildContext context, required ListenType listenType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeechToTextPage(
          listenType: listenType,
        ),
      ),
    );
  }

  void _stopListening() {
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
  }
}
