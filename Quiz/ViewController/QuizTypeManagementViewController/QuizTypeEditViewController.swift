//
//  QuizTypeEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/04.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


/// クイズのカテゴリのVC
final class QuizTypeEditViewController: UIViewController {
    
    // MARK: Properties
    
    private var realm: Realm?
    private let config = Realm.Configuration(schemaVersion: 1)
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    /// クイズのカテゴリのID
    private var typeid: String?
    
    private var filter: QuizCategoryModel?
    
    /// クイズのカテゴリのビュー
    lazy var quizTypeEditView: QuizTypeEditView = {
        let view: QuizTypeEditView = QuizTypeEditView(frame: frame_Size(self), style: .grouped, mode: self.mode)
        
        if self.mode != .add {
            view.typeTextField.text = filter?.quizTypeTitle
        } else if self.mode == .detail {
            view.typeTextField.isEnabled = false
        }
        return view
    }()
    
    
    
    // MARK: Init
    
    convenience init(typeid: String?, mode: ModeEnum){
        self.init()
        self.mode = mode
        
        do {
              realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
          } catch {
              AlertManager().alertAction( self,
                                         title: nil,
                                         message: R.string.error.errorMessage,
                                         handler: { _ in
                  return
              })
              return
          }
          
        
        if let _typeid = typeid {
            filter = self.realm?.objects(QuizCategoryModel.self).filter("id == '\(String(describing: _typeid))'").first!
        }
    }
    
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: config)
        
        view.backgroundColor = R.color.cellWhite
        
        if mode != .detail {
            navigationItemAction()
        }
        
        view.addSubview(quizTypeEditView)
    }
    
    
    
    
    // MARK: NavigationItem Func
    
    override func navigationItemAction() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    override func rightButtonAction(){
        realmAction()
    }
    
    
    
    // MARK: Realm Func
    
    private func realmAction() {
        
        if mode == .add {
            addRealm()
            AlertManager().alertAction( self, title: nil, message: "問題を作成しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        } else if mode == .edit {
            updateRealm()
            AlertManager().alertAction( self, title: nil, message: "問題を更新しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        }
        
        
        
        NotificationCenter.default.post(name: Notification.Name(R.notification.quizTypeUpdate), object: nil)
    }
    
    
    /// Realmに新規追加
    private func addRealm(){
        QuizCategoryModel.addQuizCategoryModel(self, categorytitle: quizTypeEditView.typeTextField.text!)
        
    }
    
    
    /// アップデート
    private func updateRealm() {
        
        QuizCategoryModel.updateQuizCategoryModel(self, id: filter!.id, createTime: filter?.createTime, categorytitle: quizTypeEditView.typeTextField.text!)
        
        
    }
}
