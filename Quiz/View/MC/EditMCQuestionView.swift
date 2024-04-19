//
//  EditQuestionView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/19/24.
//

import SwiftUI

struct EditMCQuestionView: View {
	@Environment(\.managedObjectContext) var managedObjContext
	@Environment(\.dismiss) var dismiss
	
	var data: FetchedResults<MCQuestions>.Element?
	
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
			}
		}
		.onAppear {
			// initialize attributes to existing one
			if data != nil {
				question = data!.question!
				choice1 = data!.choice1!
				choice2 = data!.choice2!
				choice3 = data!.choice3!
				choice4 = data!.choice4!
				answer = Int(data!.answer)
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
					DataController().editMCQuestion(MCQuestion(id: UUID(), question: question, choice1: choice1, choice2: choice2, choice3: choice3, choice4: choice4, answer: answer), to: data!, context: managedObjContext)
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
//    EditQuestionView()
//}
