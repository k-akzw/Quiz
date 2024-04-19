//
//  FillBlankQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct FBQuestionView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss
  @FetchRequest(sortDescriptors: [SortDescriptor(\FBQuestions.id, order: .reverse)]) var data: FetchedResults<FBQuestions>

  @State private var questions = [FBQuestion]()
  @State private var qIndex = 0
  @State private var showAnswer = false
  @State private var showAddView = false
  @State private var showEditView = false
  @State private var answer = ""

  var body: some View {
    VStack {
      if qIndex < questions.count {
        Text(questions[qIndex].question)

        Spacer()

        Text("Answer: \(questions[qIndex].answer)")
          .opacity(showAnswer ? 1 : 0)

        HStack {
          TextField("Answer", text: $answer)
            .foregroundStyle(showAnswer ? (answer == questions[qIndex].answer ? Color.green : Color.red) : Color.black)
            .onSubmit {
              showAnswer = true
            }

          Button {
            showAnswer = true
          } label: {
            Image(systemName: "paperplane.fill")
          }
          .disabled(answer.isEmpty)
        }
        .onChange(of: qIndex, { _, _ in
          // when question changes
          // reset @answer
          answer = ""
        })
        .padding(8)
        .padding(.horizontal, 4)
        .overlay {
          // rounded rectable around text
          RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1)
        }
        ChangeQuestionButton(numOfQuestions: questions.count,
                             showAnswer: $showAnswer,
                             qIndex: $qIndex)
      } else {
        Text("No Questions")
          .bold()
        Spacer()
      }
    }
    .navigationDestination(isPresented: $showEditView, destination: {
      if qIndex < questions.count {
        EditFBQuestionView(data: questions[qIndex].res)
      }
    })
    .navigationDestination(isPresented: $showAddView, destination: {
      AddFBQuestionView()
    })
    .onAppear {
      showAnswer = false
      questions = QuizModel.shared.getFBQuestions(data)
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
    .navigationTitle("Fill in Blank Question \(qIndex + 1)")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

//#Preview {
//    FillBlankQuestionView()
//}
