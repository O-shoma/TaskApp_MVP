//
//  DefaultTableViewCell.swift
//  TaskApp
//
//  Created by Kakeshin on 2022/05/05.
//

import UIKit
import Foundation

final class DefaultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var taskLimit: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - Public Methods

    /// セットアップ
    ///
    /// - Parameters:
    ///   - title: タイトル文言
    ///   - detail: 詳細文言
    func setUp(title: String,
               taskLimit: String) {
        self.titleLabel.text = title
        self.taskLimit.text = taskLimit
    }
}
