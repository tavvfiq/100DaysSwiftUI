//
//  User+CoreDataClass.swift
//  ConsolidationV
//
//  Created by Taufiq Widi on 24/03/21.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(User)
public class User: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, name, age, company, address, about, email, tags, isActive, registered, friends
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext!] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container?.decode(String.self, forKey: .id)
        self.name = try? container?.decode(String.self, forKey: .name)
        self.company = try? container?.decode(String.self, forKey: .company)
        self.address = try? container?.decode(String.self, forKey: .address)
        self.about = try? container?.decode(String.self, forKey: .about)
        self.email = try? container?.decode(String.self, forKey: .email)
        self.tags = try? container?.decode([String].self, forKey: .tags)
        self.isActive = (try? container?.decode(Bool.self, forKey: .isActive))!
        self.registered = try? container?.decode(String.self, forKey: .registered)
        self.age = (try? container?.decode(Int16.self, forKey: .age))!
        self.friends = try? container?.decode(Set<Friend>.self, forKey: .friends) as NSSet?
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(email, forKey: .email)
        try container.encode(tags, forKey: .tags)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(registered, forKey: .registered)
        try container.encode(friends as! Set<Friend>, forKey: .friends)
    }
}
