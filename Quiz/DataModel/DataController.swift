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
	
	func addMCQuestion(_ q: MCQuestion, context: NSManagedObjectContext) {
		let question = MCQuestions(context: context)
		question.id = q.id
		question.question = q.question
		question.choice1 = q.choice1
		question.choice2 = q.choice2
		question.choice3 = q.choice3
		question.choice4 = q.choice4
		question.answer = Int16(q.answer)
		
		save(context: context)
	}
	
	func editMCQuestion(_ q: MCQuestion, to question: MCQuestions, context: NSManagedObjectContext) {
		question.id = q.id
		question.question = q.question
		question.choice1 = q.choice1
		question.choice2 = q.choice2
		question.choice3 = q.choice3
		question.choice4 = q.choice4
		question.answer = Int16(q.answer)
		
		save(context: context)
	}
	
	func addTFQuestion(_ q: TFQuestion, context: NSManagedObjectContext) {
		let question = TFQuestions(context: context)
		question.id = q.id
		question.question = q.question
		question.answer = q.answer
		
		save(context: context)
	}
	
	func editTFQuestion(_ q: TFQuestion, to question: TFQuestions, context: NSManagedObjectContext) {
		question.id = q.id
		question.question = q.question
		question.answer = q.answer
		
		save(context: context)
	}
	
	func addFBQuestion(_ q: FBQuestion, context: NSManagedObjectContext) {
		let question = FBQuestions(context: context)
		question.id = q.id
		question.question = q.question
		question.answer = q.answer
		
		save(context: context)
	}
	
	func editFBQuestion(_ q: FBQuestion, to question: FBQuestions, context: NSManagedObjectContext) {
		question.id = q.id
		question.question = q.question
		question.answer = q.answer
		
		save(context: context)
	}
}

struct MCQuestion: Identifiable {
  let id: UUID
  var question: String
  var choice1: String
  var choice2: String
  var choice3: String
  var choice4: String
  var answer: Int
  var res: FetchedResults<MCQuestions>.Element?
}

struct TFQuestion: Identifiable {
	let id: UUID
	var question: String
	var answer: Bool
	var res: FetchedResults<TFQuestions>.Element?
}

struct FBQuestion: Identifiable {
	let id: UUID
	var question: String
	var answer: String
	var res: FetchedResults<FBQuestions>.Element?
}
