//
//  QuizModel.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

class QuizModel {
  // singleton instance of this class
  static let shared = QuizModel()

  // MARK: - Public Functions
	
	func getMCQuestions(_ questions: FetchedResults<MCQuestions>) -> [MCQuestion] {
		var li = [MCQuestion]()
		for q in questions {
			li.append(MCQuestion(id: q.id!, question: q.question!, choice1: q.choice1!, choice2: q.choice2!, choice3: q.choice3!, choice4: q.choice4!, answer: Int(q.answer), res: q))
		}
		return li.shuffled()
	}
	
	func getTFQuestions(_ questions: FetchedResults<TFQuestions>) -> [TFQuestion] {
		var li = [TFQuestion]()
		for q in questions {
			li.append(TFQuestion(id: q.id!, question: q.question!, answer: q.answer, res: q))
		}
		return li.shuffled()
	}
	
	func getFBQuestions(_ questions: FetchedResults<FBQuestions>) -> [FBQuestion] {
		var li = [FBQuestion]()
		for q in questions {
			li.append(FBQuestion(id: q.id!, question: q.question!, answer: q.answer!, res: q))
		}
		return li.shuffled()
	}
}
