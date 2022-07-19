//
//  Constant.swift
//  BeeCrops
//
//  Created by Maulik Vinodbhai Vora on 24/07/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//
import UIKit
import Foundation

//let appDelegate = UIApplication.shared.delegate as! AppDelegate
var isLoadingViewVisible = false

//Google Api Key
let googleApiKey = ""



//Veiable
var dropDownOptionsListModel = DropDownOptionsListModel()

let k_DateFormate = "yyyy-MM-dd HH:mm:ss"
let k_DateFormate_Date = "dd/MM/yyyy"
let k_DateFormate_Time = "hh:mm"



//MARK: - Storyboards Objects
let objMainSB = UIStoryboard(name: "MIBSInitSB", bundle: nil)
let objSideMenuSB = UIStoryboard(name: "SideMenuSB", bundle: nil)










//MARK: - Veriable
let kAlertTitle = "Maisarah"




//MARK: - DeviceInfo
let deviceInfo = ["device_id":kDevice_id,
                  "ip_info":"\(AppHelper.getIP() ?? "")",
                  "braswer_info":"",
                  "os_info":[["name":"ios","version":"\(Bundle.main.releaseVersionNumber ?? "")"]],
                  "other_info":[[:]]
] as [String : Any]
