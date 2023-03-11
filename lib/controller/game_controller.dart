import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
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
  // late Timer quizTimer;
  late PageController pageController;
  late AnimationController animationController;
  late Animation animation;

  void trackAnimation() {
    animationController.addListener(() {
      if (animation.isCompleted) {
        state = state.update(gameStatus: GameStatus.timeup);
      }
    });
  }

  void quizInit() {
    pageController = pageController = PageController(initialPage: 0);
  }

  void changeAnsIndex(int index) {
    state = state.update(ansIndex: index, gameStatus: GameStatus.initial);
  }

  void clearGame() {
    state = state.update(
        ansIndex: -1,
        gameStatus: GameStatus.initial,
        questionNumber: 0,
        round: 1,
        questions: [],
        errMsg: "");
  }

  void nextQuestion(int index) {
    // Next Question
    animationController.forward(from: 0.0);
    state = state.update(
        ansIndex: -1, gameStatus: GameStatus.initial, questionNumber: index);
  }

  void showResults() {
    state = state.update(
      gameStatus: GameStatus.gameDone,
    );
  }

  void nextRound() {
    //get new questions from db
    state =
        state.update(round: state.round + 1, gameStatus: GameStatus.initial);
  }

  void quitGame() {
    //update user scores silently (-5)
    state = state.update(gameStatus: GameStatus.gameDone);
  }

  void checkAnswer(String ans) {
    // quizTimer.cancel();
    animationController.stop();
    if (state.currentQuestion.answer == ans) {
      //Correct Answer
      //update user scores silently
      state = state.update(gameStatus: GameStatus.ansCorrect);
    } else {
      //Wrong Answer
      //Correct Answer
      //update user scores silently
      state = state.update(gameStatus: GameStatus.ansWrong);
    }
  }

  Future<void> initGame() async {
    try {
      final q = await getQuestions();
      state = state.update(
          questions: [...state.questions, ...q],
          questionNumber: 0,
          round: 1,
          ansIndex: -1,
          gameStatus: GameStatus.gameReady);
    } catch (e) {
      state = state.update(gameStatus: GameStatus.error, errMsg: e.toString());
    }
  }

  // void startTimer(Duration duration) {
  //   quizTimer = Timer(duration, () {
  //     state = state.update(gameStatus: GameStatus.timeup);
  //   });
  // }

  // void stopTimer() {
  //   quizTimer.cancel();
  // }

  // void restartTimer(Duration duration) {
  //   quizTimer.cancel();
  //   state = state.update(gameStatus: GameStatus.initial);
  //   startTimer(duration);
  // }

//Get Questions from db
  Future<List<QuestionModel>> getQuestions() async {
    try {
      state = state.update(gameStatus: GameStatus.initGame);
      List<QuestionModel> questions = [
        QuestionModel(
            id: "0",
            question: "Hello Test 0",
            answer: "wow",
            category: "Science",
            duration: 30,
            points: 5,
            wrongPoints: 5,
            options: ["wow", "hello", "eii", "saa"],
            createdAt: DateTime.now()),
        QuestionModel(
            id: "1",
            question: "Hello Test 1",
            answer: "lol",
            category: "Science",
            duration: 20,
            points: 5,
            wrongPoints: 5,
            options: ["cool", "lol", "eii", "saa"],
            createdAt: DateTime.now()),
        QuestionModel(
            id: "2",
            question: "Hello Test 2",
            answer: "wow",
            category: "Science",
            duration: 10,
            points: 5,
            wrongPoints: 5,
            options: ["wow", "hello", "eii", "saa"],
            createdAt: DateTime.now()),
        QuestionModel(
            id: "3",
            question: "Hello Test 3",
            answer: "wow",
            category: "Science",
            duration: 50,
            points: 5,
            wrongPoints: 5,
            options: ["wow", "hello", "eii", "saa"],
            createdAt: DateTime.now()),
      ];
      return Future.delayed(3.seconds, () {
        for (var e in questions) {
          e.options.shuffle();
        }
        questions.shuffle();
        return questions;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // quizTimer.cancel();
    animationController.dispose();
    super.dispose();
  }
}
