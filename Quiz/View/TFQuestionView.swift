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
  @FetchRequest(sortDescriptors: [SortDescriptor(\MCQuestions.id, order: .reverse)]) var data: FetchedResults<MCQuestions>

  @State private var questions = [Question]()
  @State private var qIndex = 0
  @State private var showAnswer = false
  @State private var showAddView = false
  @State private var showEditView = false

  var body: some View {
    VStack {
      QuestionTextView(questions: $questions, 
                       qIndex: $qIndex,
                       showAnswer: $showAnswer,
                       qType: QuestionType.tf)

      Spacer()
        .frame(height: 20)

      ChangeQuestionButton(questions: $questions,
                           showAnswer: $showAnswer,
                           qIndex: $qIndex)
    }
    .navigationDestination(isPresented: $showEditView, destination: {
      // if there is no question
      // it will produce error that data is nil
      if qIndex < questions.count {
        EditQuestionView(data: questions[qIndex].res, qType: QuestionType.tf)
      }
    })
    .navigationDestination(isPresented: $showAddView, destination: {
      AddQuestionView(qType: QuestionType.tf)
    })
    .onAppear {
      showAnswer = false
      questions = QuizModel.shared.getQuestions(data, qType: QuestionType.tf)
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

//#Preview {
//  TFQuestionView()
//}
