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
	
	@State private var questions = [MCQuestion]()
	@State private var qIndex = 0
	@State private var showAnswer = false
	@State private var showAddView = false
	@State private var showEditView = false
	
	var body: some View {
		VStack {
			MCQuestionTextView(questions: $questions,
												 qIndex: $qIndex,
												 showAnswer: $showAnswer)
		}
		.navigationDestination(isPresented: $showEditView, destination: {
			if qIndex < questions.count {
				EditMCQuestionView(data: questions[qIndex].res)
			}
		})
		.navigationDestination(isPresented: $showAddView, destination: {
			AddMCQuestionView()
		})
		.onAppear {
			showAnswer = false
			questions = QuizModel.shared.getMCQuestions(data)
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

struct MCQuestionTextView: View {
	@Binding var questions: [MCQuestion]
	@Binding var qIndex: Int
	@Binding var showAnswer: Bool
	
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
			ChoiceView(choice: q.choice3,
								 correct: q.answer == 3,
								 qIndex: $qIndex,
								 showAnswer: $showAnswer)
			ChoiceView(choice: q.choice4,
								 correct: q.answer == 4,
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
//	@Binding var questions: [Question]
	var numOfQuestions: Int
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
			.disabled(qIndex == numOfQuestions - 1)
		}
	}
}

//#Preview {
//  MCQuestionView()
//}
