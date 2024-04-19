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

  var data: FetchedResults<FBQuestions>.Element?

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
        answer = data!.answer!
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
          DataController().editFBQuestion(FBQuestion(id: UUID(), question: question, answer: answer), to: data!, context: managedObjContext)
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
