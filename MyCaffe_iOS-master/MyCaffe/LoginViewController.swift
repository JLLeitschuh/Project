//
//  ViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 19..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: InitController {

    // MARK: properties
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var userInfoArr = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        userIDLabel.textColor = UIColor.white
        passwordLabel.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: actions
    @IBAction func touchLoginBtn(_ sender: AnyObject) {
        let userID = userIDTextField.text
        let userPassword = passwordTextField.text
        let loginParams = ["userID": userID! as String, "userPassword": userPassword! as String]
        
        // Check for empty fileds
        if(userID!.isEmpty || userPassword!.isEmpty) {
            
            displayAlertMessage("모든 항목을 다 채워주세요.")
            return
        }
        
        // Login
        loginWithParseJSONData(loginParams)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userIDTextField.endEditing(true)
        passwordTextField.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: Custom Func
    func loginWithParseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, loginUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    //print(JSON)
                    let response = JSON as! NSDictionary
                    
                    if (response.count > 1) {
                        let userIDX = response.object(forKey: "userIDX")!
                        let userNickname = response.object(forKey: "userNickname")!
                        let userPhone = response.object(forKey: "userPhone")!
                        let userFavCafe = response.object(forKey: "userFavCafe")!
                        
                        UserDefaults.standard.setValue(searchParams["userID"], forKeyPath: "userID")
                        UserDefaults.standard.setValue(userIDX, forKey: "userIDX")
                        UserDefaults.standard.setValue(userNickname, forKey: "userNickname")
                        UserDefaults.standard.setValue(userPhone, forKey: "userPhone")
                        UserDefaults.standard.setValue(userFavCafe, forKey: "userFavCafe")
                        
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        print(UserDefaults.standard.integer(forKey: "userIDX"))
                        print(UserDefaults.standard.string(forKey: "userNickname")!)
                        print(UserDefaults.standard.string(forKey: "userPhone")!)
                        print(UserDefaults.standard.integer(forKey: "userFavCafe"))
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    else {
                        let alertMessage = String(response.object(forKey: "message")!)
                        self.displayAlertMessage(alertMessage)
                    }
                    
                case .failure(let error):
                    print("Request failed, \(error)")
                    
                    let alertMessage = String(error)
                    self.displayAlertMessage(alertMessage)
                }
        }
    }
    

}
