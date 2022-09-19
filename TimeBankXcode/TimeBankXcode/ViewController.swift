//
//  ViewController.swift
//  tableCellCreation
//
//  Created by 김담인 on 2022/02/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeClock: UILabel!
    @IBOutlet weak var editLabel: UIButton!
    
    let defaults = UserDefaults.standard
    let currentDate = Date()
    var savedDate = Date()
    var cellNums = 0

    //메인 화면의 현재 시간 표시를 위한 시간 형식
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    //cellArray의 consumedTime ( 00시 ~ 00시)를 위한 시간 형식
    let timeFormat: DateFormatter = {
        let timeFormat = DateFormatter()
        timeFormat.timeZone = .current
        timeFormat.dateFormat = "HH"
        return timeFormat
    }()
    
    let dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = .current
        dateFormat.dateFormat = "MM월 dd일"
        return dateFormat
    }()
    
    func hoursGap(fromDate: Date, toDate: Date) -> Int? {
            return Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour
        }
    
    let calendar = NSCalendar.current
    lazy var tomorow = calendar.date(byAdding: .day, value: 1, to: Date())!
    lazy var midnight = calendar.startOfDay(for: tomorow)
    lazy var components = calendar.dateComponents([.hour, .minute], from: Date(), to: midnight)
    lazy var hoursUntilMidnight = components.hour!
    lazy var minutesUntilMidnight = components.minute!
   
    let modelTime = TimeModel()
    var newArray: [Default] = []
   
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "ViewModelTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "defaultCell")
        
        
//        let currentTimeString = formatter.string(from: currentDate)
        // 남은 시간을 표시
        timeClock.text = "\(hoursUntilMidnight)시간 \(minutesUntilMidnight)분"
        
        
        //테스트를 위해 시간차를 현재시간과 30시간 후로 설정
//        let thirtyHoursAfter = Date(timeIntervalSinceNow: 108000)
//        let eightHoursAfter = Date(timeIntervalSinceNow: 28800)
    
        // object초기화를 위한 key-value제거
        defaults.removeObject(forKey: "Date")
        
        // Date키에 값이 있을때
        if defaults.object(forKey: "Date") != nil {
            //저장된 Date를 savedDate에 넣고
            savedDate = defaults.object(forKey: "Date") as! Date
            //이전 slot들을 load하기전 newArray에 새로 만들어진 slot들을 넣어두고 load 실행
            newArray = modelTime.arrayTimeSlot
            modelTime.load()
            //현재 시간과 저장된 이전 시간 차를 구함
            var newHoursGap = hoursGap(fromDate: savedDate, toDate: Date()) ?? 0
            // 시간차가 0보다 클때 즉, 같은 시간이 아닐때 for문실행
            if newHoursGap > 0{
                newHoursGap -= 1
                // 시간차만큼 새로 생성된 셀을 arrayTimeSlot에 추가해주기 위해
                // 기존 배열 역순 -> append로 추가 -> 다시 배열 역순으로 앞부분에 셀을 추가 해줌
                for i in 0...newHoursGap {
                    modelTime.arrayTimeSlot.reversed()
                    modelTime.arrayTimeSlot.append(newArray[i])
                    modelTime.arrayTimeSlot.reversed()
                }
            }
        }
        // 현재 날짜 표시 for 날짜별 섹션 헤더
//        let dateString = dateFormat.string(from: currentDate)
      
        
        // currentDate를 "Date"키에 대입
       defaults.set(Date(), forKey: "Date")
    

    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillApear")
        modelTime.load()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    
    
    
    
    //테이블뷰 섹션을 날짜별로 구현예정
    func numberOfSections(in tableView: UITableView) -> Int {
//        var sectionNums = modelTime.arrayTimeSlot.count / 24 + 1
//        print("numberOfSections \(sectionNums)")
        return modelTime.arrayTimeSlot.count

    }
    
