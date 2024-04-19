//
//  MCQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

struct MCQuestionView: View {
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
                       qType: QuestionType.mc)

      Spacer()
        .frame(height: 20)

      ChangeQuestionButton(questions: $questions,
                           showAnswer: $showAnswer,
                           qIndex: $qIndex)
    }
    .navigationDestination(isPresented: $showEditView, destination: {
      if qIndex < questions.count {
        EditQuestionView(data: questions[qIndex].res, qType: QuestionType.mc)
      }
    })
    .navigationDestination(isPresented: $showAddView, destination: {
      AddQuestionView(qType: QuestionType.mc)
    })
    .onAppear {
      showAnswer = false
      questions = QuizModel.shared.getQuestions(data, qType: QuestionType.mc)
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
          showEditView = true
        } label: {
          Text("Edit")
        }
      }

      // adds new question
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showAddView = true
        } label: {
          Label("Add", systemImage: "plus.circle")
        }
      }
    }
    .padding()
    .navigationTitle("MC Question \(qIndex + 1)")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

struct QuestionTextView: View {
  @Binding var questions: [Question]
  @Binding var qIndex: Int
  @Binding var showAnswer: Bool
  var qType: QuestionType

  var body: some View {
    if qIndex < questions.count {
      let q = questions[qIndex]

      Text(q.question)

      Spacer()

      ChoiceView(choice: q.choice1, 
                 correct: q.answer == 1,
                 qIndex: $qIndex,
                 showAnswer: $showAnswer)
      ChoiceView(choice: q.choice2, 
                 correct: q.answer == 2,
                 qIndex: $qIndex,
                 showAnswer: $showAnswer)
      // if t/f question, there is only 2 choices
      // so display choice3 and 4 only for mc questions
      if qType == QuestionType.mc {
        ChoiceView(choice: q.choice3, 
                   correct: q.answer == 3,
                   qIndex: $qIndex,
                   showAnswer: $showAnswer)
        ChoiceView(choice: q.choice4, 
                   correct: q.answer == 4,
                   qIndex: $qIndex,
                   showAnswer: $showAnswer)
      }
    } else {
      Text("No questions")
        .bold()
    }
  }
}

struct ChoiceView: View {
  var choice: String
  var correct: Bool
  @Binding var qIndex: Int
  @Binding var showAnswer: Bool

  @State var wrong = false

  var body: some View {
    HStack {
      Text(choice)
        .padding()
        .foregroundColor(showAnswer ? (correct ? .green : (wrong ? .red : .black)) : .black)
        .fontWeight((correct && showAnswer) ? .bold : .regular)
        .onChange(of: qIndex) { _, _ in
          // when question changes
          // reset @wrong
          wrong = false
        }
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .overlay {
      RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1)
    }
    .onTapGesture {
      // only allowed to tap one option
      if !showAnswer {
        showAnswer = true
        if !correct { wrong = true }
      }
    }
  }
}

struct ChangeQuestionButton: View {
  @Binding var questions: [Question]
  @Binding var showAnswer: Bool
  @Binding var qIndex: Int

  var body: some View {
    HStack {
      // goes back to previous question
      Button {
        // hide answer when go back to prev question
        showAnswer = false
        qIndex -= 1
      } label: {
        HStack {
          Image(systemName: "chevron.left")
          Text("Back")
        }
      }
      .disabled(qIndex == 0)

      Spacer()

      // goes to next question
      Button {
        // hide answer for next question
        showAnswer = false
        qIndex += 1
      } label: {
        HStack {
          Image(systemName: "chevron.right")
          Text("Next")
        }
      }
      .disabled(qIndex == questions.count - 1)
    }
  }
}

//#Preview {
//  MCQuestionView()
//}
