//
//  TaskListProtocols.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/04.
//

// MARK: - Presenter

protocol TaskListInputPresenterProtocol: AnyObject {
    var view: TaskListOutputPresenterProtocol? { get set }

    func viewWillAppear()
    func didApplyDesign()
    func rightSwipeTableView(_ rowAt: Int)
    func applyTransitionType(_ transitionType: TransitionType)
    func tappedCell(_ rowAt: Int)
}

protocol TaskListOutputPresenterProtocol: AnyObject {
    var presenter: TaskListInputPresenterProtocol? { get set }
    
    func applyDesign()
    func reloadData(_ contents: [TaskListContents])
    func pushInputTaskViewController()
    func didFailedTaskDelete()
}
