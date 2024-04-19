//
//  AddTFQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct AddTFQuestionView: View {
	@Environment(\.managedObjectContext) var managedObjContext
	@Environment(\.dismiss) var dismiss
	
	@State private var question = ""
	@State private var answer = true
	
	var body: some View {
		Form {
			Section {
				TextField("Question", text: $question)
				
				TextView(text: "True", isAnswer: true, answer: $answer)
				TextView(text: "False", isAnswer: false, answer: $answer)
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
					DataController().addTFQuestion(TFQuestion(id: UUID(), question: question, answer: answer), context: managedObjContext)
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

struct TextView: View {
	var text: String
	var isAnswer: Bool
	@Binding var answer: Bool
	
	@State private var isOn = false
	
	var body: some View {
		HStack {
			Text(text)
			
			// toggle button to choose
			// which choice is right answer
			Toggle(isOn: $isOn) {}
				.toggleStyle(.switch)
				.onAppear {
					isOn = isAnswer == answer
				}
				.onChange(of: isOn, { _, newVal in
					if newVal {
						answer = isAnswer
					}
				})
				.onChange(of: answer) { _, _ in
					isOn = isAnswer == answer
				}
		}
	}
}

//#Preview {
//	AddTFQuestionView()
//}
