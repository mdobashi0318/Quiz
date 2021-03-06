//
//  QuizTypeModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import RealmSwift

class QuizCategoryModel: Object {

    // MARK: Properties

    /// カテゴリのID
    @objc dynamic var id: String = ""

    /// カテゴリのタイトル
    @objc dynamic var quizTypeTitle: String = ""

    /// カテゴリが選択されているかのフラグ
    @objc dynamic var isSelect: String = ""

    /// クイズのカテゴリの作成日時
    @objc dynamic var createTime: String?

    // createTimeをプライマリキーに設定
    override static func primaryKey() -> String? {
        "createTime"
    }

    /// カテゴリの全件検索
    class func findAllQuizCategoryModel(_ vc: UIViewController) -> [QuizCategoryModel] {
        guard let realm = RealmManager.realm else { return [] }
        var returnModel = [QuizCategoryModel]()
        realm.objects(QuizCategoryModel.self).forEach { returnModel.append($0) }
        return returnModel
    }

    /// カテゴリの検索
    class func findQuizCategoryModel(_ vc: UIViewController, id: String, createTime: String?) -> QuizCategoryModel? {
        guard let realm = RealmManager.realm else { return nil }

        if let _createTime = createTime {
            return (realm.objects(QuizCategoryModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return (realm.objects(QuizCategoryModel.self).filter("id == '\(String(describing: id))'").first)
        }
    }

    /// 選択されているカテゴリの検索
    class func findSelectQuizCategoryModel(_ vc: UIViewController) -> QuizCategoryModel? {
        guard let realm = RealmManager.realm else { return nil }
        return (realm.objects(QuizCategoryModel.self).filter("isSelect == '1'").first)
    }

    /// カテゴリを追加する
    class func addQuizCategoryModel(_ vc: UIViewController, categorytitle: String) {

        guard let realm = RealmManager.realm else { return }
        let quizCategoryModel = QuizCategoryModel()

        quizCategoryModel.id = String(realm.objects(QuizCategoryModel.self).count + 1)
        quizCategoryModel.isSelect = "0"
        quizCategoryModel.quizTypeTitle = categorytitle
        quizCategoryModel.createTime = Format().stringFromDate(date: Date(), addSec: true)

        do {
            try realm.write {
                realm.add(quizCategoryModel)
            }

            NotificationCenter.default.post(name: Notification.Name(R.string.notifications.quizUpdate()), object: nil)
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }

    }

    /// カテゴリを更新する
    class func updateQuizCategoryModel(_ vc: UIViewController, id: String, createTime: String?, categorytitle: String) {
        guard let realm = RealmManager.realm else { return }

        if let quizCategoryModel = QuizCategoryModel.findQuizCategoryModel(vc, id: id, createTime: createTime) {
            do {
                try realm.write {
                    quizCategoryModel.quizTypeTitle = categorytitle

                    /// createTimeを追加する前のバージョンで作ったクイズの場合はcreateTimeを追加する
                    if quizCategoryModel.createTime == nil {
                        quizCategoryModel.createTime = Format().stringFromDate(date: Date(), addSec: true)
                    }

                }
            } catch {
                AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
            }

        } else {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }

    }

    /// 選択されたカテゴリを更新する
    class func updateisSelect(_ vc: UIViewController, selectCategory: QuizCategoryModel) {

        guard let realm = RealmManager.realm else { return }
        let alreadySelectedCategory = QuizCategoryModel.findSelectQuizCategoryModel(vc)
        let selectedCategory = QuizCategoryModel.findQuizCategoryModel(vc, id: selectCategory.id, createTime: selectCategory.createTime)

        do {
            try realm.write {
                alreadySelectedCategory?.isSelect = "0"
                selectedCategory?.isSelect = "1"
            }
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }
    }

    /// カテゴリの削除
    func deleteQuizCategoryModel(_ vc: UIViewController, id: String, createTime: String, completeHandler: () -> Void) {
        guard let realm = RealmManager.realm else { return }

        guard let quizCategoryModel = QuizCategoryModel.findQuizCategoryModel(vc, id: id, createTime: createTime) else {
            AlertManager().alertAction(vc,
                                       message: R.string.errors.errorMessage(),
                                       didTapCloseButton: nil)
            return
        }

        do {
            try realm.write {
                realm.delete(quizCategoryModel)

                completeHandler()
            }
        } catch {
            AlertManager().alertAction(vc,
                                       message: R.string.errors.errorMessage(),
                                       didTapCloseButton: nil)
        }
    }

}
