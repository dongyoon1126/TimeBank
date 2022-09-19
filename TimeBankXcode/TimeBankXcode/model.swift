//
//  model.swift
//  TimeBankXcode
//
//  Created by 김동윤 on 2022/02/22.
//

import Foundation

struct tableViewCell {
    var name: String
    var date: Int
    var consumptionTime: Int
    var category: category
    
    enum category {
    case undefined, produce, consumption, essential
    }
}

var tableViewCellArray: [tableViewCell] = [
    tableViewCell(name: "제목", date: 20220212, consumptionTime: -1, category: tableViewCell.category.undefined)
]
