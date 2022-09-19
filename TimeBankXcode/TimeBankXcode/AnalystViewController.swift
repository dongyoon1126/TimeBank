//
//  AnalystViewController.swift
//  TimeBankXcode
//
//  Created by 김담인 on 2022/03/03.
//

import UIKit

class AnalystViewController: UIViewController {

    @IBOutlet weak var analystUIImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        analystUIImageView.image = UIImage(named: "analyst")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
