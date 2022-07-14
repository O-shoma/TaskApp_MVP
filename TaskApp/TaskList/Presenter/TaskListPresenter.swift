//
//  TaskListPresenter.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/04.
//

import Foundation

final class TaskListPresenter {
    var view: TaskListOutputPresenterProtocol?

    // private
    private var settingService: SettingServiceProtocol?
    private var searchService: SearchServiceProtocol?
    private var contents: [TaskListContents] = []

    init(view: TaskListOutputPresenterProtocol,
         settingService: SettingServiceProtocol,
         searchService: SearchServiceProtocol) {
        self.view = view
        self.settingService = settingService
        self.searchService = searchService
    }
}

extension TaskListPresenter: TaskListInputPresenterProtocol {

    /// viewWillAppear時
    func viewWillAppear() {
        self.view?.applyDesign()
    }

    /// デザインの適用後
    func didApplyDesign() {
        guard let taskList = self.settingService?.fetchTaskList() else { return }

        self.contents.removeAll()

        taskList.enumerated().forEach {
            self.contents.append(TaskListContents(taskId: $0.element.id,
                                                  title: $0.element.title!,
                                                  taskLimit: $0.element.date,
                                                  category: $0.element.contents!))
        }

        self.view?.reloadData(self.contents)
    }

    /// 右スワイプ時
    ///
    /// - Parameter rowAt: セル番号
    func rightSwipeTableView(_ rowAt: Int) {
        guard let isDelete = self.settingService?.deleteTask(self.contents[rowAt].taskId) else { return }

        isDelete ? self.didApplyDesign() : self.view?.didFailedTaskDelete()
    }

    /// 遷移方法の適用
    ///
    /// - Parameter transitionType: TransitionType
    func applyTransitionType(_ transitionType: TransitionType) {
        self.searchService?.applyTransitionType(transitionType)

        self.view?.pushInputTaskViewController()
    }

    /// セル押下時
    ///
    /// - Parameter rowAt: セル番号
    func tappedCell(_ rowAt: Int) {
        self.searchService?.applySearchTaskId(self.contents[rowAt].taskId)

        self.applyTransitionType(.editTask)
    }
}
