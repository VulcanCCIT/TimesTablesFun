//
//  SettingsView.swift
//  TimesTablesFun
//
//  Created by Chuck Condron on 6/15/23.
//

import SwiftUI

struct SettingsView: View {
  @State private var practiceNumber = 10
  @State private var numberOfTries = 20
  @State private var randomQuestions = false
  
  var numberRange = [5, 10, 20]
  
  let startGame: (Int, Int, Bool) -> Void
  
  var body: some View {
    VStack {
      NavigationView {
        Form {
          
          Section {
            Toggle("Random Number?", isOn: $randomQuestions)
          }
          
          Section(header: Text("Select Number To Practice")) {
            Picker("Select Number To Practice", selection: $practiceNumber)
            {
              ForEach(1..<13) {
                Text("\($0)")
              }
            }
          }
          .opacity(randomQuestions ? 0 : 1)
          
          Section(header: Text("Number of Tries")) {
            Picker("Number of tries", selection: $numberOfTries) {
              ForEach(numberRange, id: \.self) {
                Text("\($0)")
              }
            }
            .pickerStyle(.segmented)
          }
          
        }
        .navigationTitle("Game Settings")
      }
      
      Button("Start Game") {
        startGame(practiceNumber + 1, numberOfTries, randomQuestions)
      }
      .buttonStyle(.borderedProminent)
    }
  }
}



struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(startGame: {_, _, _ in })
  }
}
