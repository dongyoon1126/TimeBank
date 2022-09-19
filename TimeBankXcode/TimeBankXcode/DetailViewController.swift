//
//  DetailViewController.swift
//  tableCellCreation
//
//  Created by Abraham Park on 2022/02/10.
//

import UIKit

class DetailViewController: UIViewController {
    var item: Default!
    var items: [Default]! = []
    var isEditMode: Bool = false
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditMode == true {
            labelTitle.text = items[0].title
        } else {
            labelTitle.text = item.title
        }
        
      

    }
}
