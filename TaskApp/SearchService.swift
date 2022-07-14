//
//  SearchService.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation

final class SearchService: NSObject {

    // Singleton
    static let sharedInstance = SearchService()

    private override init() {}

    private(set) var searchTaskId: Int?
    private(set) var transitionType: TransitionType?
}

// MARK: - SearchServiceProtocol

extension SearchService: SearchServiceProtocol {

    /// 検索用タスクIDの適用
    ///
    /// - Parameter taskId: タスクID
    func applySearchTaskId(_ taskId: Int) {
        self.searchTaskId = taskId
    }

    /// 遷移方法の適用
    ///
    /// - Parameter transitionType: TransitionType
    func applyTransitionType(_ transitionType: TransitionType) {
        self.transitionType = transitionType
    }

    /// 検索用タスクIDの取得
    ///
    /// - Returns: タスクID
    func fetchSearchTaskId() -> Int {
        guard let taskId = self.searchTaskId else {
            return 0
        }

        return taskId
    }

    /// 遷移方法の取得
    ///
    /// - Returns: TransitionType
    func fetchTransitionType() -> TransitionType {
        guard let transitionType = self.transitionType else {
            return .newTask
        }

        return transitionType
    }

    /// 検索用タスクIDの初期化
    func initializeSearchTaskId() {
        self.searchTaskId = nil
    }

    /// 遷移方法の初期化
    func initializeTransitionType() {
        self.transitionType = nil
    }
}
