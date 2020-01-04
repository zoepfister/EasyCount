//
//  Counter+CoreDataProperties.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var counterDetails: NSSet?
    
    public var counterDetailsArray: [CounterDetail] {
        let set = counterDetails as? Set<CounterDetail> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var wrappedName: String {
        name ?? "Unnamed Counter"
    }

}

// MARK: Generated accessors for counterDetails
extension Counter {

    @objc(addCounterDetailsObject:)
    @NSManaged public func addToCounterDetails(_ value: CounterDetail)

    @objc(removeCounterDetailsObject:)
    @NSManaged public func removeFromCounterDetails(_ value: CounterDetail)

    @objc(addCounterDetails:)
    @NSManaged public func addToCounterDetails(_ values: NSSet)

    @objc(removeCounterDetails:)
    @NSManaged public func removeFromCounterDetails(_ values: NSSet)

}
