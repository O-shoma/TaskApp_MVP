//
//  SearchServiceProtocols.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

protocol SearchServiceProtocol: AnyObject {
    func applySearchTaskId(_ taskId: Int)
    func applyTransitionType(_ transitionType: TransitionType)
    func fetchSearchTaskId() -> Int
    func fetchTransitionType() -> TransitionType
    func initializeSearchTaskId()
    func initializeTransitionType()
}
