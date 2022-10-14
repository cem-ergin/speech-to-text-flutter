part of 'words_bloc.dart';

abstract class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

class FetchWords extends WordsEvent {}

class CheckWord extends WordsEvent {
  final String word;
  CheckWord({required this.word});
}

class ShuffleWords extends WordsEvent {}
