//
//  Event.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import SwiftUI
import CoreData

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

extension Counter {
    static func create(in managedObjectContext: NSManagedObjectContext, with name: String?){
        let newEvent = self.init(context: managedObjectContext)
        newEvent.timestamp = Date()
        newEvent.uuid = UUID()
        if let eventName = name {
            newEvent.name = eventName
        }
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // Function that creates a file and returns it's URL
    func exportToCSV() throws -> URL {
        // filename is name + date
        let fileName = "\(self.wrappedName) - \(dateFormatter.string(from: self.timestamp!))"
        let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        guard let fileURL = documentDirectory?.appendingPathComponent(fileName).appendingPathExtension("csv") else {
            throw NSError()
        }
        let csvString = writeWinesToCSV()
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
    
    private func writeWinesToCSV() -> String {
        let firstline = "name, count\n"
        var csvData = ""
        if self.counterDetailsArray.count > 0 {
            for detailCounter in self.counterDetailsArray {
                if detailCounter.count > 0 {
                    csvData.append("\(detailCounter.wrappedName), \(detailCounter.count)\n")
                }
            }
            return firstline + csvData
        } else {
            return ""
        }
    }
    
}

extension Collection where Element == Counter, Index == Int {
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
