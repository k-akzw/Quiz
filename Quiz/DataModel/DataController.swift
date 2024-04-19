//
//  DataController.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "Questions")

  init() {
    container.loadPersistentStores { desc, error in
      if let error = error {
        print("Failed to load the data \(error.localizedDescription)")
      }
    }
  }

  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data saved")
    } catch {
      print("could not save the data...")
    }
  }

  func addQuestion(_  q: Question, context: NSManagedObjectContext) {
    let question = MCQuestions(context: context)
    question.id = q.id
    question.question = q.question
    question.choice1 = q.choice1
    question.choice2 = q.choice2
    question.choice3 = q.choice3
    question.choice4 = q.choice4
    question.answer = Int16(q.answer)
    question.qType = q.qType.rawValue

    save(context: context)
  }

  func editPassword(_ q: Question, to question: MCQuestions, context: NSManagedObjectContext) {
    question.id = q.id
    question.question = q.question
    question.choice1 = q.choice1
    question.choice2 = q.choice2
    question.choice3 = q.choice3
    question.choice4 = q.choice4
    question.answer = Int16(q.answer)
    question.qType = q.qType.rawValue

    save(context: context)
  }
}

struct Question: Identifiable {
  let id: UUID
  var question: String
  var choice1: String
  var choice2: String
  var choice3: String
  var choice4: String
  var answer: Int
  var qType: QuestionType
  var res: FetchedResults<MCQuestions>.Element?
}
