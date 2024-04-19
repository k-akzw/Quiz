//
//  TFQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

struct TFQuestionView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss
  @FetchRequest(sortDescriptors: [SortDescriptor(\TFQuestions.id, order: .reverse)]) var data: FetchedResults<TFQuestions>

  @State private var questions = [TFQuestion]()
  @State private var qIndex = 0
  @State private var showAnswer = false
  @State private var showAddView = false
  @State private var showEditView = false

  var body: some View {
    VStack {
      TFQuestionTextView(questions: $questions,
												 qIndex: $qIndex,
												 showAnswer: $showAnswer)
    }
    .navigationDestination(isPresented: $showEditView, destination: {
      // if there is no question
      // it will produce error that data is nil
      if qIndex < questions.count {
        EditTFQuestionView(data: questions[qIndex].res)
      }
    })
    .navigationDestination(isPresented: $showAddView, destination: {
      AddTFQuestionView()
    })
    .onAppear {
      showAnswer = false
      questions = QuizModel.shared.getTFQuestions(data)
    }
    .toolbar {
      // goes back to previous screen
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("Back")
          }
        }
      }

      // edits current question
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showEditView.toggle()
        } label: {
          Text("Edit")
        }
      }

      // adds new question
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showAddView.toggle()
        } label: {
          Label("Add", systemImage: "plus.circle")
        }
      }
    }
    .padding()
    .navigationTitle("T/F Question \(qIndex + 1)")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

struct TFQuestionTextView: View {
	@Binding var questions: [TFQuestion]
	@Binding var qIndex: Int
	@Binding var showAnswer: Bool
	
	var body: some View {
		if qIndex < questions.count {
			let q = questions[qIndex]
			
			Text(q.question)
			
			Spacer()
			
			ChoiceView(choice: "True",
								 correct: q.answer,
								 qIndex: $qIndex,
								 showAnswer: $showAnswer)
			ChoiceView(choice: "False",
								 correct: !q.answer,
								 qIndex: $qIndex,
								 showAnswer: $showAnswer)

      ChangeQuestionButton(numOfQuestions: questions.count,
                           showAnswer: $showAnswer,
                           qIndex: $qIndex)
		} else {
			Text("No questions")
				.bold()
      Spacer()
		}
	}
}

//#Preview {
//  TFQuestionView()
//}
