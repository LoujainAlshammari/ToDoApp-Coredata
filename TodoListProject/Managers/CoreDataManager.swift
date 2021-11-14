//
//  CoreDataManager.swift
//  TodoListProject
//
//  Created by loujain on 05/11/2021.
//

import Foundation
import CoreData

class CoreDataManager{
    let persistentContainer : NSPersistentContainer
    static let  shared : CoreDataManager = CoreDataManager()
    
    private init(){
        persistentContainer = NSPersistentContainer (name: "SimpleTodoModel")
        persistentContainer.loadPersistentStores { discription, error in
          if let error = error {
        
//              fatalError("Unable to load data\(error.localizedDescription)")

            fatalError("Unable to initiaize Core Data \(error)")
      }
    }
  }
}
