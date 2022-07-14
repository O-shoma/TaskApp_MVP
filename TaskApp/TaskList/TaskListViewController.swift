//
//  TaskListViewController.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/04.
//

import UIKit

final class TaskListViewController: UIViewController {
    var presenter: TaskListInputPresenterProtocol?

    // IBOutlet
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "DefaultTableViewCell",
                                          bundle: nil),
                                    forCellReuseIdentifier: "defaultCell")
        }
    }

    // private
    private var titleWord: String = ""
    private var contents: [TaskListContents] = []
    

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = TaskListPresenter(view: self,
                                           settingService: SettingService.sharedInstance,
                                           searchService: SearchService.sharedInstance)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.presenter?.viewWillAppear()
    }

    // MARK: - IBAction

    /// 追加ボタン押下時
    ///
    /// - Parameter sender: UIBarButtonItem
    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        self.presenter?.applyTransitionType(.newTask)
    }

    // MARK: - Private Methods
}

// MARK: - TaskListOutputPresenterProtocol

extension TaskListViewController: TaskListOutputPresenterProtocol {

    /// デザインの適用
    func applyDesign() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.tappedAddButton(_:)))

        self.presenter?.didApplyDesign()
    }

    /// 設定の適用
    ///
    /// - Parameter contents: TaskListContents
    func reloadData(_ contents: [TaskListContents]) {
        self.contents = contents

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    /// タスク追加画面へ遷移
    func pushInputTaskViewController() {
        let vc = InputTaskViewController()

        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }

    /// タスク削除失敗時
    func didFailedTaskDelete() {
        print("✌️ タスクの削除に失敗しました。")
    }
}

// MARK: -  UITableViewDelegate, UITableViewDataSource

extension TaskListViewController:  UITableViewDelegate, UITableViewDataSource {

    /// セルの個数を設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: セクション数
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }


    /// セルの内容を設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: セクション情報およびセル内容情報
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! DefaultTableViewCell

        cell.setUp(title: self.contents[indexPath.row].title,
                   taskLimit: self.contents[indexPath.row].taskLimit)

        return cell
    }

    /// セルの高さを設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: セクション情報及びセル内容情報
    /// - Returns: セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    /// セル押下直後の設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: セクション情報及びセル番号情報
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.tappedCell(indexPath.row)
    }

    /// 右スワイプ時の処理を設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: セクション情報及びセル番号情報
    /// - Returns: スワイプじの処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "削除") { [weak self] (action, view, comletionHandler) in
            guard let self = self else { return }

            self.presenter?.rightSwipeTableView(indexPath.row)
            comletionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
