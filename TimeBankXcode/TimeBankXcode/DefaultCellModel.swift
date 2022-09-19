//
//  DefaultCellModel.swift
//  tableCellCreation
//
//  Created by 김담인 on 2022/02/06.
//

import Foundation

struct Default: Codable {
    var title: String
    //소비되었을 때 시간
    var date: String
    //소비한 시간의 양
    var consumedTime: Int
    //카테고리
    var category: category
    enum category:  Codable{
    case undefined, productive, consumption, essential
    }
    var memo: String
//    var checked: Bool
}


class TimeModel {
    let defaults = UserDefaults.standard
    let currentDate = Date()
    var savedDate = Date()
    
    let timeFormat: DateFormatter = {
        let timeFormat = DateFormatter()
        timeFormat.timeZone = .current
        timeFormat.dateFormat = "HH"
        return timeFormat
    }()
    
    func perHour (hours index: Int, since sinceDate: Date) -> String {
        let secondsForAnHour = Double(3600*(index))
        let dateAfterAnHour = Date(timeInterval: secondsForAnHour, since: sinceDate)
        let anHourString = timeFormat.string(from: dateAfterAnHour) // Datee to String(Formatting "HH")
        
        return anHourString
    }
    
    func hoursGap(fromDate: Date, toDate: Date) -> Int? {
            return Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour
        }
    
    var selectedIndex = 0 // 선택된 인덱스.
    var arrayTimeSlot: [Default] = []
    var doubleTimeSlot: [[Default]] = [[]]
    var dicTimeSlot : [String : Default] = [:]
    
     init() {
         //테스트를 위한 userDefault 셀 초기화
         defaults.removeObject(forKey: "Cells")
         
        let currtentHourString = self.timeFormat.string(from: Date()) //현재 시간을 "HH" 형식으로 포맷
         let currentHourInt = Double(currtentHourString) ?? 0 //"HH"을 Double로 변환
         print("currentHourInt\(currentHourInt)")
         let sinceDate = Date(timeInterval: -3600*currentHourInt, since: Date())
         //현재 Date에서 현재 시 만큼 뒤로돌려 00시를 기준시간으로 만듦
//        let thirtyHoursAfter = Date(timeIntervalSinceNow: 108000)
//        let eightHoursAfter = Date(timeIntervalSinceNow: 28800)


         let slotNums = hoursGap(fromDate: sinceDate, toDate: Date()) ?? 0
         print("slotNums \(slotNums)")
         arrayTimeSlot = Array(0...slotNums).map { index in
             Default(title: "제목\(slotNums - index)", date: "\(perHour(hours: slotNums - index, since: sinceDate))시 ~ \(perHour(hours: slotNums - index+1, since: sinceDate))시", consumedTime: 1, category: Default.category.undefined, memo: "어디에 시간을 사용했는지 기록해주세요")
         }
         
    }
    
    
    func save(slot: [Default]) {
        defaults.set(try? PropertyListEncoder().encode(slot), forKey:"Cells")
        print("userDefault-Save")
    }
    func load() {
         
        if defaults.object(forKey: "Cells") != nil {
            if let saved = defaults.value(forKey:"Cells") as? Data {
                arrayTimeSlot = try! PropertyListDecoder().decode([Default].self, from: saved)
            }
            print("userDefault-Load")
        }

    }
}
