//
//  Constant.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/07/08.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - RealmConfig

/// Realmのスキームバージョン
let realmConfig: UInt64 = 1


// MARK: - COLORS


let Morganite:UIColor = UIColor.changColor(light: UIColor.rgba(red: 205, green: 192, blue: 199, alpha: 1), dark: .black)
let Dawnpink:UIColor = UIColor.changColor(light: UIColor.rgba(red: 208, green: 184, blue: 187, alpha: 1), dark: .black)
let Geranium:UIColor = UIColor.changColor(light: UIColor.rgba(red: 218, green: 61, blue: 92, alpha: 1), dark: .black)
let Rubyred:UIColor = UIColor.changColor(light: UIColor.rgba(red: 207, green: 53, blue: 93, alpha: 1), dark: .black)
let Beige: UIColor = UIColor.changColor(light: UIColor.rgba(red: 245, green: 245, blue: 220, alpha: 1), dark: .black)
let Rose:UIColor = UIColor.changColor(light: UIColor.rgba(red: 244, green: 80, blue: 109, alpha: 1), dark: .black)



// MARK: - STRINGS

/// QuizManagementViewControllerの更新
let QuizUpdate: String = "quizUpdate"

/// QuizMainViewControllerの更新
let HistoryUpdate: String = "historyUpdate"

/// データベース内のデータ全削除
let AllDelete: String = "allDelete"
