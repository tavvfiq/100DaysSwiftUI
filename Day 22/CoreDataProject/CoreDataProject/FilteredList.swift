//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Taufiq Widi on 23/03/21.
//

import SwiftUI
import CoreData

enum cdPredicate: String {
    case beginsWith = "BEGINSWITH",
         contains = "CONTAINS"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    init(filterKey: String, filterValue: String, predicate: cdPredicate, sortBy: [NSSortDescriptor] = [], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortBy, predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
    var body: some View {
        List(singers, id: \.self) { singer in
            self.content(singer)
        }
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filterKey: "lastName", filterValue: "A", predicate: .beginsWith) { (singer: Singer) in
            Text("Hello world")
        }
    }
}
