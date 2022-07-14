//
//  InputTaskViewController.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/08.
//

import UIKit

final class InputTaskViewController: UIViewController {
    var presenter: InputTaskInputPresenterProtocol?
    
    // IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentsLabel: UILabel!
    @IBOutlet private weak var limitLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentsTextView: UITextView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var registButton: UIButton!

    // private

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = InputTaskPresenter(view: self,
                                            settingService: SettingService.sharedInstance,
                                            searchService: SearchService.sharedInstance)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.presenter?.viewWillAppear()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - IBAction

    /// 期日の取得
    ///
    /// - Parameter sender: UIDatePicker
    @IBAction func fetchLimitDate(_ sender: UIDatePicker) {
        self.presenter?.applyLimitDate(sender.date)
    }

    /// 登録ボタン押下時
    ///
    /// - Parameter sender: UIButton
    @IBAction private func tappedRegistButton(_ sender: UIButton) {
        self.presenter?.isAddTaskObject()
    }

    // MARK: - Private Methods

    /// 一つ前の画面に遷移
     private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - InputTaskOutputPresenterProtocol

extension InputTaskViewController: InputTaskOutputPresenterProtocol {

    /// デザインの適用
    func applyDesign() {
        self.titleLabel.text = "タイトル"
        self.contentsLabel.text = "内容"
        self.limitLabel.text = "期日"
    }

    /// 設定の適用
    ///
    /// - Parameters:
    ///   - title: タイトル文言
    ///   - contents: 内容の文章
    ///   - limitDate: 期日
    func applySetting(_ title: String, _ contents: String, limitDate: Date) {
        self.titleTextField.text = title
        self.contentsTextView.text = contents
        self.datePicker.date = limitDate
        self.registButton.setTitle("更新", for: .normal)
    }

    /// タスク追加後
    ///
    /// - Parameter isAdd: 成功/失敗
    func didAddTaskList(_ isAdd: Bool) {
        isAdd ? self.popViewController() : print("✌️失敗")
    }



    /// アラートの表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .default) { [weak self] action in
            guard let self = self else { return }

            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(okButton)

        present(alert,
                animated: true,
                completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension InputTaskViewController: UITextFieldDelegate {

    /// Returenキー押下時
    ///
    /// - Parameter textField: UITextField
    /// - Returns: Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.presenter?.applyTitle(textField.text)

        return true
    }

    /// 編集終了後
    ///
    /// - Parameter textField: UITextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.presenter?.applyTitle(textField.text)
    }
}

// MARK: - UITextViewDelegate

extension InputTaskViewController: UITextViewDelegate {


    /// 編集終了後
    ///
    /// - Parameter textView: UITextView
    /// - Returns: Bool
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.presenter?.applyContents(textView.text)

        return true
    }
}

