//
//  InputTaskPresenter.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation

final class InputTaskPresenter {
    var view: InputTaskOutputPresenterProtocol?

    // private
    private let settingService: SettingServiceProtocol?
    private let searchService: SearchServiceProtocol?
    private var taskModel: TaskModel = TaskModel()

    init(view: InputTaskOutputPresenterProtocol,
         settingService: SettingServiceProtocol,
         searchService: SearchServiceProtocol) {
        self.view = view
        self.settingService = settingService
        self.searchService = searchService
    }

    // MARK: - Private Methods

    /// タスクを追加
    private func addTaskObject() {
        if self.settingService?.fetchTask(self.taskModel.id) != nil {
            print("✌️IDが重複しています")
        } else {
            self.view?.didAddTaskList(self.settingService?.addTaskList(self.taskModel) ?? false)
        }
    }

    /// 遷移方法で処理を分ける
    private func taskTransitionType() {
        
        switch self.searchService?.fetchTransitionType() {
        case .newTask: self.fetchTopTaskId()
        case .editTask: self.fetchEditTask()
        case .none: break
        }

        self.view?.applyDesign()
    }

    /// 最上位タスクIDの取得
    private func fetchTopTaskId() {
        guard let id = self.settingService?.fetchTopId() else { return }

        self.taskModel.id = id + 1
    }

    /// 編集するタスクを取得
    private func fetchEditTask() {
        guard let taskId = self.searchService?.fetchSearchTaskId(),
        let task = self.settingService?.fetchTask(taskId) else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = Const.dateFormat
        let limitDate =  dateFormatter.date(from: task.date)

        self.taskModel = task
        self.view?.applySetting(task.title!,
                                task.contents!,
                                limitDate: limitDate!)
    }
}

// MARK: - InputTaskInputPresenterProtocol

extension InputTaskPresenter: InputTaskInputPresenterProtocol {

    /// viewWillAppear時
    func viewWillAppear() {
        self.taskTransitionType()
    }

    /// タイトルの適用
    ///
    /// - Parameter title: タイトル
    func applyTitle(_ title: String?) {
        self.taskModel.title = title
    }

    /// 内容の適用
    ///
    /// - Parameter contents: 内容
    func applyContents(_ contents: String?) {
        self.taskModel.contents = contents
    }

    /// 期日の適用
    ///
    /// - Parameter date: 期日
    func applyLimitDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = Const.dateFormat

        self.taskModel.date = dateFormatter.string(from: date)
    }

    /// タスクを追加するかどうか
    func isAddTaskObject() {
        if let title = self.taskModel.title,
           let contents = self.taskModel.contents,
           self.taskModel.date.isEmpty ||
            title.isEmpty ||
            contents.isEmpty {
            self.view?.showAlert("エラー",
                                 "タイトルか内容、期日が未入力です。\n入力してください。")
        } else {

            switch self.searchService?.fetchTransitionType() {
            case .newTask: self.addTaskObject()
            case .editTask: self.view?.didAddTaskList(self.settingService?.updateTaskList(self.taskModel) ?? false)
            case .none: break
            }
        }
    }
}
