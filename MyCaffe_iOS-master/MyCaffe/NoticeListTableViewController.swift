//
//  NoticeListTableViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 24..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire

class NoticeListTableViewController: UITableViewController {

    var noticeListArr = [[String:AnyObject]]()
    var noticeDetailInfoArr = [String:AnyObject]()
    
    @IBOutlet var noticeTableView: UITableView!
    
    //let selectCafeNoticeListUrl = NSURL(string: "http://localhost:8080/mycaffe/app/select_cafe_notice_list.jsp")
    let selectCafeNoticeListUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_cafe_notice_list.jsp")
    
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
        return noticeListArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell")! as! NoticeListTableViewCell
        
        var tmpArr = noticeListArr[indexPath.row]
        
        cell.indexLabel.text = String(tmpArr["noticeParentIDX"]!)
        cell.titleLabel.text = tmpArr["noticeTitle"] as? String
        cell.dateLabel.text = tmpArr["noticeCreDtm"] as? String
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        noticeDetailInfoArr = noticeListArr[indexPath.row]
        
        performSegue(withIdentifier: "goNoticeDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goNoticeDetail") {
            let detailViewController = segue.destination as! NoticeDetailViewController
            detailViewController.noticeDetailInfoArr = noticeDetailInfoArr
        }
        
    }
    
    // MARK: Custom Func
    func parseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, selectCafeNoticeListUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSArray
                    for item in response {
                        let obj = item as! NSDictionary
                        let tmpArr = [
                            "noticeParentIDX":obj.object(forKey: "noticeParentIDX")!,
                            "noticeTitle": obj.object(forKey: "noticeTitle")!,
                            "noticeCreDtm": obj.object(forKey: "noticeCreDtm")!,
                            "noticeContents": obj.object(forKey: "noticeContents")!,
                            "noticeCnt": obj.object(forKey: "noticeCnt")!
                        ]
                        print(tmpArr)
                        self.noticeListArr.append(tmpArr)
                    }
                    
                    self.noticeTableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed, \(error)")
                    
                }
        }
        
    }
    
    func clearTable() {
        
        self.noticeListArr.removeAll()
        self.noticeTableView.reloadData()
        
    }
    
}
