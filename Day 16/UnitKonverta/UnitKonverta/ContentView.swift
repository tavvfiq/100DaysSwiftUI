//
//  ContentView.swift
//  UnitKonverta
//
//  Created by Taufiq Widi on 08/03/21.
//

import SwiftUI

class CustomUnit: Dimension {
    var type: UnitType
    init(){

    }
}

struct ContentView: View {

    @State private var types: [String] = ["Length", "Mass", "Volume", "Temperature", "Time"]

    @State private var selectedType: Int = 0
    @State private var inputType: Int = 0
    @State private var conversionType: Int = 0
    @State private var input: String = ""

    private var selectedUnits: [Unit]  {
        switch types[selectedType] {
        case "Length":
            return lengthUnits
        case "Mass":
            return massUnits
        case "Volume":
            return volumeUnits
        case "Temperature":
            return tempUnits
        case "Time":
            return timeUnits
        default:
            return lengthUnits
        }
    }

    private var output: Double {
        let meas = Measurement(value:Double(input) ?? 0, unit: selectedUnits[inputType])
        let result = meas.converted(to: selectedUnits[conversionType])
        return result.value
    }

    var lengthUnits: [UnitLength] = [.millimeters, .centimeters, .inches, .meters]
    var massUnits: [UnitMass] = [.grams, .pounds, .kilograms, .ounces]


    var tempUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin, .kelvin]
    var volumeUnits: [UnitVolume] = [.milliliters, .liters, .gallons, .cups]
    var timeUnits: [UnitDuration] = [.milliseconds, .seconds, .minutes, .hours]

    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                Picker("\(self.types[selectedType])", selection: $selectedType) {
                    ForEach(0..<types.count) {
                        Text(self.types[$0])

                    }
                }.pickerStyle(MenuPickerStyle())
                Form {
                    HStack {
                        TextField("Value", text: $input)
                        Picker("\(self.selectedUnits[inputType < selectedUnits.count ? inputType : selectedUnits.count-1].symbol)", selection: $inputType) {
                            ForEach(0..<selectedUnits.count) { (index) in
                                Text("\(self.selectedUnits[index].symbol)")

                            }
                        }.pickerStyle(MenuPickerStyle())
                        Text("to")
                        Picker("\(self.selectedUnits[conversionType < selectedUnits.count ? conversionType : selectedUnits.count-1].symbol)", selection: $conversionType) {
                            ForEach(0..<selectedUnits.count) { (index) in
                                Text("\(self.selectedUnits[index].symbol)")

                            }
                        }.pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Spacer()
                        Text("\(output, specifier: "%.2f")")
                        Spacer()
                    }

                }
            }

            .navigationBarTitle(Text("Unit Konverta"), displayMode: .inline)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
