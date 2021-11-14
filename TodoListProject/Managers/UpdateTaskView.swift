//
//  UpdateTaskView.swift
//  TodoListProject
//
//  Created by loujain on 05/11/2021.
//

import SwiftUI

struct UpdateTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var task: Task?
    @State var title: String = ""
    @State var info: String = ""

//    @State var priority: String = ""
    @State private var selectedPriority : Priority = .medium

    @State var isFavorite: Bool = false
    @Environment(\.presentationMode) var presentationMode
    init(task: Task? = nil) {
        self.task = task
        _title = State(initialValue: task?.title ?? "" )
        _info = State(initialValue: task?.info ?? "" )

//        _priority = State(initialValue:task?.priority ?? "" )
        _isFavorite = State(initialValue: task?.isFavorite ?? false )
    }
    var body: some View {
        NavigationView{
            VStack{
                TextField("Edit your Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                TextField("Edit your Info", text: $info)
                    .textFieldStyle(.roundedBorder)
                Picker("Priority" , selection: $selectedPriority){
                    ForEach(Priority.allCases){ priority in
                        Text(priority.title).tag(priority)
                        
                    }
                    
                }//Picker
                .pickerStyle(.segmented)
                .padding(10)
                .frame( maxWidth: .infinity)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10 , style: .continuous))
            
                Toggle(isOn: $isFavorite) {}.labelsHidden()
                Button{
                    
                    do {
                        if let task = task {
                            task.title = title
                            task.info = info
                            task.priority = selectedPriority.rawValue
                            task.isFavorite = isFavorite
                            try viewContext.save()
                        }
                    } catch {
//                         print(error.localizedDescription)
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
                
            }
        }
    }
}

struct UpdateTaskView_Previews: PreviewProvider {
    static var previews: some View {
    let persistentContainer = CoreDataManager.shared.persistentContainer
        UpdateTaskView()
//            .preferredColorScheme(.dark)

.environment(\.managedObjectContext, persistentContainer.viewContext)

    }
}
