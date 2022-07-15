//
//  Task.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/07.
//

import RealmSwift

class TaskObject: Object {
    @objc dynamic var id: Int = 0

    @objc dynamic var title: String? = ""

    @objc dynamic var contents: String? = ""

    @objc dynamic var date: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(taskModel: TaskModel) {
        self.init()
        self.id = taskModel.id
        self.title = taskModel.title
        self.contents = taskModel.contents
        self.date = taskModel.date
    }
}
