//
//  DetailView.swift
//  ConsolidationV
//
//  Created by Taufiq Widi on 24/03/21.
//

import SwiftUI

//TODO: Return when user == nil

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var user: User
    var users: FetchedResults<User>

    private var firstName: String {
        return unwrapString(value: user.name).components(separatedBy: " ")[0]
    }

    private var unWrappedTags: [String] {
        user.tags ?? []
    }

    private var friends: [Friend] {
        let set = user.friends as? Set<Friend> ?? []
        return set.sorted(by: {
            unwrapString(value: $0.name) < unwrapString(value: $1.name)
        })
    }

    private var tags: [[String]] {
        let numOfEl = 4
        var result = [[String]]()
        for i in stride(from: 0, to: unWrappedTags.count - 1, by: numOfEl) {
            var temp = [String]()
            var constraint = i+numOfEl
            if constraint >= unWrappedTags.count - 1 {
                constraint = unWrappedTags.count - 1
            }
            for j in stride(from: i, to: constraint, by: 1) {
                temp.append(unWrappedTags[j])
            }
            result.append(temp)
        }
        return result
    }

    private var registeredDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: unwrapString(value: user.registered)) ?? Date()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 150)
                    Text(firstName.prefix(1))
                        .font(Font.custom("SF",size: 32))
                        .foregroundColor(.white)
                }
                .shadow(radius:5)
                HStack {
                    Text(unwrapString(value: user.name))
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(user.isActive ? "Active" : "Not Active")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(3)
                        .foregroundColor(.white)
                        .background(user.isActive ? Color.green.opacity(0.75) : Color.red.opacity(0.75))
                        .clipShape(Capsule())
                        .shadow(radius:5)
                }
                Text(unwrapString(value: user.email))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Tags:")
                    .font(.caption)
                ForEach(tags, id: \.self) { tag in
                    HStack {
                        ForEach(tag, id:\.self) { el in
                            Text(el)
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0.75))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            Spacer()
            Form {
                Section(header: Text("About")) {
                    Text(unwrapString(value: user.about))
                }
                Section(header: Text("Address")) {
                    Text(unwrapString(value: user.address))
                }
                Section(header: Text("Company")) {
                    Text(unwrapString(value: user.company))
                }
                Section(header: Text("Registered")) {
                    Text(registeredDate)
                }
                Section(header: Text("Friends List")) {
                    List {
                        ForEach(friends, id: \.id) { friend in
                            let selectedFriend = users.first(where: { user in
                                friend.id == user.id
                            })
                            NavigationLink(destination: goToDetail(user: selectedFriend)) {
                                Text(unwrapString(value: friend.name))
                            }
                        }

                    }
                }
            }
            Spacer()
        }
        .navigationTitle(firstName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func goToDetail(user: User?) -> some View {
        if user != nil {
            return AnyView(DetailView(user: user!, users: self.users))
        }
        return AnyView(Text("User not found"))
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(user: User, appState: AppState())
//    }
//}
