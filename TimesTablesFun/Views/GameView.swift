//
//  GameView.swift
//  TimesTablesFun
//
//  Created by Chuck Condron on 6/15/23.
//

import SwiftUI
import AVFoundation

struct GameView: View {
  
  let practiceNumber: Int
  let numberOfTries: Int
  let randomQuestions: Bool
  let newGame: () -> Void
  //let startGame: (Int, Int, Bool) -> Void
  
  @State private var leftRandomPickedNumber = 1
  @State private var rightRandomPickedNumber = 1
  @State private var isRotating = false
  @State private var userAnswer: Int = 0
  @State private var answer = 0
  @State private var timeRemaining = 0
  @State private var score = 0
  @State private var startButtonVisible = true
  
  @State private var currentQuestion = 0
  //@State private var totalQuestions = 2
  
  //alert configuration variables
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var gameOver = false
  @State private var gameStarted = false
  @State private var beginGame = false
  
  //  init() {
  //    UITextField.appearance().clearButtonMode = .whileEditing
  //  }
  
  let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
  
  
  var foreverAnimation: Animation {
    Animation.interpolatingSpring(mass: 5, stiffness: 170, damping: 15, initialVelocity: 20)
  }
  
  @State var reportCard: String
  
  var body: some View {
    VStack(spacing: 20) {
      Button(action: {
        gameOver = false
        beginGame = true
        spin()
        startButtonVisible = false
        
      }, label: {
        Text("Click To Play!")
          .padding()
          .foregroundColor(.white)
          .background(Color.green)
          .font(.title)
          .fontWeight(.bold)
          .cornerRadius(20)
          .opacity(startButtonVisible ? 1: 0)
      })
      
      ZStack {
        HStack() {
          Image(systemName: "\(leftRandomPickedNumber).circle.fill")
            .renderingMode(.original)
            .resizable()
            .frame(width: 150, height: 150)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .rotation3DEffect(Angle.degrees(isRotating ? 360 : 0), axis: (x: 1, y: 0, z: 0))
            .opacity(!gameOver ? 1 : 0)
          
          
          Text("X")
            .foregroundColor(.red)
            .font(.custom("Title", size: 50))
            .opacity(!gameOver ? 1 : 0)
          
          Image(systemName: "\(rightRandomPickedNumber).circle.fill")
            .renderingMode(.original)
            .resizable()
            .frame(width: 150, height: 150)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .rotation3DEffect(Angle.degrees(isRotating ? 360 : 0), axis: (x: 1, y: 0, z: 0))
            .opacity(!gameOver ? 1 : 0)
            .onReceive(timer) { _ in
              if timeRemaining > 0 && !gameOver {
                AudioServicesPlaySystemSound(1306)
                timeRemaining -= 1
                
                if randomQuestions == false {
                  leftRandomPickedNumber = practiceNumber
                } else {
                  leftRandomPickedNumber = Int.random(in: 1..<13)
                }
                rightRandomPickedNumber = Int.random(in: 1..<13)
              }
            }
        }
      }
      Divider()
        .frame(minHeight: 5)
        .overlay(Color.green)
      
      Text("Enter Your Answer")
        .font(.title)
        .foregroundColor(.red)
        .fontWeight(.bold)
        .opacity(!beginGame ? 0 : 1)
      TextField("Answer", value: $userAnswer, format: .number)
        .onAppear {
          UITextField.appearance().clearButtonMode = .whileEditing
        }        .multilineTextAlignment(.center)
        .frame(width: 100, height: 30)
        .foregroundColor(.blue)
        .fontWeight(.bold)
        .textFieldStyle(.roundedBorder)
        .opacity(!beginGame ? 0 : 1)
      
      Button(action: {
        checkAnswer()
      }, label: {
        Text("Check Answer")
          .padding()
          .foregroundColor(.white)
          .background(Color.green)
          .font(.title)
          .fontWeight(.bold)
          .cornerRadius(20)
          .opacity(!beginGame ? 0 : 1)
      })
      .alert(alertMessage, isPresented: $showAlert) {
        Button("OK", role: .cancel) {
          if !gameOver {
            spin()
          } else {
            newGame()
          }
          
        }
      }
      
      Text("Your score: \(score)")
        .font(.title)
        .foregroundColor(.red)
        .fontWeight(.bold)
    }
  }
  
  
  func spin() {
    timeRemaining = 11
    withAnimation(foreverAnimation) {
      self.isRotating.toggle()
    }
  }
  
  // check if the answer is correct dispaly the correct answer if the user is wrong
  func checkAnswer() {
    answer = leftRandomPickedNumber * rightRandomPickedNumber
    
    if answer == userAnswer {
      score += 1
      alertMessage = "Correct!\n"
      reportCard.append("Question #\(currentQuestion + 1): \(leftRandomPickedNumber) X \(rightRandomPickedNumber) = \(answer) was Correct!\n\n")
    } else {
      score -= 1
      alertMessage = "Sorry the answer is \(answer)\n"
      reportCard.append("Question #\(currentQuestion + 1): \(leftRandomPickedNumber) X \(rightRandomPickedNumber) = \(answer) was Wrong... your answer was \(userAnswer)\n\n")
    }
    currentQuestion += 1
    if currentQuestion != numberOfTries {
      showAlert = true
    } else {
      gameOver = true
      alertMessage = alertMessage + " Game Over!! Your final score was: \(score)\n\n" + reportCard
      showAlert = true
    }
  }
}


struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView(practiceNumber: 3, numberOfTries: 2, randomQuestions: false, newGame: {}, reportCard: "")
  }
}
