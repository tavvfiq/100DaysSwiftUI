//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Taufiq Widi on 22/03/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.property.type) {
                        ForEach(0..<OrderProperty.types.count, id: \.self) {
                            Text(OrderProperty.types[$0])
                        }
                    }

                    Stepper(value: $order.property.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.property.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $order.property.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if order.property.specialRequestEnabled {
                        Toggle(isOn: $order.property.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $order.property.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
