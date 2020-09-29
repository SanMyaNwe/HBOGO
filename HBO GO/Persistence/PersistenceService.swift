//
//  PersistenceService.swift
//  HBO GO
//
//  Created by Riki on 8/3/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    static let shared = PersistenceService()
    
    private init() {}
    
    lazy var persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDB")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Persistene load error: - \(error.localizedDescription)")
            }
        }
        return container
    } ()
    
    func saveContext() {
        do {
            try persistenceContainer.viewContext.save()
            
        } catch {
            print("Persistence save fail...")
        }
        
    }
    
    
}
