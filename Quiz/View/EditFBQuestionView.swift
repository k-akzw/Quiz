//
//  EditFBQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct EditFBQuestionView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  var data: FetchedResults<MCQuestions>.Element?

  @State private var question = ""
  @State private var answer = ""

  var body: some View {
    Form {
      Section {
        TextField("Question", text: $question)
        TextField("Answer", text: $answer)
      }
    }
    .onAppear {
      // initialize attributes to existing one
      if data != nil {
        question = data!.question!
        answer = data!.choice1!
      }
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

      // save the edited question to database
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          DataController().editPassword(Question(id: UUID(), question: question, choice1: answer, choice2: "", choice3: "", choice4: "", answer: 1, qType: QuestionType.fb), to: data!, context: managedObjContext)
          dismiss()
        } label: {
          Text("Save")
        }
      }
    }
    .padding()
    .navigationTitle("Add Question")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

//#Preview {
//  EditFBQuestionView()
//}
