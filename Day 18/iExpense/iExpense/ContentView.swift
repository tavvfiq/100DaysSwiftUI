//
//  ContentView.swift
//  iExpense
//
//  Created by Taufiq Widi on 12/03/21.
//

import SwiftUI

struct ExpenseItem: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Int

}

class Expense: ObservableObject {
    @Published var items = [ExpenseItem]()
}

struct ContentView: View {
    @ObservedObject var expense = Expense()
    @State private var showSheet = false

    func removeRows(at offsets: IndexSet) {
        expense.items.remove(atOffsets: offsets)
    }

    func loadSavedData() {
        guard let retrievedData = UserDefaults.standard.data(forKey: "expenseList") else {
            return
        }
        let decoder = JSONDecoder()
        guard let data = try? decoder.decode([ExpenseItem].self, from: retrievedData) else {
            return
        }
        expense.items = data
    }

    func saveData() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(expense.items) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "expenseList")
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(expense.items, id:\.id) { item in
                        VStack {
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                            }

                            HStack {
                                Text(item.type)
                                Spacer()
                                Text("Rp. \(item.amount)")
                            }
                        }
                    }
                    .onDelete(perform: removeRows)
                }

                Button("Save expense(s)") {
                    self.saveData()
                }
                Spacer()
            }
            .navigationBarTitle("iExpense", displayMode: .inline)
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showSheet) {
                SecondView(expense: self.expense)
            }
        }
        .onAppear(perform: loadSavedData)
    }
}

struct SecondView: View {
    @State private var name = ""
    @State private var type = ""
    @State private var amount = ""
    @ObservedObject var expense: Expense

    @Environment(\.presentationMode) var presentationMode

    private func addData(){
        expense.items.append(ExpenseItem(name: name, type: type, amount: Int(amount) ?? 0))
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            Spacer()
            Text("Add Expense")
                .font(.title)
            HStack {
                Text("Name: ")
                TextField("", text: $name)
            }
            HStack {
                Text("Type: ")
                TextField("", text: $type)
            }
            HStack {
                Text("Amount: ")
                TextField("", text: $amount)
                    .keyboardType(.numberPad)
            }
            Button("Add expense") {
                addData()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Add expense")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(expense: Expense())
    }
}
