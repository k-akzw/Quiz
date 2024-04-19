//
//  QuizApp.swift
//  Quiz
//
//  Created by Kento Akazawa on 4/18/24.
//

import SwiftUI

@main
struct QuizApp: App {
  @StateObject private var dataController = DataController()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
  }
}
