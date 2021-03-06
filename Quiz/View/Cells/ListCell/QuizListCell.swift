//
//  QuizCreateView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

// MARK: - QuizListCell

/// クイズリストセル
final class QuizListCell: UITableViewCell {

    /// Noラベル
    @IBOutlet private weak var quizNoLabel: UILabel!

    /// Noラベルの長さ
    @IBOutlet private weak var quizNoWidthConstraint: NSLayoutConstraint!

    /// クイズタイトルラベル
    @IBOutlet private weak var quizTitleLabel: UILabel!

    /// カテゴリラベル
    @IBOutlet private weak var quizTypeLable: UILabel!

    /// クイズタイトル、カテゴリラベル箇所stackViewの高さ
    @IBOutlet private weak var detailHeight: NSLayoutConstraint!

    /// 表示・非表示のフラグでセルの色を変更
    private var displaySwitch: String? {
        didSet {
            if displaySwitch == DisplayFlg.indicated.rawValue {
                self.backgroundColor = R.color.cellWhite()
            } else {
                self.backgroundColor = .lightGray
            }
        }

    }

    func setValue(row: Int, model: QuizModel?) {
        guard let _model = model else { return }
        quizNoLabel.text = "問題\(String(row + 1)):"
        quizNoLabel.sizeToFit()
        quizNoWidthConstraint.constant = quizNoLabel.frame.width
        quizTitleLabel.text = _model.quizTitle
        quizTypeLable.text = _model.quizTypeModel?.quizTypeTitle
        displaySwitch = _model.displayFlag

        quizTitleLabel.sizeToFit()
        quizTypeLable.sizeToFit()
        detailHeight.constant = quizTitleLabel.frame.height + quizTypeLable.frame.height
    }

}
