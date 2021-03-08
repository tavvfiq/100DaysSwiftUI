//
//  ContentView.swift
//  WeSplit
//
//  Created by Taufiq Widi on 08/03/21.
//

import SwiftUI

struct ContentView: View {
    @State private var numOfPeople: String = ""
    @State private var tipPercentages: [Int] = [25, 20, 15, 10, 5, 0]
    @State private var tipPercentage: Int = 0
    @State private var totalAmount: String = ""

    private var totalPerPerson: Double {
        let persons = Double(numOfPeople) ?? 2
        let tip = Double(tipPercentages[tipPercentage])
        let total = Double(totalAmount) ?? 0

        let tipValue = total*tip/100

        let share = (total + tipValue)/persons
        return share
    }


    var body: some View {
        NavigationView {
            Form {
                Section(header:Text("amount and people")) {

                    HStack {
                        Text("Rp. ")
                        TextField("Amount", text: $totalAmount)
                            .keyboardType(.decimalPad)
                    }

                    HStack {
                        Text("Person(s): ")
                        TextField("Number of persons", text: $numOfPeople)
                            .keyboardType(.decimalPad)
                    }

                }

                Section(header:Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(0 ..< tipPercentages.count) {
                                Text("\(self.tipPercentages[$0])%")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                }

                Section(header:Text("Total per person")) {
                    Text("Rp. \(totalPerPerson, specifier: "%.0f")")
                }
            }
            .navigationBarTitle(Text("WeSplit"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
