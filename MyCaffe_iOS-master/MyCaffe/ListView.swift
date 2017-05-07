//
//  ListView.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 22..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit

class ListView: UIViewController {

    @IBOutlet weak var userNicknameLabel: UILabel!
    
    let dataSingleton = DataSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNicknameLabel.text = UserDefaults.standard.string(forKey: "userNickname")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func touchLogoutBtn(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let tmpController :UIViewController! = self.presentingViewController;
        
        self.dismissViewControllerAnimated(false, completion: {()-> Void in
            
            tmpController.dismissViewControllerAnimated(false, completion: nil);
        });
        
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
