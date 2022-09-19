//
//  MainViewController.swift
//  TimeBankXcode
//
//  Created by 김담인 on 2022/01/21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainViewNameLabel: UILabel!
    @IBOutlet weak var mainViewCategoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainViewNameLabel.text = tableViewCellArray[0].name
        switch tableViewCellArray[0].category {
        case .undefined:
            mainViewCategoryLabel.text = "지정x"
        case .produce:
            mainViewCategoryLabel.text = "생산"
        case .essential:
            mainViewCategoryLabel.text = "필수"
        case .consumption:
            mainViewCategoryLabel.text = "소비"
        default:
            return
        }
        
    }

}

