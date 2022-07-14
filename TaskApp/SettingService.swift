//
//  SettingService.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/04.
//

import Foundation

final class SettingService: NSObject {
    // private
    private var realmOperator: RealmOperatorProtocol?
    // Singleton
    static let sharedInstance = SettingService()

    private override init() {
        self.realmOperator = RealmOperator()
    }

    private(set) var taskList: TaskModel?
}

// MARK: - SettingServiceProtocol

extension SettingService: SettingServiceProtocol {
    
    /// タスク情報の取得
    ///
    /// - Returns: TaskModel
    func fetchTaskList() -> [TaskModel] {
        do {
            if let taskListData = try self.realmOperator?.fetchTaskList() {
                return taskListData.map { TaskModel(taskObject: $0) }
            }
            return [TaskModel]()
        } catch {
            return [TaskModel]()
        }
        
    }

    /// 最上位IDの取得
    ///
    /// - Returns: 最上位ID
    func fetchTopId() -> Int {
        do {
            if let id = try self.realmOperator?.fetchTopId() {
                return id
            }
            return 0
        } catch {
            return 0
        }
    }

    /// タスクの取得
    ///
    /// - Parameter taskId: タスクID
    /// - Returns: TaskModel?
    func fetchTask(_ taskId: Int) -> TaskModel? {
        do {
            if let taskData = try self.realmOperator?.fetchTask(taskId) {
                return TaskModel(taskObject: taskData)
            }
            return nil
        } catch {
            return nil
        }
    }

    /// タスク情報の追加
    ///
    /// - Parameter taskListModel: TaskModel
    /// - Returns: 成功/失敗
    func addTaskList(_ taskListModel: TaskModel) -> Bool {
        do {
            try self.realmOperator?.addTaskList(taskListModel)
            return true
        } catch {
            print("✌️ TaskModel add Failed.")
            return false
        }
    }

    /// タスクの更新
    ///
    /// - Parameter taskListModel: TaskModel
    /// - Returns: 成功/失敗
    func updateTaskList(_ taskListModel: TaskModel) -> Bool {
        do {
            try self.realmOperator?.updateTask(taskListModel)
            return true
        } catch {
            print("✌️ TaskModel update Failed.")
            return false
        }
    }

    /// タスクの削除
    ///
    /// - Parameter taskId: タスクID
    /// - Returns: 成功/失敗
    func deleteTask(_ taskId: Int) -> Bool {
        do {
            try self.realmOperator?.deleteTaskList(taskId)
            return true
        } catch {
            print("✌️ Task Delete Failed.")
            return false
        }
    }
}
