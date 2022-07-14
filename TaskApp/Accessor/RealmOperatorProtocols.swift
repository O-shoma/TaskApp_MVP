//
//  RealmOperatorProtocols.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation
import RealmSwift

protocol RealmOperatorProtocol {
    func fetchTaskList() throws -> Results<TaskObject>
    func fetchTopId() throws -> Int
    func fetchTask(_ taskId: Int) throws -> TaskObject?
    func addTaskList(_ taskListModel: TaskModel) throws
    func updateTask(_ taskListModel: TaskModel) throws
    func deleteTaskList(_ taskId: Int) throws
}
