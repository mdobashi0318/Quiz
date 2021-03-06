//
//  HistoryView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import LineGraphView

final class HistoryView: UIView {

    // MARK: Properties

    private let screenWidth = UIScreen.main.bounds.width

    private var historyModel: [HistoryModel] = []

    private var trueCounts: [Int]!

    private lazy var totalsTable: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private lazy var lineGraphView: LineGraphView = {
        let view = LineGraphView(graphHeight: 290, values: trueCounts,
                                 lineOptions: .init(strokeWidth: 3,
                                                    strokeColor: R.color.rubyred() ?? .red),
                                 lineAnimationOptions: .init(isAnime: true, duration: Double(trueCounts.count) / 10)
        )

        view.backgroundColor = UIColor.changeAppearnceColor(light: .white, dark: .darkGray)
        view.valueLabelOption?.labelBackgroundColor = UIColor.changeAppearnceColor(light: .white, dark: .darkGray)
        view.ruledLine(lineWidth: screenWidth * 0.9)

        return view
    }()

    // MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.beige()
    }

    convenience init(frame: CGRect, historyModel model: [HistoryModel]) {
        self.init(frame: frame)
        historyModel = model
        trueCounts = [Int]()

        historyModel.forEach {
            let count = Int($0.quizTrueCount) ?? 0
            trueCounts.append(Int(count))
        }
        viewLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewLoad

    private func viewLoad() {
        addSubview(lineGraphView)
        addSubview(totalsTable)

        setConstraint()
    }

    /// 制約を付ける
    private func setConstraint() {
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lineGraphView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineGraphView.widthAnchor.constraint(equalToConstant: screenWidth * 0.9).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        totalsTable.translatesAutoresizingMaskIntoConstraints = false
        totalsTable.topAnchor.constraint(equalTo: lineGraphView.bottomAnchor, constant: 10).isActive = true
        totalsTable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalsTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        totalsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }

    /// lineGraphViewのアニメーションを呼ぶ
    func lineAnimetion() {
        lineGraphView.setLineGraph()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HistoryView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let historyCell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryCell else {
            return UITableViewCell()
        }

        historyCell.setValue(date: historyModel[indexPath.row].date,
                             count: historyModel[indexPath.row].quizTrueCount
        )
        return historyCell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }

}
