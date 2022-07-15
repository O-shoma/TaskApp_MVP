//
//  TaskListContents.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/07.
//

struct TaskListContents {

    let taskId: Int
    let title: String
    let taskLimit: String
    let category: String

    init(taskId: Int,
         title: String,
         taskLimit: String,
         category: String = "") {
        self.taskId = taskId
        self.title = title
        self.taskLimit = taskLimit
        self.category = category
    }
}
