//
//  MainVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 21/01/22.
//

import UIKit
import Toast_Swift
import IQKeyboardManagerSwift

class MainVC: UIViewController {
    // MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblChooseOneTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblResumeAccountOpennig_title: UILabel!
    @IBOutlet weak var lblResumeAccountOpennig_detail: UILabel!
    @IBOutlet weak var lblStartAccountOpening_title: UILabel!
    @IBOutlet weak var lblStartAccountOpening_detail: UILabel!
    @IBOutlet weak var lblScheduleVideoCall_title: UILabel!
    @IBOutlet weak var lblScheduleVideoCall_detail: UILabel!
    @IBOutlet weak var lblCheckApplicationStatus_title: UILabel!
    @IBOutlet weak var lblCheckApplicationStatus_detail: UILabel!
    @IBOutlet weak var lblStartVideoCall: UILabel!
    @IBOutlet weak var lblStartScheduledCallDetail: UILabel!
    
    
    
    
    //MARK: - Veriable
    
    
    // MARK: LifeCycle Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupHeader()
        IQKeyboardManager.shared.enable = true
        
        //--
        if Login_LocalDB.getApplicationInfo().crmid.count != 0{
            //--
            //let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
            //vc.citizenshipType = .omani
            //self.navigationController?.pushViewController(vc, animated: true)
            
            //--
            //let vc = VideoCallVC(nibName: "VideoCallVC", bundle: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
            
            //--
            MainVC.apiCall_getDropDownOptions()
        }else{
            MainVC.apiCall_login()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        localization()
        self.navigationController?.navigationBar.isHidden = true
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        
    }
    func setupBasic(){
        lblChooseOneTitle.attributedText = Localize(key: "Choose one").attributedStringWithColorNew(7, length: 3, color: .DARKGREENTINT)
        //attributedStringWithColor(["one"], color: UIColor(named: "DARKGREENTINT")!)
        lblDetail.text = Localize(key: "Choose one detail")
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblResumeAccountOpennig_title.text = Localize(key: "ResumeAccountOpennig_title")
        lblResumeAccountOpennig_detail.text = Localize(key: "ResumeAccountOpennig_detail")
        lblStartAccountOpening_title.text = Localize(key: "StartAccountOpening_title")
        lblStartAccountOpening_detail.text = Localize(key: "StartAccountOpening_detail")
        lblScheduleVideoCall_title.text = Localize(key: "ScheduleVideoCall_title")
        lblScheduleVideoCall_detail.text = Localize(key: "ScheduleVideoCall_detail")
        lblCheckApplicationStatus_title.text = Localize(key: "CheckApplicationStatus_title")
        lblCheckApplicationStatus_detail.text = Localize(key: "CheckApplicationStatus_detail")
        
        
    }
    
    // MARK: @IBAction
    @IBAction func btnResumeAccOpening(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .ResumeAccountOpening
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*
        //--Temp
        let vc = TermsConditionsVC(nibName: "TermsConditionsVC", bundle: nil)
        //vc.citizenshipType = .omani
        //vc.risk_level = "1"
        self.navigationController?.pushViewController(vc, animated: true)
         */
    }
    @IBAction func btnStartAccOpening(_ sender: Any) {
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "SelectAccountTypeVC") as! SelectAccountTypeVC
        vc.validateOTPStep = "new"
        self.navigationController?.pushViewController(vc, animated: true)
         
//        //--
//        let vc = LivenessCheckVC(nibName: "LivenessCheckVC", bundle: nil)
//        vc.citizenshipType = .omani
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnScheduleVideoCall(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .ScheduleVideoCall
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*
        //Temp
        //--
        let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
        vc.isComeFromLivenessCheck = true
        self.navigationController?.pushViewController(vc, animated: true)
        //--
        let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    @IBAction func btnCheckApplication(_ sender: Any) {
        
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .CheckApplicationStatus
        vc.validateOTPStep = "checkStatus"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnChangeLang(_ sender: Any) {
        Managelanguage.changeLanguageCode()
        
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //Other Flows
    @IBAction func btnAddOnServices(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .AddOnServices
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        /*//--
        let vc = AddonServicesVC(nibName: "AddonServicesVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    @IBAction func btnProofOfAddress(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .ProofOfAddress
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        /*//--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.isComeForAddingProofofAddress = true
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    @IBAction func btnHighRishCustomer(_ sender: Any) {
        
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .HighRiskCustomer
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        /*//--
        let vc = HighCustomerVC(nibName: "HighCustomerVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    @IBAction func btnVeryHighRishCustomer(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .VeryHighRiskCustomer
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        //--
        let vc = VeryHighCustomerVC(nibName: "VeryHighCustomerVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    @IBAction func btnStartVideoCall(_ sender: Any) {
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .StartVideoCall
        vc.validateOTPStep = "resumeFlow"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


//MARK: - Api Call
extension MainVC{
    class func apiCall_login()  {
        //--
        //let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "asdfghjhgfds"
        
        //--
        let dicParam:[String:AnyObject] = ["operation":"login" as AnyObject,
                                           "data":["client_id":kClient_id,
                                                   "client_secret":kClient_secret,
                                                   "grant_type":"client_credentials"] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: A_mobileapi, dicsParams: dicParam, headers: [:], completion: { [self] (response) in
            print(response as Any)
            let mobileApiModel = MobileApiModel(JSON: response as! [String : Any])!
            if mobileApiModel.status == 200{
                //--
                if let mobileApiModel_ = MobileApiModel(JSON: response as! [String : Any])!.toJSONString(){
                    Login_LocalDB.saveLoginInfo(strData: mobileApiModel_)
                }
                //--
                apiCall_getDropDownOptions()
            }else{
                AppHelper.returnTopNavigationController().view.makeToast(response.object(forKey: "message") as? String ?? "")
            }
        }) { (error) in
            print(error)
        }
    }
    
    class func apiCall_getDropDownOptions()  {
        
        //--
        let dicParam:[String:AnyObject] = ["operation":"getDropDownOptions" as AnyObject,
                                           "data":["modulename":"Opportunities",
                                                   "language":"en",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { (response) in
            print(response as Any)
            dropDownOptionsListModel = DropDownOptionsListModel(JSON: response as! [String : Any])!
            if dropDownOptionsListModel.response?.Code == "200"{
                
            }else if dropDownOptionsListModel.error == "access_denied"{
                apiCall_login()
            }else{
                AppHelper.returnTopNavigationController().view.makeToast(dropDownOptionsListModel.message)
            }
            apiCall_getDefaultConfiguration()
        }) { (error) in
            print(error)
        }
    }
}
