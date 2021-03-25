//
//  Friend+CoreDataClass.swift
//  ConsolidationV
//
//  Created by Taufiq Widi on 24/03/21.
//
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, name
    }
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext!] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try? decoder.container(keyedBy: CodingKeys.self)

        self.id = try? container?.decode(String.self, forKey: .id)
        self.name = try? container?.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
