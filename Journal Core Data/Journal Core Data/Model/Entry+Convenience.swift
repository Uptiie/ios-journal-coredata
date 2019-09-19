//
//  Entry+Convenience.swift
//  Journal Core Data
//
//  Created by Uptiie on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, identifier: String, timestamp: Date, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
    
}
