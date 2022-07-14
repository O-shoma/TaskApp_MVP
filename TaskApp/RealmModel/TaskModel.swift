//
//  TaskModel.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation

struct TaskModel: Equatable {
    var id: Int
    var title: String?
    var contents: String?
    var date: String

    init() {
        self.id = 0
        self.title = ""
        self.contents = ""
        self.date = ""
    }

    init(taskObject: TaskObject) {
        self.id = taskObject.id
        self.title = taskObject.title
        self.contents = taskObject.contents
        self.date = taskObject.date
    }
}
