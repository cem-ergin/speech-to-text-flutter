import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  List<String> allWords = [];

  WordsBloc() : super(WordsInitial()) {
    on<WordsEvent>((event, emit) async {
      final _state = state;
      if (event is FetchWords) {
        try {
          emit(WordsLoading());

          final wordsListSnapshot = await FirebaseFirestore.instance.collection('words').doc('list').get();
          final words = List<String>.from(wordsListSnapshot.get('word'));
          allWords = words;
          words.shuffle();

          emit(WordsLoadSuccess(words: words, currentWord: words.first));
        } catch (e) {
          emit(WordsFailure());
        }
      }
      if (event is CheckWord) {
        if (_state is WordsLoadSuccess) {
          if (_state.words.isEmpty) {
            return emitDone(emit, _state);
          }
          if (event.word.isEmpty) {
            return emitEventWordEmpty(emit, _state);
          }

          for (var word in event.word.split(" ")) {
            if (word.toUpperCase().trim() == _state.currentWord.toUpperCase().trim() ||
                word.toLowerCase().trim() == _state.currentWord.toLowerCase().trim()) {
              _state.words.removeAt(0);
              if (_state.words.isEmpty) {
                return emitDone(emit, _state);
              }
              return emitNextWordLoadSuccess(emit, _state);
            }
          }

          return emitNextButtonAndWord(emit, _state, event);
        }
      }

      if (event is ShuffleWords) {
        final words = allWords;
        words.shuffle();
        emit(WordsLoadSuccess(words: words, currentWord: words.first));
      }
    });
  }

  void emitNextButtonAndWord(Emitter<WordsState> emit, WordsLoadSuccess _state, CheckWord event) {
    return emit(
      WordsLoadSuccess(
        words: _state.words,
        currentWord: _state.words.first,
        showNextButton: true,
        guessedWord: event.word,
      ),
    );
  }

  void emitNextWordLoadSuccess(Emitter<WordsState> emit, WordsLoadSuccess _state) {
    return emit(
      WordsLoadSuccess(words: _state.words, currentWord: _state.words.first),
    );
  }

  void emitEventWordEmpty(Emitter<WordsState> emit, WordsLoadSuccess _state) {
    return emit(
      WordsLoadSuccess(
        words: _state.words,
        currentWord: _state.words.first,
      ),
    );
  }

  void emitDone(Emitter<WordsState> emit, WordsLoadSuccess _state) {
    return emit(
      WordsLoadSuccess(
        words: const [],
        currentWord: '',
        isDone: true,
      ),
    );
  }
}
