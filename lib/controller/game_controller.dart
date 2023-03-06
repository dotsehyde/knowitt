import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_state.dart';
import 'package:knowitt/model/question.dart';
import 'package:nb_utils/nb_utils.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameState> {
  GameController() : super(GameState());
  late Timer quizTimer;
  bool timeUp = false;

  void changeAnsIndex(int index) {
    state = state.update(ansIndex: index);
  }

  void updateQuestionNumber(int index) {
    state = state.update(questionNumber: index);
  }

  void nextQuestion() {
    if ((state.questionNumber + 1) == state.questions.length) {
      // Get package provide simple way to navigate another page
      state = state.update(gameStatus: GameStatus.gameDone);
      return;
    }
    updateQuestionNumber(state.questionNumber + 1);
  }

  void nextRound() {
    //get new questions from db
    state = state.update(round: state.round + 1);
  }

  void checkAnswer(String ans) {
    quizTimer.cancel();
    QuestionModel currQ = state.questions[state.questionNumber];
    if (currQ.answer == ans) {
      //Correct Answer
      //update user scores silently
      state = state.update(gameStatus: GameStatus.ansCorrect);
      //check if more questions are there then next question
    } else {
      //Wrong Answer
      //Correct Answer
      //update user scores silently
      state = state.update(gameStatus: GameStatus.ansWrong);
      //check if more questions are there then next question
    }
  }

  Future<void> initGame() async {
    try {
      final q = await getQuestions();
      state = state.update(questions: [...state.questions, ...q]);
      state = state.update(gameStatus: GameStatus.gameReady);
    } catch (e) {
      state = state.update(gameStatus: GameStatus.error, errMsg: e.toString());
    }
  }

  void startTimer(Duration duration) {
    state = state.update(gameStatus: GameStatus.done);
    quizTimer = Timer(duration, () {
      timeUp = true;
      state = state.update(gameStatus: GameStatus.timeup);
    });
  }

  void restartTimer(Duration duration) {
    quizTimer.cancel();
    timeUp = false;
    state = state.update(gameStatus: GameStatus.waiting);
    startTimer(duration);
  }

//Get Questions from db
  Future<List<QuestionModel>> getQuestions() async {
    try {
      state = state.update(gameStatus: GameStatus.initGame);
      List<QuestionModel> questions = [
        QuestionModel(
            question: "Hello Test",
            answer: "wow",
            category: "Science",
            duration: 30,
            points: 5,
            wrongPoints: 5,
            options: ["wow", "hello", "eii", "saa"],
            createdAt: DateTime.now())
      ];
      return Future.delayed(20.seconds, () {
        return questions;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    quizTimer.cancel();
    super.dispose();
  }
}
