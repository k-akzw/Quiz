//
//  AddQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

struct AddQuestionView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  var qType: QuestionType

  @State private var question = ""
  @State private var choice1 = ""
  @State private var choice2 = ""
  @State private var choice3 = ""
  @State private var choice4 = ""
  @State private var answer = 1

  var body: some View {
    Form {
      Section {
        TextField("Question", text: $question)

        // if mc question, display all 4 choices
        // otherwise, it's t/f question, so display only true or false
        if qType == QuestionType.mc {
          TextFieldView(title: "Choice 1", 
                        text: $choice1,
                        answerIndex: 1,
                        answer: $answer)
          TextFieldView(title: "Choice 2", 
                        text: $choice2,
                        answerIndex: 2,
                        answer: $answer)
          TextFieldView(title: "Choice 3", 
                        text: $choice3,
                        answerIndex: 3,
                        answer: $answer)
          TextFieldView(title: "Choice 4", 
                        text: $choice4,
                        answerIndex: 4,
                        answer: $answer)
        } else {
          // 2 choices must be true and false
          // so use TextView instead of TextFieldView
          TextView(text: choice1, answerIndex: 1, answer: $answer)
          TextView(text: choice2, answerIndex: 2, answer: $answer)
            .onAppear {
              choice1 = "True"
              choice2 = "False"
            }
        }
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
          DataController().addQuestion(Question(id: UUID(), question: question, choice1: choice1, choice2: choice2, choice3: choice3, choice4: choice4, answer: answer, qType: qType), context: managedObjContext)
          dismiss()
        } label: {
          Text("Save")
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

struct TextFieldView: View {
  var title: String
  @Binding var text: String
  var answerIndex: Int
  @Binding var answer: Int

  @State private var isOn = false

  var body: some View {
    HStack {
      TextField(title, text: $text)

      // toggle button to choose
      // which choice is right answer
      Toggle(isOn: $isOn) {}
      .toggleStyle(.switch)
      .onAppear {
        isOn = answerIndex == answer
      }
      .onChange(of: isOn, { _, newVal in
        if newVal {
          answer = answerIndex
        }
      })
      .onChange(of: answer) { _, _ in
        isOn = answerIndex == answer
      }
    }
  }
}

struct TextView: View {
  var text: String
  var answerIndex: Int
  @Binding var answer: Int

  @State private var isOn = false

  var body: some View {
    HStack {
      Text(text)

      // toggle button to choose
      // which choice is right answer
      Toggle(isOn: $isOn) {}
      .toggleStyle(.switch)
      .onAppear {
        isOn = answerIndex == answer
      }
      .onChange(of: isOn, { _, newVal in
        if newVal {
          answer = answerIndex
        }
      })
      .onChange(of: answer) { _, _ in
        isOn = answerIndex == answer
      }
    }
  }
}

//#Preview {
//  AddQuestionView(qType: QuestionType.mc)
//}
