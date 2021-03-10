//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Taufiq Widi on 10/03/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer =  Int.random(in: 0...2)
    @State private var alertShown = false
    @State private var scoreTitle = ""
    @State private var alertInfo = ""
    @State private var score = 0

    private func onFlagTapped(flagIndex: Int){
        if flagIndex == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            alertInfo = ""
        } else {
            scoreTitle = "Wrong"
            score -= 1
            alertInfo = "Wrong! that's the flag of \(countries[flagIndex])"
        }
        alertShown = true
    }

    private func continueGuessing(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:30) {
                VStack {
                    Text("Guess the flag of...")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0..<3) { (index) in
                    FlagImage(flagName: self.countries[index]) {
                        self.onFlagTapped(flagIndex: index)
                    }
                }
                Spacer()
            }
        }.alert(isPresented: $alertShown){
            Alert(title: Text(scoreTitle), message: Text("\(alertInfo) \nYour score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.continueGuessing()
            })
        }
    }
}

struct FlagImage: View {
    let flagName: String
    let onTap: () -> Void
    var body: some View {
        Button(action: self.onTap, label: {
            Image(self.flagName)
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
