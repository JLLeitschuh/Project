//
//  CouponListTableViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 24..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire

class CouponListTableViewController: UITableViewController {

    var couponListArr = [[String:AnyObject]]()
    
    @IBOutlet var couponTableView: UITableView!
    
    //let selectMyCouponListUrl = NSURL(string: "http://localhost:8080/mycaffe/app/select_my_coupon_list.jsp")
    let selectMyCouponListUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_my_coupon_list.jsp")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let searchParams = ["userIDX": UserDefaults.standard.integer(forKey: "userIDX")]
        
        // Data Connect
        parseJSONData(searchParams)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return couponListArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponListCell")! as! CouponListTableViewCell
        var tmpArr = couponListArr[indexPath.row]
        
        cell.cafeNameLabel.text = tmpArr["cafeName"] as? String
        cell.couponAmountLabel.text = String(tmpArr["couponAmount"]!) + "개"
        
        return cell
    }
    
    
    // MARK: Actions
    
    @IBAction func touchBackBtn(_ sender: AnyObject) {
        let revealViewController = storyboard?.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewController
        self.presentViewController(revealViewController, animated: true, completion: nil)
    }
    
    
    
    // MARK: Custom Func
    
    func parseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, selectMyCouponListUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSArray
                    for item in response {
                        let obj = item as! NSDictionary
                        let tmpArr = [
                            "couponAmount":obj.object(forKey: "couponAmount")!,
                            "cafeName": obj.object(forKey: "cafeName")!
                        ]
                        print(tmpArr)
                        self.couponListArr.append(tmpArr)
                    }
                    
                    self.couponTableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed, \(error)")
                    
                }
        }
        
    }
    
}
