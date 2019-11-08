//
//  dataController.swift
//  VirtualTourist
//
//  Created by Lola M on 7/25/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class dataController {
    static let shared = dataController()
    let persistentContainer = NSPersistentContainer(name: "Model")
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load() {
        persistentContainer.loadPersistentStores {
            (storeDescription, Error) in
            guard Error == nil
                else {
                    fatalError(Error!.localizedDescription)
            }
        }
    }
}
