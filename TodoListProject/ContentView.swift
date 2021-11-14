//
//  ContentView.swift
//  TodoListProject
//
//  Created by loujain on 05/11/2021.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable {
    var id: UUID{
        return UUID()
    }
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
extension Priority{
    var title : String{
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title : String = ""
    @State var info: String = ""
    @State private var selectedPriority : Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors:
                    [NSSortDescriptor(key: "dateCreated" , ascending: false)])
    private var AllTasks: FetchedResults<Task>
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter your title" , text: $title)
                    .textFieldStyle(.roundedBorder)
                TextField("Enter your Info", text: $info)
                    .textFieldStyle(.roundedBorder)
                Picker("Priority" , selection: $selectedPriority){
                    ForEach(Priority.allCases){ priority in
                        Text(priority.title).tag(priority)
                        
                    }
                    
                }//Picker
//                .pickerStyle(SegmentedPickerStyle())
                .pickerStyle(.segmented)
                .padding(10)
                .frame( maxWidth: .infinity)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10 , style: .continuous))
                Button("save"){
                    do {
                        let task = Task(context: viewContext)
                        task.title = title
                        task.info = info
                        task.priority = selectedPriority.rawValue
                        task.dateCreated = Date()
                        try viewContext.save()
                    } catch {
//                         print(error.localizedDescription)
                    }
                    
                }//Button
                .padding(14)
                .frame( maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10 , style: .continuous))
                
                List{
                    if AllTasks.isEmpty {
                        Text("Tasks are empty")
                    }else {
                        ForEach(AllTasks){ task in
                            NavigationLink(destination: {
                                UpdateTaskView(task: task)
                            }, label: {
                                HStack(alignment:.center, spacing: 20){
                                    Text(task.title ?? "")
                                        .font(.title2)
                                    Text(task.info ?? "")
                                        .font(.caption)
                                    Text(task.priority ?? "")
                                        .font(.caption)
                                    Spacer()
                                    Button {
                                        task.isFavorite = !task.isFavorite
                                        do{
                                            try viewContext.save()
                                        }catch {
//                                            print(error.localizedDescription)
                                        }
                                    } label: {
                                        Image(systemName: task.isFavorite ? "heart.fill" : "heart")
                                    }.buttonStyle(.borderless)
                                    
                                }//VStack
                            })//label
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        if let deletedTask = AllTasks.firstIndex(of: task){
                                            viewContext.delete(AllTasks[deletedTask])
                                            do {
                                                try viewContext.save()
                                            } catch{}
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }.tint(.red)
                                }//swip
                        }//for
                        
                    }//else
                }//List
                
                Spacer()
            }//VStack
            .padding()
            .navigationTitle("Tasks")
        }//Navv
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistentContainer = CoreDataManager.shared.persistentContainer
        ContentView()
//            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, persistentContainer.viewContext)
    }
}
