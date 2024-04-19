//
//  EditTFQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct EditTFQuestionView: View {
	@Environment(\.managedObjectContext) var managedObjContext
	@Environment(\.dismiss) var dismiss
	
	var data: FetchedResults<TFQuestions>.Element?
	
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
		.onAppear {
			if let data = data {
				question = data.question!
				answer = data.answer
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
					DataController().editTFQuestion(TFQuestion(id: UUID(), question: question, answer: answer), to: data!, context: managedObjContext)
					dismiss()
				} label: {
					Text("Save")
				}
			}
		}
		.navigationTitle("Edit Question")
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.orange, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar)
		.navigationBarBackButtonHidden()
	}
}

//#Preview {
//	EditTFQuestionView()
//}
