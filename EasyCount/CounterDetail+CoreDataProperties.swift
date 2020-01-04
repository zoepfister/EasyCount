//
//  CounterDetail+CoreDataProperties.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//
//

import Foundation
import CoreData


extension CounterDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CounterDetail> {
        return NSFetchRequest<CounterDetail>(entityName: "CounterDetail")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var count: Int64
    @NSManaged public var counter: Counter?
    
    public var wrappedName: String {
        name ?? "Unknown"
    }

}
