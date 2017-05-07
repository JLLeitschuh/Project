//
//  HomeViewController.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 19..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//
//  NSUserDefaults :: [Bool: "isUserLoggedIn", "isUserSelectCafe",
//                    Object(Int): "userIDX", "userFavCafe",
//                    Object(String): "userID", "userNickname", "userPhone",
//                    Dict("selectedCafeInfo"): ["cafeIDX", "cafeName", "cafeLocation", "cafeComment"]
//  ]
//

import UIKit
import Alamofire
import CoreLocation

class HomeViewController: InitController, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuListBtn: UIBarButtonItem!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeInfoLabel: UILabel!
    
    var cafeInfoArr = [String:AnyObject]()
    var data: Data?
    
    let dataSingleton = DataSingleton.sharedInstance
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimote")
    var beaconLastDetectionTime = 0.0
    var beaconVisited = false
    var beaconExitFired = false
    var marketingContentsArr = [String:AnyObject]()
    
    let selectCafeMarketingContentsUrl = URL(string: "http://52.78.42.3:8080/mycaffe/app/select_cafe_marketing_contents.jsp")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // SWReveail View Connect
        if self.revealViewController() != nil {
            menuListBtn.target = self.revealViewController()
            menuListBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        }

        // iBeacon locationManager Setting
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        let isUserSelectCafe = UserDefaults.standard.bool(forKey: "isUserSelectCafe")
        
        if (!isUserLoggedIn) {
            self.performSegue(withIdentifier: "goLoginView", sender: self)
        }
        
        else {
            
            if (!isUserSelectCafe) {
                self.performSegue(withIdentifier: "goSelectCafe", sender: self)
            }
            
            if let selectedCafeInfo = UserDefaults.standard.object(forKey: "selectedCafeInfo") {
                
                cafeNameLabel.text = selectedCafeInfo["cafeName"]!! as? String
                cafeInfoLabel.text = selectedCafeInfo["cafeComment"]!! as? String
                
                if ((selectedCafeInfo["cafeLogo"]!! as? String)! == "1") {
                    if let url = URL(string: "http://52.78.42.3:8080/mycaffe/fileDir/cafe_default.jpg"),
                        data = try? Data(contentsOf: url)
                    {
                        cafeImageView.image = UIImage(data: data)
                    }
                }
                
                else {
                    if let url = URL(string: "http://52.78.42.3:8080/mycaffe/fileDir/" + ((selectedCafeInfo["cafeLogo"]!!) as! String)),
                        data = try? Data(contentsOf: url)
                    {
                        cafeImageView.image = UIImage(data: data)
                    }
                }
                
                /*
                print(selectedCafeInfo["cafeIDX"]!!)
                print(selectedCafeInfo["cafeName"]!!)
                print(selectedCafeInfo["cafeTel"]!!)
                print(selectedCafeInfo["cafeLocation"]!!)
                print(selectedCafeInfo["cafeComment"]!!)
                print(selectedCafeInfo["cafeLogo"]!!)
                */
            }
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //print(beacons)
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closetBeacon = knownBeacons[0] as CLBeacon
            //self.view.backgroundColor = self.colors[closetBeacon.major.integerValue]
    
            if (!beaconVisited) {
                
                let searchParams = ["cafeIDX": closetBeacon.major.intValue]
                marketingContentsWithParseJSONData(searchParams)
                beaconVisited = true
            }
            
            beaconLastDetectionTime = Date().timeIntervalSince1970
            beaconExitFired = false
        }
        
        if (Date().timeIntervalSince1970 - beaconLastDetectionTime > 10.0 && !beaconExitFired) {
            beaconExitFired = true
            beaconVisited = false
            
            print("비콘 감지 끝")
        }
    
    }
    
    // MARK: Actions
    @IBAction func myUnwindAction(_ segue: UIStoryboardSegue) {
        
    }
    
    
    func marketingContentsWithParseJSONData(_ searchParams: [String:AnyObject]) {
        Alamofire.request(.POST, selectCafeMarketingContentsUrl!, parameters: searchParams)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    //print(JSON)
                    let response = JSON as! NSDictionary
                    
                    if (response.count >= 1) {
                        let marketingTimeZone = response.object(forKey: "marketingTimeZone")!
                        let menuName = response.object(forKey: "menuName")!
                        let menuPrice = response.object(forKey: "menuPrice")!
                        
                        self.marketingContentsArr["menuName"] = menuName
                        self.marketingContentsArr["menuPrice"] = menuPrice
                        self.marketingContentsArr["marketingTimeZone"] = marketingTimeZone
                        
                        //print(self.marketingContentsArr)
                        
                        self.displayAlertMessage("[\(self.marketingContentsArr["menuName"]!)] 메뉴 \(self.marketingContentsArr["menuPrice"]!)원 프로모션이 있습니다. (\(self.marketingContentsArr["marketingTimeZone"]!)시)")
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
