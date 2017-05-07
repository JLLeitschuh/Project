//
//  SignUpViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 19..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftValidator

class RegisterViewController: InitController, ValidationDelegate {

    // MARK: Properties
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userPasswordLabel: UILabel!
    @IBOutlet weak var userRepeatPasswordLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    let validator = Validator()
    var validationFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Label Text Color Setting
        userIDLabel.textColor = UIColor.white
        userPasswordLabel.textColor = UIColor.white
        userRepeatPasswordLabel.textColor = UIColor.white
        userNicknameLabel.textColor = UIColor.white
        userPhoneLabel.textColor = UIColor.white
        
        // Register Form Validation
        validator.registerField(userNicknameTextField, errorLabel:userNicknameLabel, rules: [RequiredRule(), MinLengthRule(length: 4), MaxLengthRule(length:8), AlphaNumericRule()])
        validator.registerField(userPhoneTextField, errorLabel:userPhoneLabel, rules: [RequiredRule(), CustomPhoneNumberRule()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchRegisterBtn(_ sender: AnyObject) {
        
        let userID = userIDTextField.text
        let userPassword = passwordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        let userNickname = userNicknameTextField.text
        let userPhone = userPhoneTextField.text
        let registerParams = ["userID": userID! as String,
                              "userPassword": userPassword! as String,
                              "userNickname": userNickname! as String,
                              "userPhone": userPhone! as String]
        
        // Check for empty fileds
        if (userID!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty ||
            userNickname!.isEmpty || userPhone!.isEmpty) {
            
            displayAlertMessage("모든 항목을 다 채워주세요.")
            return
        }
        
        // Check if passwords match
        if (userPassword != userRepeatPassword) {
            
            displayAlertMessage("비밀번호가 일치하지 않습니다.")
            return
        }
        
        validator.validate(self)
        
        if (validationFlag == true) {
            // Register
            Alamofire.request(.POST, registerUrl!, parameters: registerParams)
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        let response = JSON as! NSDictionary
                        print(response.object(forKey: "message")!)
                        
                        let isSuccess = String(response.object(forKey: "message")!)
                        if (isSuccess == "Success") {
                            
                            let okAlert = UIAlertController(title: "알림", message: "회원 가입 완료.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
                                action in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            okAlert.addAction(okAction)
                            self.present(okAlert, animated: true, completion: nil)
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
            
        }   //End of if
        
        
        
        /* let myUrl = NSURL(string: "http://localhost:8080/mycaffe/app/register.jsp")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "userID=\(userID)&userPassword=\(userPassword)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        */
        
        /*
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if (error != nil) {
                print("error =\(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let resultValue = parseJSON["status"] as? String
                    print("result: \(resultValue)")
                    
                    var isUserRegistered:Bool = false
                    if (resultValue == "Success") {
                        isUserRegistered = true
                    }
                    
                    var messageToDisplay:String = parseJSON["message"] as! String!
                    if (!isUserRegistered) {
                        messageToDisplay = parseJSON["message"] as! String!
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let okAlert = UIAlertController(title: "Alert", message: "Cool", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        
                        okAlert.addAction(okAction)
                        self.presentViewController(okAlert, animated: true, completion: nil)
                    })
                    
                }
                
            }
            
            catch {
                print(error)
            }
            
            
            
            
    
        } */
        
        
    }
    @IBAction func touchGoLoginBtn(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userIDTextField.endEditing(true)
        passwordTextField.endEditing(true)
        repeatPasswordTextField.endEditing(true)
        userNicknameTextField.endEditing(true)
        userPhoneTextField.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // ValidationDelegate methods
    func validationSuccessful() {
        
        validationFlag = true
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    
}

class CustomPhoneNumberRule: RegexRule {
    
    static let regex = "^\\d{11}$"
    
    convenience init(message : String = "폰 번호 11자리를 입력하세요."){
        self.init(regex: CustomPhoneNumberRule.regex, message : message)
    }
}
