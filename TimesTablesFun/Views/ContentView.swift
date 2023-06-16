//
//  ContentView.swift
//  TimesTablesFun
//
//  Created by Chuck Condron on 6/12/23.
//

import SwiftUI

struct ContentView: View {
  @State private var gameStarted = false
  @State private var practiceNumber = 2
  @State private var numberOfTries = 1
  @State private var randomQuestions = false
  
  var body: some View {
    if gameStarted {
      GameView(practiceNumber: practiceNumber, numberOfTries: numberOfTries, randomQuestions: randomQuestions, newGame: newGame, reportCard: "" )
    } else {
      SettingsView(startGame: startGame)
    }
  }
  
  func startGame(with practiceNumber: Int, numberOfTries: Int, randomQuestions: Bool) {
    self.practiceNumber = practiceNumber
    self.numberOfTries = numberOfTries
    self.randomQuestions = randomQuestions
    gameStarted = true
  }
  
  func newGame() {
    gameStarted = false
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
