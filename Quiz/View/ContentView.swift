//
//  ContentView.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) var managedObjContext

  @State private var showMCView = false
  @State private var showTFView = false
  @State private var showFBView = false

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLinkButton(title: "Multiple Choice Questions", 
                             showView: $showMCView)
        NavigationLinkButton(title: "True/False Questions", 
                             showView: $showTFView)
        NavigationLinkButton(title: "Fill in Blank Questions",
                             showView: $showFBView)
      }
      .navigationDestination(isPresented: $showMCView, destination: {
        MCQuestionView()
      })
      .navigationDestination(isPresented: $showTFView, destination: {
        TFQuestionView()
      })
      .navigationDestination(isPresented: $showFBView, destination: {
        FBQuestionView()
      })
      .padding()
      .navigationTitle("Quiz")
      .navigationBarTitleDisplayMode(.inline)
      .toolbarBackground(.orange, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}

struct NavigationLinkButton: View {
  var title: String
  @Binding var showView: Bool

  var body: some View {
    Button {
      showView = true
    } label: {
      Text(title)
        .bold()
        .frame(width: 280, height: 50)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
  }
}

//#Preview {
//  ContentView()
//}
