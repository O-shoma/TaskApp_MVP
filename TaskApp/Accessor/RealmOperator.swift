//
//  RealmOperator.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation
import RealmSwift

final class RealmOperator {
    // RealmError
    private let kRealmError = NSError(domain: "RealmError", code: 0, userInfo: nil) as Error

    private let kRealmSchemeVersion: UInt64 = 1

    // MARK: - Realm Initialize

    /// Realmの初期設定
    ///
    /// - Returns: Realmオブジェクト
    private func settingDefaultRealm() -> Realm? {
        var realm: Realm?

        do {
            var config = Realm.Configuration()

            let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
            let filePath = "\(libraryDirectory)/Realm"
            try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)

            var fileURL = URL(string: filePath)
            fileURL = fileURL?.appendingPathComponent("TaskApp").appendingPathExtension("realm")

            config.fileURL = fileURL

            // マイグレーション処理
            config.schemaVersion = self.kRealmSchemeVersion
            config.migrationBlock = { (migration, oldSchemaVersion) in
                // マイグレーション
                if oldSchemaVersion < self.kRealmSchemeVersion {
                    // TaskObject
                    migration.enumerateObjects(ofType: TaskObject.className()) { oldObject, newObject in
                        guard let _ = oldObject, let _ = newObject else { return }

                    }
                }
            }

            realm = try Realm(configuration: config)
        } catch {
            print("✌️Realm Instance Error")
        }

        return realm
    }
}

// MARK: - RealmOperatorProtocol

extension RealmOperator: RealmOperatorProtocol {

    /// タスク情報の取得
    ///
    /// - Returns: タスク
    func fetchTaskList() throws -> Results<TaskObject> {
        if let realm = self.settingDefaultRealm() {
            return realm.objects(TaskObject.self).sorted(byKeyPath: "id")
        } else {
            throw self.kRealmError
        }
    }

    /// 最上位IDの取得
    ///
    /// - Returns: 最上位ID
    func fetchTopId() throws -> Int {
        if let realm = self.settingDefaultRealm(),
           let taskObject = realm.objects(TaskObject.self).last {
            return taskObject.id
        } else {
            throw self.kRealmError
        }
    }

    /// タスクの取得
    ///
    /// - Parameter taskId: タスクID
    /// - Returns: TaskObject?
    func fetchTask(_ taskId: Int) throws -> TaskObject? {
        if let realm = self.settingDefaultRealm() {
            return realm.objects(TaskObject.self).sorted(byKeyPath: "id").filter("id == %@", taskId).first
        } else {
            throw self.kRealmError
        }
    }

    /// タスク情報の追加
    ///
    /// - Parameter taskListModel: TaskModel
    func addTaskList(_ taskListModel: TaskModel) throws {
        let taskListObject = TaskObject(taskModel: taskListModel)

        if let realm = self.settingDefaultRealm() {
            do {
                try realm.write {
                    realm.add(taskListObject, update: .modified)
                }
            } catch {
                print("TaskListData Add Realm Failed.")
                throw self.kRealmError
            }
        } else {
            throw self.kRealmError
        }
    }

    /// タスクの更新
    ///
    /// - Parameter taskListModel: TaskModel
    func updateTask(_ taskListModel: TaskModel) throws {
        let taskListObject = TaskObject(taskModel: taskListModel)

        if let realm = self.settingDefaultRealm() {
            do {
                guard let getTaskObject = realm.objects(TaskObject.self).sorted(byKeyPath: "id").filter("id == %@", taskListModel.id).first else {
                    throw self.kRealmError

                }
                try realm.write {
                    // 一旦削除している
                    realm.delete(getTaskObject)

                    realm.add(taskListObject, update: .modified)
                }
            } catch {
                print("TaskListData Update Failed.")
                throw self.kRealmError
            }
        }
    }

    /// タスクの削除
    ///
    /// - Parameter taskId: タスクID
    func deleteTaskList(_ taskId: Int) throws {
        if let realm = self.settingDefaultRealm(),
           let deleteTask = realm.objects(TaskObject.self).sorted(byKeyPath: "id").filter("id == %@", taskId).first {
            do {
                try realm.write {
                    realm.delete(deleteTask)
                }
            } catch {
                print("Task Delete Failed.")
                throw self.kRealmError
            }
        }
    }
}
