//
//  MenuListTableViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 24..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit
import Alamofire

class MenuListTableViewController: InitController, UITableViewDelegate, UITableViewDataSource {

    var menuListArr = [[String:AnyObject]]()
    
    @IBOutlet weak var menuTableView: UITableView!
    
    //let selectCafeMenuListUrl = NSURL(string: "http://localhost:8080/mycaffe/app/select_cafe_menu_list.jsp")
    let selectCafeMenuListUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_cafe_menu_list.jsp")
    let insertMenuOrderUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/insert_menu_order.jsp")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // MARK: TableView
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        clearTable()
        let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX"),
                            "menuType": 1
                            ]
        
        // Data Connect
        parseJSONData(searchParams)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuListCell")! as! MenuListTableViewCell
        
        var tmpArr = menuListArr[indexPath.row]
        
        cell.menuNameLabel.text = tmpArr["menuName"] as? String
        cell.menuPriceLabel.text = String(tmpArr["menuPrice"]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpArr = menuListArr[indexPath.row]
        
        let message = "메뉴 [" + String(tmpArr["menuName"]!) + "]" + " 예약 주문하시겠습니까?"
        
        displayOrderMessage(message, orderInfo: tmpArr)
        
    }
    
    
    // MARK: Actions
    @IBAction func touchDrinkBtn(_ sender: AnyObject) {
        
        clearTable()
        let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX"),
                            "menuType": 1
        ]
        
        // Data Connect
        parseJSONData(searchParams)
    }
    
    @IBAction func touchBakerBtn(_ sender: AnyObject) {
        
        clearTable()
        let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX"),
                            "menuType": 2
        ]
        
        // Data Connect
        parseJSONData(searchParams)
    }
    
    @IBAction func touchOtherBtn(_ sender: AnyObject) {
        
        clearTable()
        let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX"),
                            "menuType": 3
        ]
        
        // Data Connect
        parseJSONData(searchParams)
    }
    
    
    // MARK: Custom Func
    func parseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, selectCafeMenuListUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSArray
                    for item in response {
                        let obj = item as! NSDictionary
                        let tmpArr = [
                            "menuIDX":obj.object(forKey: "menuIDX")!,
                            "menuType":obj.object(forKey: "menuType")!,
                            "menuName": obj.object(forKey: "menuName")!,
                            "menuPrice": obj.object(forKey: "menuPrice")!
                        ]
                        print(tmpArr)
                        self.menuListArr.append(tmpArr)
                    }
                    
                    self.menuTableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed, \(error)")
                    
                }
        }
        
    }
    
    func clearTable() {
        
        self.menuListArr.removeAll()
        self.menuTableView.reloadData()
        
    }
    
    func displayOrderMessage(_ userMessage:String, orderInfo:[String:AnyObject]) {
        
        let okAlert = UIAlertController(title: "알림", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "주문 예약", style: UIAlertActionStyle.default) {
            action in
            
            let searchParams = ["cafeIDX": UserDefaults.standard.integer(forKey: "cafeIDX"),
                                "userIDX": UserDefaults.standard.integer(forKey: "userIDX"),
                                "menuIDX": orderInfo["menuIDX"]!
            ]
            
            self.insertMenuOrderWithParseJSONData(searchParams)
        }
        
        let cancleAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default, handler: nil)
        
        okAlert.addAction(okAction)
        okAlert.addAction(cancleAction)
        
        self.present(okAlert, animated: true, completion: nil)
        
    }

    func insertMenuOrderWithParseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, insertMenuOrderUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    //print(JSON)
                    
                    let response = JSON as! NSDictionary
                    
                    let isSuccess = String(response.object(forKey: "message")!)
                    if (isSuccess == "Success") {
                        let alertMessage = "메뉴 주문을 예약했습니다. "
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
