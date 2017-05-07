//
//  NoticeDetailViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 27..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textViewLabel: UITextView!
    
    var noticeDetailInfoArr = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = noticeDetailInfoArr["noticeTitle"] as? String
        dateTimeLabel.text = noticeDetailInfoArr["noticeCreDtm"] as? String
        countLabel.text = String(noticeDetailInfoArr["noticeCnt"]!)
        textViewLabel.text = noticeDetailInfoArr["noticeContents"] as? String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
