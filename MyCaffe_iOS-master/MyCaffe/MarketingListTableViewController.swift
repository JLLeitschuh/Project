//
//  MarketingListTableViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 24..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire

class MarketingListTableViewController: UITableViewController {

    var marketingListArr = [[String:AnyObject]]()
    
    @IBOutlet var marketingTableView: UITableView!
    
    //let selectCafeMarketingListUrl = NSURL(string: "http://localhost:8080/mycaffe/app/select_cafe_marketing_list.jsp")
    let selectCafeMarketingListUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_cafe_marketing_list.jsp")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        clearTable()
        let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX")]
        
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
        return marketingListArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketingListCell")! as! MarketingListTableViewCell
        
        var tmpArr = marketingListArr[indexPath.row]
        
        cell.indexLabel.text = String(tmpArr["marketingIDX"]!)
        cell.menuNameLabel.text = tmpArr["menuName"] as? String
        cell.menuPriceLabel.text = tmpArr["menuPrice"] as? String
        cell.timeZoneLabel.text = String(tmpArr["marketingTimeZone"]!)
        
        return cell
    }
    
    
    // MARK: Custom Func
    func parseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, selectCafeMarketingListUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSArray
                    for item in response {
                        let obj = item as! NSDictionary
                        let tmpArr = [
                            "marketingIDX":obj.object(forKey: "marketingIDX")!,
                            "menuName": obj.object(forKey: "menuName")!,
                            "menuPrice": obj.object(forKey: "menuPrice")!,
                            "marketingTimeZone": obj.object(forKey: "marketingTimeZone")!
                        ]
                        print(tmpArr)
                        self.marketingListArr.append(tmpArr)
                    }
                    
                    self.marketingTableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed, \(error)")
                    
                }
        }
        
    }
    
    func clearTable() {
        
        self.marketingListArr.removeAll()
        self.marketingTableView.reloadData()
        
    }
    


    
}
