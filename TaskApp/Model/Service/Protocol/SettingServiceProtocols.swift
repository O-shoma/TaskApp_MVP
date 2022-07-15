//
//  SettingServiceProtocolds.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/07.
//

protocol SettingServiceProtocol: AnyObject {
    func fetchTaskList() -> [TaskModel]
    func fetchTopId() -> Int
    func fetchTask(_ taskId: Int) -> TaskModel?
    func addTaskList(_ taskListModel: TaskModel) -> Bool
    func updateTaskList(_ taskListModel: TaskModel) -> Bool
    func deleteTask(_ taskId: Int) -> Bool
}
