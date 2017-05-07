//
//  InitController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 20..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

enum UIModalTransitionStyle : Int {
    case coverVertical = 0
    case flipHorizontal
    case crossDissolve
    case partialCurl
}

class InitController: UIViewController {
    
    // MARK: Properties
    
    /*
    let registerUrl = NSURL(string: "http://localhost:8080/mycaffe/app/register.jsp")
    let loginUrl = NSURL(string: "http://localhost:8080/mycaffe/app/login.jsp")
    let currentCafeUrl = NSURL(string: "http://localhost:8080/mycaffe/app/home_current_cafe.jsp")
    let selectCafeUrl = NSURL(string: "http://localhost:8080/mycaffe/app/select_cafe.jsp")
    let cafeImagePathUrl = NSURL(string: "http://localhost:8080/mycaffe/fileDir/")
    let insertMenuOrderUrl = NSURL(string: "http://localhost:8080/mycaffe/app/insert_menu_order.jsp")
    */
    
    let registerUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/register.jsp")
    let loginUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/login.jsp")
    let currentCafeUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/home_current_cafe.jsp")
    let selectCafeUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_cafe.jsp")
    let cafeImagePathUrl = URL(string: "http://52.78.42.3:8080/mycaffe/fileDir/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.black
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Actions
    func displayAlertMessage(_ userMessage:String) {
        
        let okAlert = UIAlertController(title: "알림", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        
        okAlert.addAction(okAction)
        self.present(okAlert, animated: true, completion: nil)
    }
    
}
