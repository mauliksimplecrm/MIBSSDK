//
//  EnterMobileEmailVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 21/01/22.
//

import UIKit
import SKCountryPicker
import DropDown

class EnterMobileEmailVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtMobileNumber: FloatingTextFieldWithCode!
    @IBOutlet weak var txtEmail: UIFloatingTextField!
    @IBOutlet weak var viewbgbtnNext: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNext: UILabel!
    
    
    //MARK: - Veriable
    var serviceType = ServiceType.non
    var validateOTPStep = ""
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupBasic()
    }
    override func viewWillAppear(_ animated: Bool) {
        localization()
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.btnScheduleaCall.setTitle(Localize(key: "Schedule a Call"), for: .normal)
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupBasic(){
        if applyValidation{
            AppHelper.disableNextBTN(view_: viewbgbtnNext)
        }
        
        //--
        lblTitle.attributedText = Localize(key: "Enter details").attributedStringWithColor(["details"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Enter details detail")
        
        //--
        txtMobileNumber.setTitlePlaceholder(text_: Localize(key: "Mobile Number"), placeholder_: "", isUserInteraction: true)
        txtMobileNumber.lblCode.text = "+968"
        txtMobileNumber.delegate_UIFloatingTextField_Protocol = self
        
        txtEmail.setICON(hidden: true)
        txtEmail.setTitlePlaceholder(text_: Localize(key: "Email ID"), placeholder_: "", isUserInteraction: true)
        txtEmail.delegate_UIFloatingTextField_Protocol = self
        txtEmail.txtType.keyboardType = .emailAddress
        
        //--
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblNext.text = Localize(key: "NEXT")
        
    }
    
    //MARK: @IBAction
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        
        apiCall_otpGeneration()
    }
    
  
}


extension EnterMobileEmailVC: UIFloatingTextField_Protocol{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func btnOpenCountryCodePicker(textField: UITextField) {
        self.view.endEditing(true)
        if textField == txtMobileNumber.txtType{
           /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtMobileNumber.lblCode.text = country.dialingCode ?? ""
                self.txtMobileNumber.imgFlag.image = country.flag
            }
            */
        }

    }
    func editingChanged(textField: UITextField)  {
        validateEnput()

        
    }
    
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool{
        if textField == txtMobileNumber.txtType{
            var maxLength = 0
            if instanceType == .Dev{
                maxLength = 11
            }else{
                maxLength = 9
            }
            if maxLength <= txt.count{
                print(maxLength)
                //let latestString = txtMobileNumber.txtType.text!
                print(String(txt.prefix(maxLength)))
                print(txt)
                //txtMobileNumber.txtType.text = String(txt.prefix(maxLength))
                return false
            }else{
                
            }
            
            
        }
        return true
    }
    
    func validateEnput(){
        /*if isComeForAddingProofofAddress{
            if (txtMobileNumber.txtType.text?.count ?? 0) >= 5{
                AppHelper.enableNextBTN(view_: viewbgbtnNext)
            }else{
                AppHelper.disableNextBTN(view_: viewbgbtnNext)
            }
        }else{*/
            if (txtMobileNumber.txtType.text?.count ?? 0) >= 5 && AppHelper.isValidEmail(txtEmail.txtType.text!) == true{
                AppHelper.enableNextBTN(view_: viewbgbtnNext)
            }else{
                AppHelper.disableNextBTN(view_: viewbgbtnNext)
            }
        //}
    }
    
}


//MARK: - Api Call
extension EnterMobileEmailVC{
    
    func apiCall_otpGeneration()  {
        //--
        let verification_type = "both"
        /*if isComeForAddingProofofAddress{
            verification_type = "mobile"
        }else{
            verification_type = "both"
        }*/
        
        //--
        let dicParam:[String:AnyObject] = ["operation":"otpGeneration" as AnyObject,
                                           "data":["mobile_number": "\(txtMobileNumber.txtType.text!)",//"\(txtMobileNumber.lblCode.text!)\(txtMobileNumber.txtType.text!)",
                                                   "email":txtEmail.txtType.text!,
                                                   "verification_type":verification_type,
                                                   "mobile_key":"Q66P4XNHE4LPK4MO",
                                                   "email_key":"RUFHV4RY265PXFQU",
                                                   "step":validateOTPStep,
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "001"{
                
                //--
                let vc = VerifyMobileEmailOTPVC(nibName: "VerifyMobileEmailOTPVC", bundle: nil)
                vc.serviceType = serviceType
                vc.enterEmail = txtEmail.txtType.text!
                vc.enterMobileNumber = "\(txtMobileNumber.txtType.text!)"//"\(txtMobileNumber.lblCode.text!)\(txtMobileNumber.txtType.text!)"
                vc.validateOTPStep = validateOTPStep
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.view.makeToast(oTPGenerationModel.message)
            }
        }) { (error) in
            print(error)
        }
    }

}
