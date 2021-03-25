////
////  UserModel.swift
////  ConsolidationV
////
////  Created by Taufiq Widi on 24/03/21.
////
//
import SwiftUI
import CoreData
//
enum AppEnum: CodingKey {
    case users
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}


class AppState<T: NSManagedObject>: ObservableObject {
    @Published var users: FetchedResults<T>?
    init() {}
}
