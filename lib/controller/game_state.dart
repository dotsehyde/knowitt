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
  int gameScore = 0;
  int correctAns = 0;
  int wrongAns = 0;
  GameStatus gameStatus = GameStatus.initial;
  List<QuestionModel> questions = [];
  QuestionModel get currentQuestion => questions[questionNumber];
  int questionNumber = 0;
  String errMsg = '';

  GameState(
      {this.round = 1,
      this.ansIndex,
      this.errMsg = '',
      this.gameScore = 0,
      this.correctAns = 0,
      this.wrongAns = 0,
      this.gameStatus = GameStatus.initial,
      this.questions = const [],
      this.questionNumber = 0});

  GameState update(
      {int? round,
      int? ansIndex,
      String? errMsg,
      int? gameScore,
      int? correctAns,
      int? wrongAns,
      GameStatus? gameStatus,
      List<QuestionModel>? questions,
      int? questionNumber}) {
    return GameState(
        errMsg: errMsg ?? this.errMsg,
        round: round ?? this.round,
        gameScore: gameScore ?? this.gameScore,
        correctAns: correctAns ?? this.correctAns,
        wrongAns: wrongAns ?? this.wrongAns,
        ansIndex: ansIndex ?? this.ansIndex,
        gameStatus: gameStatus ?? this.gameStatus,
        questions: questions ?? this.questions,
        questionNumber: questionNumber ?? this.questionNumber);
  }
}
