//
//  QuizModelTest.swift
//  QuizTests
//
//  Created by 土橋正晴 on 2020/04/19.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import Quiz



class QuizModelTest: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
        RealmManager().allDelete()
    }
    
    
    
    
    /// クイズの追加tテスト
    func test_addQuizModelTest() {
        
        let parameters: [String: Any] = [ParameterKey().title: "UnitTest",
                                         ParameterKey().correctAnswer: "correctAnswer",
                                         ParameterKey().incorrectAnswer1: "incorrectAnswer1",
                                         ParameterKey().incorrectAnswer2: "incorrectAnswer2",
                                         ParameterKey().incorrectAnswer3: "incorrectAnswer3",
                                         ParameterKey().displayFlag: "0",
                                         ParameterKey().quizType: ""
        ]
        
        QuizModel.addQuiz(UIViewController(), parameters: parameters)
        
        let quizModel = QuizModel.findQuiz(UIViewController(), quizid: "1", createTime: nil)
        
        XCTAssert(quizModel?.quizTitle == "UnitTest", "タイトルが違う")
        XCTAssert(quizModel?.trueAnswer == "correctAnswer", "正解が違う")
        XCTAssert(quizModel?.falseAnswer1 == "incorrectAnswer1", "不正解1が違う")
        XCTAssert(quizModel?.falseAnswer2 == "incorrectAnswer2", "不正解3が違う")
        XCTAssert(quizModel?.falseAnswer3 == "incorrectAnswer3", "不正解3が違う")
        XCTAssert(quizModel?.displayFlag == "0", "表示になっていない")
        XCTAssertNotNil(quizModel?.createTime, "createTimeがセットされていない")
        
    }
    
    
    /// クイズの編集テスト
    func test_updateQuizModelTest() {
        
        let addparameters: [String: Any] = [ParameterKey().title: "UnitTest",
                                            ParameterKey().correctAnswer: "correctAnswer",
                                            ParameterKey().incorrectAnswer1: "incorrectAnswer1",
                                            ParameterKey().incorrectAnswer2: "incorrectAnswer2",
                                            ParameterKey().incorrectAnswer3: "incorrectAnswer3",
                                            ParameterKey().displayFlag: "0",
                                            ParameterKey().quizType: ""
        ]
        
        QuizModel.addQuiz(UIViewController(), parameters: addparameters)
        let quizModel = QuizModel.findQuiz(UIViewController(), quizid: "1", createTime: nil)
        
        
        let updateparameters: [String: Any] = [ParameterKey().title: "updateUnitTest",
                                               ParameterKey().correctAnswer: "updatecorrectAnswer",
                                               ParameterKey().incorrectAnswer1: "updateincorrectAnswer1",
                                               ParameterKey().incorrectAnswer2: "updateincorrectAnswer2",
                                               ParameterKey().incorrectAnswer3: "updateincorrectAnswer3",
                                               ParameterKey().displayFlag: "0",
                                               ParameterKey().quizType: ""
        ]
        
        
        QuizModel.updateQuiz(UIViewController(), parameters: updateparameters,
                             id: quizModel!.id,
                             createTime: quizModel?.createTime
        )
        
        
        XCTAssert(quizModel?.quizTitle == "updateUnitTest", "タイトルが違う")
        XCTAssert(quizModel?.trueAnswer == "updatecorrectAnswer", "正解が違う")
        XCTAssert(quizModel?.falseAnswer1 == "updateincorrectAnswer1", "不正解1が違う")
        XCTAssert(quizModel?.falseAnswer2 == "updateincorrectAnswer2", "不正解2が違う")
        XCTAssert(quizModel?.falseAnswer3 == "updateincorrectAnswer3", "不正解3が違う")
        XCTAssert(quizModel?.displayFlag == "0", "表示になっていない")
        
    }
    
}
