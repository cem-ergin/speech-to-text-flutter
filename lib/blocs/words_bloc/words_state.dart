part of 'words_bloc.dart';

abstract class WordsState extends Equatable {
  const WordsState();

  @override
  List<Object> get props => [];
}

class WordsInitial extends WordsState {}

class WordsLoadSuccess extends WordsState {
  final List<String> words;
  final String currentWord;
  final bool isDone;
  final bool showNextButton;
  final String guessedWord;

  WordsLoadSuccess({
    required this.words,
    required this.currentWord,
    this.isDone = false,
    this.showNextButton = false,
    this.guessedWord = '',
  });

  @override
  List<Object> get props => [words, currentWord, isDone, showNextButton, guessedWord];
}

class WordsLoading extends WordsState {}

class WordsFailure extends WordsState {}
