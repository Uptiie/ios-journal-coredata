//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Uptiie on 9/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
    // We are using this as the "viewDidLoad" of the TaskController
    init() {
        fetchTasksFromServer()
    }
    
    let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding task representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            
            completion()
            }.resume()
    }
    
    func fetchTasksFromServer(completion: @escaping () -> Void = { }) {
        
        // appendingPathComponent adds a /
        // appendingPathExtension add a .
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let entryReprentations = try decoder.decode([String: entryRepresentation].self, from: data).map({ $0.value })
                
                self.updateTasks(with: entryReprentations)
                
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
            }.resume()
    }
    
    func updateEntries(with representations: [TaskRepresentation]) {
        
        //        var identifiersToFetch: [UUID] = []
        //
        //        for representation in representations {
        //            let identifier = UUID(uuidString: representation.identifier)
        //
        //            guard let identifier2 = identifier else { continue }
        //
        //            identifiersToFetch.append(identifier2)
        //        }
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        // [UUID: TaskRepresentation]
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        var tasksToCreate = representationsByID
        
        do {
            let context = CoreDataStack.shared.mainContext
            
            let fetchRequest: NSFetchRequest<Task> = Entry.fetchRequest()
            
            // identifier == \(identifier)
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            // Which of these tasks exist in Core Data already?
            let existingTasks = try context.fetch(fetchRequest)
            
            // Which need to be updated? Which need to be put into Core Data?
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    // This gets the task representation that corresponds to the task from Core Data
                    let representation = representationsByID[identifier] else { continue }
                
                entry.name = representation.name
                entry.notes = representation.notes
                entry.priority = representation.priority
                
                entriesToCreate.removeValue(forKey: identifier)
            }
            
            // Take the tasks that AREN'T in Core Data and create new ones for them.
            for representation in tasksToCreate.values {
                Entry(taskRepresentation: representation, context: context)
            }
            
            CoreDataStack.shared.saveToPersistentStore()
            
        } catch {
            NSLog("Error fetching entries from persistent store: \(error)")
        }
    }
    
    
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
