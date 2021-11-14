//
//  TodoListProjectApp.swift
//  TodoListProject
//
//  Created by loujain on 05/11/2021.
//

import SwiftUI

@main
struct TodoListProjectApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    var body: some Scene {
   
        WindowGroup {
 
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

    //ContextView is the root view of our application.
   //the environment into the ContentView which will be available to the  ContentView
  //and all the different children of the ContentView.
 //managerObjectContext and this will be our ViewContext this means that we can access
//the managerObjectContext from inside of any view that we want.
