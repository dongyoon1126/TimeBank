//
//  EditViewController.swift
//  TimeBankXcode
//
//  Created by 김동윤 on 2022/02/22.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var editViewSaveButton: UIBarButtonItem!
    
    //  tableviewcell
    @IBOutlet weak var editViewImageView: UIImageView!
    @IBOutlet weak var editViewCellName: UILabel!
    @IBOutlet weak var editViewCellTime: UILabel!
//  editview
//    제목
    @IBOutlet weak var editViewNameLabel: UILabel!
    @IBOutlet weak var editViewNameTextField: UITextField! { didSet {editViewNameTextField.delegate = self }}
//    소비 날짜
    @IBOutlet weak var editViewDateLabel: UILabel!
    @IBOutlet weak var editViewDateValue: UILabel!
//    소비 시간
    @IBOutlet weak var editViewTimeLabel: UILabel!
    @IBOutlet weak var editViewTimeValue: UILabel!
//    카테고리
    @IBOutlet weak var editVIewCategoryLabel: UILabel!
    @IBOutlet weak var editViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var memoUITextView: UITextView!
    
    var modelTime: TimeModel!
    
    var oneItem: Default!
    var multiItems: [Default]! = []
    var isEditMode: Bool = false
    var editList: [Int]! = []
    
    @IBOutlet weak var viewMiddle: UIView!
    
    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {

        views.forEach { v in
            v.layer.cornerRadius = 4
            v.layer.borderWidth = 0
        }
          
        
        
        //EditmMode모드인지 확인해서 true면 multiItems를 전달
        if isEditMode == true {
            editViewNameTextField.placeholder = multiItems[0].title
    //      상단 tableViewCell 뷰에 배열값 넣기
            editViewCellName.text = multiItems[0].title
            editViewCellTime.text = "\(multiItems[0].date)"
            
    //      eidtView 에 배열값 넣기
            editViewDateValue.text = "\(multiItems[0].date)"
            editViewTimeValue.text = "\(multiItems[0].consumedTime)"
            
            switch multiItems[0].category {
            case .undefined:
                editViewImageView.image = UIImage(named: "dollar")
            case .productive:
                editViewImageView.image = UIImage(named: "productivity")
            case .consumption:
                editViewImageView.image = UIImage(named: "wasteTime")
            case .essential:
                editViewImageView.image = UIImage(named: "essential")
           
            }
            
            memoUITextView.text = multiItems[0].memo
        
        //false이면 oneItem 값을 전달
        }else {
            editViewNameTextField.placeholder = oneItem.title

    //      상단 tableViewCell 뷰에 배열값 넣기
            editViewCellName.text = oneItem.title
            editViewCellTime.text = "\(oneItem.date)"
            
    //      eidtView 에 배열값 넣기
            editViewDateValue.text = "\(oneItem.date)"
            editViewTimeValue.text = "\(oneItem.consumedTime)"
                
            //상단 tableViewCell에 카테고리 이미지 넣기
            
            switch oneItem.category {
            case .undefined:
                editViewImageView.image = UIImage(named: "dollar")
            case .productive:
                editViewImageView.image = UIImage(named: "productivity")
            case .consumption:
                editViewImageView.image = UIImage(named: "wasteTime")
            case .essential:
                editViewImageView.image = UIImage(named: "essential")
           
            }
            
            memoUITextView.text = oneItem.memo

        }
    }
    
//  텍스트필드 키보드 내리기(엔터키 터치 시, 화면 터치 시)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editViewNameTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func editViewCategoryTapped(_ sender: Any) {
        //카테고리 선택값을 저장하기 위한 변수
        var selectedCategory = oneItem.category
        //카테고리 선택 값에 따라 사진 변경
        switch editViewSegmentedControl.selectedSegmentIndex{
        case 0:
            editViewImageView.image = UIImage(named: "productivity")
            selectedCategory = .productive
        case 1:
            editViewImageView.image = UIImage(named: "wasteTime")
            selectedCategory = .consumption
        case 2:
            editViewImageView.image = UIImage(named: "essential")
            selectedCategory = .essential
        default:
            editViewImageView.image = UIImage(named: "doubts-button")
        }
        
        if isEditMode == true {
            for i in 0...(multiItems.count-1) {
                multiItems[i].category = selectedCategory
            }
            
        }else {
            oneItem.category = selectedCategory
        }
        
//        
    }
    
    
    //Save 버튼
    @IBAction func editViewSaveButtonTapped(_ sender: Any) {
//        print("Save Button Tapped")
        
        
        if isEditMode == true {
            var titleText = ""
            if editViewNameTextField.text == "" {
                titleText = multiItems[0].title
            }else {
                titleText = editViewNameTextField.text!
            }
            
            for i in 0...(multiItems.count-1) {
                multiItems[i].title = titleText
                multiItems[i].category = multiItems[0].category
                multiItems[i].memo = memoUITextView.text
                modelTime.arrayTimeSlot[editList[i]] = multiItems[i]
            }
            
        }else {
            //textField의 값을 변경하지 않았을때 기존 텍스트 그대로 적용
            if editViewNameTextField.text == "" {
                oneItem.title = oneItem.title
            }else {
                oneItem.title = editViewNameTextField.text!
            }
            oneItem.memo = memoUITextView.text
            modelTime.arrayTimeSlot[modelTime.selectedIndex] = oneItem
        }

        //메인뷰로 다시 넘어갈때 modelTime classd의 arrayTimeSlot을 save함수를 통해 저장
        modelTime.save(slot: modelTime.arrayTimeSlot)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
