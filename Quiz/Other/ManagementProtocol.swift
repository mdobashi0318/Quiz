//
//  ManagementProtocol.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/06.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

protocol ManagementProtocol {

    /// 配列にRealmで保存したデータを追加する
    func modelAppend()

    /// 詳細を開く
    func detailAction(indexPath: IndexPath)

    /// 編集画面を開く
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController)

    /// 削除
    func deleteAction(indexPath: IndexPath)
}
