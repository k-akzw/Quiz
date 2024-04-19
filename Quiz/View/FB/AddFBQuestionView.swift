//
//  AddFBQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct AddFBQuestionView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  @State private var question = ""
  @State private var answer = ""

  var body: some View {
    Form {
      Section {
        TextField("Question", text: $question)
        TextField("Answer", text: $answer)
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

      // save the new question to database
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          // add new question to database and goes back to previous screen
          DataController().addFBQuestion(FBQuestion(id: UUID(), question: question, answer: answer), context: managedObjContext)
          dismiss()
        } label: {
          Label("Save", systemImage: "save")
        }
      }
    }
    .navigationTitle("Add Question")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

//#Preview {
//  AddFBQuestionView()
//}
