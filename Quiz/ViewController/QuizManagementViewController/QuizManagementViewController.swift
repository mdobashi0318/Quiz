//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

/// Realmで登録したクイズの確認、編集、削除を行うためのViewController
final class QuizManagementViewController: UITableViewController {
    
    // MARK: Properties
    
    /// クイズのリストを格納する
    private var quizModel: Results<QuizModel>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUPTableView()
        setBarButtonItem()
        setNotificationCenter()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelAppend()
        debugPrint(object: quizModel)
    }
    
    
    
    
    // MARK: Private Func
    
    /// テーブルビューをセットする
    private func setUPTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(QuizListCell.self, forCellReuseIdentifier: "quizCell")
    }
    
    
    
    
    // MARK: Navigation Action
    
    /// クイズを作成するモーダルを表示
    override func rightButtonAction() {
        presentModalView(QuizEditViewController(mode: .add))
    }
    
    
    
    /// デバッグ用でデータベースを削除する
    @objc override func leftButtonAction(){
        
        AlertManager().alertAction(self,
                                   title: "データベースの削除",
                                   message: "作成した問題や履歴を全件削除します",
                                   handler1: { [weak self]  (action) in
                                    RealmManager().allModelDelete(self!) {
                                        self?.modelAppend()
                                        self?.tabBarController?.selectedIndex = 0
                                        NotificationCenter.default.post(name: Notification.Name(R.notification.AllDelete), object: nil)
                                    }
        }){ (action) in return }
        
    }
    
    
    
    
    // MARK: Other func
    
    
    private func setNotificationCenter() {
        /// quizModelをアップデート
        NotificationCenter.default.addObserver(self, selector: #selector(quizUpdate(notification:)), name: NSNotification.Name(rawValue: R.notification.QuizUpdate), object: nil)
        
    }
    
    /// クイズを更新する
    @objc func quizUpdate(notification: Notification) {
        modelAppend()
    }
    
}






/// UITableViewDelegate, UITableViewDataSourceの必須メソッド追加
extension QuizManagementViewController {
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    /// 一つのセクションに表示する行数を設定
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示するため１を返す
    /// - quizModelの件数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizModel?.count == 0 {
            return 1
        }
        return quizModel!.count
    }
    
    
    /// 表示するセルを設定する
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示する
    /// - クイズのタイトルを表示する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quizModel?.count == 0 {
            /// "まだクイズが作成されていません"と表示する"
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "まだクイズが作成されていません"
            cell.selectionStyle = .none
            return cell
        }
        
        /// モデルに格納されたクイズのタイトルを表示する
        let quizCell: QuizListCell = tableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizListCell
        quizCell.quizNoText = "問題\(indexPath.row + 1)"
        quizCell.quizTitleText = (quizModel?[indexPath.row].quizTitle)!
        quizCell.quizTypeText = quizModel?[indexPath.row].quizTypeModel?.quizTypeTitle
        quizCell.displaySwitch = (quizModel?[indexPath.row].displayFlag)
        
        return quizCell
    }
    
    
    
    /// 選択したクイズの詳細に遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailAction(indexPath: indexPath)
    }
    
    
    
    /// クイズが0件の時はセルをえ選択させない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if quizModel?.count == 0 {
            return nil
        }
        
        return indexPath
    }
    
    
    
    
    
    /// スワイプしたセルに「編集」「削除」の項目を表示する
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        /// 編集
        let edit = UITableViewRowAction(style: .normal, title: "編集") { [weak self]
            (action, indexPath) in
            
            self?.editAction(self!,
                             editViewController: QuizEditViewController(quzi_id: (self?.quizModel?[indexPath.row].id)!,
                                                                         createTime: (self?.quizModel?[indexPath.row].createTime)!,
                                                                        mode: .edit)
            )
        }
        edit.backgroundColor = UIColor.orange
        
        
        /// 削除
        let del = UITableViewRowAction(style: .destructive, title: "削除") { [weak self]
            (action, indexPath) in
            
            self?.deleteAction(indexPath: indexPath)
        }
        
        return [edit, del]
    }
    
    
    /// クイズが0件の時はセルのスワイプをしない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if quizModel?.count == 0 {
            return false
        }
        return true
    }
    
}






/// ManagementProtocolを拡張
extension QuizManagementViewController: ManagementProtocol {

    // MARK: QuizManagementViewDelegate Func
    
     /// 配列にRealmで保存したデータを追加する
     func modelAppend() {
         quizModel = QuizModel.allFindQuiz(self, isSort: true)
     }
    
    
    /// 指定したクイズの詳細を開く
    func detailAction(indexPath: IndexPath) {
        pushTransition(QuizEditViewController(quzi_id: (quizModel?[indexPath.row].id)!,
                                              createTime: (quizModel?[indexPath.row].createTime)!,
                                              mode: ModeEnum.detail)
        )
    }
    
    
    /// 指定したクイズの編集画面を開く
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController) {
        presentModalView(editVC)
    }
    

    
    /// 指定したクイズの削除
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(self, message: "削除しますか?", handler1: { [weak self] action in
            QuizModel.deleteQuiz(self!,
                                 id: (self?.quizModel?[indexPath.row].id)!,
                                 createTime: self?.quizModel?[indexPath.row].createTime
            )
            self?.modelAppend()
            
            }) {_ -> Void in}
        
    }
    
 
    
}
