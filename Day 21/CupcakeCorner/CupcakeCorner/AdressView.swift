//
//  AdressView.swift
//  CupcakeCorner
//
//  Created by Taufiq Widi on 22/03/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.property.name)
                TextField("Street Address", text: $order.property.streetAddress)
                TextField("City", text: $order.property.city)
                TextField("Zip", text: $order.property.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(!order.property.hasValidAddress)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
