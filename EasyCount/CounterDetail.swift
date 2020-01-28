//
//  CounterDetail.swift
//  EasyCount
//
//  Created by Zoë Pfister on 04.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import SwiftUI
import CoreData

extension CounterDetail {
    static func create(in managedObjectContext: NSManagedObjectContext, startCount: Int64 = 1) -> CounterDetail {
        let newEvent = self.init(context: managedObjectContext)
        newEvent.uuid = UUID()
        newEvent.count = startCount
        newEvent.name = "\(Date())"
        // newEvent.counter = counter
        
        do {
            try  managedObjectContext.save()
            return newEvent
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func countUp(by amount: Int64){
        self.count += amount
    }
    
    func countDown(by amount: Int64){
        self.count -= amount
    }
    
}

extension Collection where Element == CounterDetail, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