//    var headerTitle = "Today"
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//           return headerTitle
//      }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeInfo = modelTime.arrayTimeSlot[indexPath.section]
//        let timeInfo = modelTime.arrayTimeSlot[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! ViewModelTableViewCell
        cell.layer.cornerRadius = 15
        
        //테이블뷰 셀별 소비 시간양 표시(1시간)
        cell.consumedTimeLabel.text = "-\(timeInfo.consumedTime)시간"
        cell.consumedTimeLabel.textColor = .red
        
        //테이블뷰 셀 카테고리 이미지 표시
        switch timeInfo.category.self {
        case .undefined:
            cell.categoryImage.image = UIImage(named: "dollar")
        case .productive:
            cell.categoryImage.image = UIImage(named: "productivity")
        case .consumption:
            cell.categoryImage.image = UIImage(named: "wasteTime")
        case .essential:
            cell.categoryImage.image = UIImage(named: "essential")
        }
        
        //테이블뷰 셀 제목 표시
        if indexPath.row == 23 {
            cell.titleLabel.text = "오늘도 수고하셨습니다!"
        }else {
            cell.titleLabel.text = timeInfo.title
        }
        //테이블뷰 셀별 소비기간 표시
        cell.dateLabel.text = timeInfo.date
        
        //isMultiSelectMode가 true일때는 accessoryType인 .none false일때는 disclousureIndicator
        if isMultiSelectMode == true {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    var selectedIndex = 0
    var selectedIndexs: [Int] = []
    
    var isMultiSelectMode: Bool = false
    
    var isIndexUsed: Bool = false
    

    @IBAction func touchEdit(_ sender: Any) {
        isMultiSelectMode.toggle()
        if isMultiSelectMode == true {
            editLabel.setTitleColor(.red, for: .normal)
//            editLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        }else{
            editLabel.setTitleColor(.black, for: .normal)
        }
        selectedIndexs.removeAll()
        self.tableView.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isMultiSelectMode
    }
    
    @IBAction func touchDone(_ sender: Any) {
        if isMultiSelectMode == true {
            self.performSegue(withIdentifier: "toEdit", sender: nil)
            isIndexUsed = true
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.section
        let cell = tableView.cellForRow(at: indexPath)
        
        //selectedIndexs 배열이 이미 사용되었으면 기존 값 제거
        if  isIndexUsed == true {
            selectedIndexs.removeAll()
            isIndexUsed = false
        }
        
        if isMultiSelectMode == true {
        cell?.accessoryType = cell!.accessoryType == .checkmark ? .none : .checkmark
            if  cell?.accessoryType == .checkmark {
                selectedIndexs.append(selectedIndex)
            }else  {
                let modifiedSelectedIndex = selectedIndexs.filter { $0 != selectedIndex }
                selectedIndexs = modifiedSelectedIndex
            }
            
        }else {
            self.performSegue(withIdentifier: "toEdit", sender: nil)
        }
         
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        segue.source
        let vcEdit = segue.destination as! EditViewController

        vcEdit.isEditMode = isMultiSelectMode
        vcEdit.modelTime = modelTime
        // multiSelect모드일때 editView의 multiItems에 넣어줌
        if vcEdit.isEditMode == true {
            vcEdit.editList = selectedIndexs
            vcEdit.multiItems.removeAll()
            for i in selectedIndexs{
                vcEdit.multiItems.append(modelTime.arrayTimeSlot[i])
            }
            //editView Category선택 코드를 위해 oneItem에 값 넣어주기
            vcEdit.oneItem = modelTime.arrayTimeSlot[selectedIndex]
        }else {
            modelTime.selectedIndex = selectedIndex
            // EditViewController에 있는 modelTime에 ViewController를 복사
            vcEdit.modelTime = modelTime
            vcEdit.oneItem = modelTime.arrayTimeSlot[selectedIndex] 
            
        }
    }
    
    @IBAction func analystButton(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(identifier: "AnalystViewController") {
             // 여기서 navigationController 이게 맨 앞에 있는 navigation임
             self.navigationController?.pushViewController(controller, animated: true)
           }
    }
    
}

