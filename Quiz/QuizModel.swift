//
//  QuizModel.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

enum QuestionType: String {
  case mc = "mc"  // multiple choice
  case tf = "tf"  // true/false
  case fb = "fb"  // fill in blank
}

class QuizModel {
  // singleton instance of this class
  static let shared = QuizModel()

  // MARK: - Public Functions

  // returns list of questions from database
  func getQuestions(_ questions: FetchedResults<MCQuestions>, qType: QuestionType) -> [Question] {
    var li: [Question] = []
    // iterate through all questions in the database
    // and add all questions which has the same question type to @li
    for q in questions {
      if (q.qType == qType.rawValue) {
        li.append(Question(id: q.id!, question: q.question!, choice1: q.choice1 ?? "", choice2: q.choice2 ?? "", choice3: q.choice3 ?? "", choice4: q.choice4 ?? "", answer: Int(q.answer), qType: QuestionType(rawValue: q.qType!) ?? QuestionType.mc, res: q))
      }
    }
    // shuffle the order of questions
    return li.shuffled()
  }
}
