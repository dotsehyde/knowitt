import 'package:knowitt/model/question.dart';

enum GameStatus {
  initial,
  done,
  waiting,
  timeup,
  error,
  initGame,
  gameReady,
  gameDone,
  ansCorrect,
  ansWrong,
}

class GameState {
  int round = 1;
  int? ansIndex;
  GameStatus gameStatus = GameStatus.initial;
  List<QuestionModel> questions = [];
  int questionNumber = 0;
  String errMsg = '';

  GameState(
      {this.round = 1,
      this.ansIndex,
      this.errMsg = '',
      this.gameStatus = GameStatus.initial,
      this.questions = const [],
      this.questionNumber = 0});

  GameState update(
      {int? round,
      int? ansIndex,
      String? errMsg,
      GameStatus? gameStatus,
      List<QuestionModel>? questions,
      int? questionNumber}) {
    return GameState(
        errMsg: errMsg ?? this.errMsg,
        round: round ?? this.round,
        ansIndex: ansIndex ?? this.ansIndex,
        gameStatus: gameStatus ?? this.gameStatus,
        questions: questions ?? this.questions,
        questionNumber: questionNumber ?? this.questionNumber);
  }
}
