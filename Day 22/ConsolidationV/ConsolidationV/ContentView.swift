//
//  ContentView.swift
//  ConsolidationV
//
//  Created by Taufiq Widi on 24/03/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)]) var users: FetchedResults<User>

    @State private var loading = false

    let persistenceController = PersistenceController.shared

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if !users.isEmpty {
                        ForEach(users, id: \.id) { user in
                            NavigationLink(destination: DetailView(user: user, users: users)) {
                                VStack {
                                    HStack {
                                        Text(unwrapString(value: user.name))
                                            .font(.headline)
                                        Spacer()
                                        Text(unwrapString(value: user.company))
                                            .font(.subheadline)
                                    }
                                    HStack {
                                        Text(unwrapString(value: user.email))
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteUser)
                    } else {
                        Text("No users found")
                    }
                }
                GeometryReader { geo in
                    Button(action: {
                        self.fetchDataOverTheAir(reset: true)
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 50, height: 50)
                            if loading {
                                ActivityIndicator()
                            } else {
                                Image(systemName: "icloud.and.arrow.down")
                                    .foregroundColor(.white)
                            }
                        }

                    }
                    .disabled(loading)
                    .shadow(radius: 5)
                    .offset(x: geo.size.width - 100, y: geo.size.height - 50)
                }
            }
            .onAppear(perform: loadData)
            .navigationTitle("Users: \(users.count)")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteUser(at offset: IndexSet) {
        for index in offset {
            let user = users[index]
            DispatchQueue.main.async {
                self.moc.delete(user)
                if self.moc.hasChanges {
                    do {
                        try self.moc.save()
                    } catch {
                        print("Error on saving")
                    }
                }
            }
        }
    }

    private func fetchDataOverTheAir(reset: Bool = false) {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = self.moc
        let url = URL(string:"https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("no data in response")
                return
            }
            self.loading = true
            DispatchQueue.main.async {
                if reset {
                    persistenceController.resetUser()
                }
                guard let _ = try? decoder.decode([User].self, from: data) else {
                    print("invalid data in response")
                    return
                }
                self.loading = false
            }

        }
        .resume()
    }

    private func loadData(){
        if users.isEmpty {
            fetchDataOverTheAir()
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
