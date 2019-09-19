//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Uptiie on 9/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class EntryController {
    
    @discardableResult func createEntry(with title: String, bodyText: String, identifier: String, timestamp: Date) -> Entry {
        
        let entry = Entry(title: title, bodyText: bodyText, identifier: identifier, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        
        CoreDataStack.shared.saveToPersistentStore()
        
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, identifier: String, timestamp: Date) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.identifier = identifier
        entry.timestamp = timestamp
        
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
