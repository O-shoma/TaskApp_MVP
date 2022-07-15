//
//  InputTaskProtocols.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import Foundation

// MARK: - Presenter

protocol InputTaskInputPresenterProtocol: AnyObject {
    var view: InputTaskOutputPresenterProtocol? { get set }

    func viewWillAppear()
    func applyTitle(_ title: String?)
    func applyContents(_ contents: String?)
    func applyLimitDate(_ date: Date)
    func isAddTaskObject()
}

protocol InputTaskOutputPresenterProtocol: AnyObject {
    var presenter: InputTaskInputPresenterProtocol? { get set }

    func applyDesign()
    func applySetting(_ title: String,
                      _ contents: String,
                      limitDate: Date)
    func didAddTaskList(_ isAdd: Bool)
    func showAlert(_ title: String, _ message: String)
}

