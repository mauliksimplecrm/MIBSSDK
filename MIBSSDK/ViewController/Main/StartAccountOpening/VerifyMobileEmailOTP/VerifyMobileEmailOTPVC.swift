//
//  VerifyMobileEmailOTPVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 22/01/22.
//

import UIKit
import Popover
import AVFoundation

class VerifyMobileEmailOTPVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    
    //Veriy Mobile
    @IBOutlet weak var lblVerifyMobile: UILabel!
    @IBOutlet weak var lblVerifyMobileDetail: UILabel!
    @IBOutlet weak var txtOtpPhone1: UITextField!
    @IBOutlet weak var txtOtpPhone2: UITextField!
    @IBOutlet weak var txtOtpPhone3: UITextField!
    @IBOutlet weak var txtOtpPhone4: UITextField!
    @IBOutlet weak var lblResendMobileOTP: UILabel!
    @IBOutlet weak var btnResendMobileOTP: UIButton!
    @IBOutlet weak var lblPhoneValidation: UILabel!
    @IBOutlet weak var viewUndoSkip_Mobile: UIView!
    @IBOutlet weak var lblDidyouReceiveOtpNow_Mobile: UILabel!
    @IBOutlet weak var btnUndoSkip_Mobile: UIButton!
    @IBOutlet weak var lblHavingIssueOTP_Mobile: UILabel!
    @IBOutlet weak var btnYes_Mobile: UIButton!
    @IBOutlet weak var btnNo_Mobile: UIButton!
    @IBOutlet weak var btnSkipMobile_Mobile: UIButton!
    @IBOutlet weak var viewOTPMobile: UIView!
    @IBOutlet weak var viewMainVerifyMobile: UIView!
    @IBOutlet weak var viewHavingIssuesMobile: UIView!
    @IBOutlet weak var viewHavingIssuesHeight: NSLayoutConstraint! //91
    
    //Verify Email
    @IBOutlet weak var lblVerifyEmail: UILabel!
    @IBOutlet weak var lblVerifyEmailDetail: UILabel!
    @IBOutlet weak var txtOtpEmail1: UITextField!
    @IBOutlet weak var txtOtpEmail2: UITextField!
    @IBOutlet weak var txtOtpEmail3: UITextField!
    @IBOutlet weak var txtOtpEmail4: UITextField!
    @IBOutlet weak var lblResendEmailOTP: UILabel!
    @IBOutlet weak var btnResendEmailOTP: UIButton!
    @IBOutlet weak var lblEmailValidation: UILabel!
    @IBOutlet weak var viewUndoSkip_Email: UIView!
    @IBOutlet weak var lblDidyouReceiveOtpNow_Email: UILabel!
    @IBOutlet weak var btnUndoSkip_Email: UIButton!
    @IBOutlet weak var lblHavingIssueOTP_Email: UILabel!
    @IBOutlet weak var btnYes_Email: UIButton!
    @IBOutlet weak var btnNo_Email: UIButton!
    @IBOutlet weak var btnSkipMobile_Email: UIButton!
    @IBOutlet weak var viewOTPEmail: UIView!
    @IBOutlet weak var viewMainVerifyEmail: UIView!
    @IBOutlet weak var viewHavingIssuesEmail: UIView!
    @IBOutlet weak var viewHavingIssuesHeightEmail: NSLayoutConstraint! //91
    
    
    @IBOutlet weak var lblVerifyDetail: UILabel!
    @IBOutlet weak var viewbgbtnVerifyDetails: UIView!
    
    @IBOutlet var viewbg_AttemptAlert: UIView!
    @IBOutlet weak var lblTitle_AttemptAlert: UILabel!
    @IBOutlet weak var lblDetail_AttemptAlert: UILabel!
    @IBOutlet weak var btnBack_AttemptAlert: UIButton!
    @IBOutlet weak var btnContactbank_AttemptAlert: UIButton!
    
    
    
    
    
    
    
    
    //MARK: - Veriable
    var validateOTPStep = ""
    var serviceType = ServiceType.non
    var popover = Popover()
    var timerResendPhoneOTP: Timer?
    var phoneResendOTPTime = 10
    var totalPhoneResendOTPAttempt = 0
    var timerResendEmailOTP: Timer?
    var emailResendOTPTime = 10
    var totalEmailResendOTPAttempt = 0
    
    var enterMobileNumber = "+968553456789"
    var enterEmail = "jennifersmith@gmail.com"
    var oTPGenerationResult:OTPGenerationResult?
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupBasic()
        setOtpTextField()
        defaultUI_Mobile()
        defaultUI_Email()
    }
    override func viewWillAppear(_ animated: Bool) {
        localization()
    }
    override func viewWillDisappear(_ animated: Bool) {
        timerResendPhoneOTP?.invalidate()
        timerResendEmailOTP?.invalidate()
        
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
            AppHelper.disableNextBTN(view_: viewbgbtnVerifyDetails)
        }
        
        //--
        lblVerifyMobileDetail.attributedText = "\(Localize(key: "Please enter the 4 digit code we've sent to your phone no")) \(enterMobileNumber)".attributedStringWithColor(["\(enterMobileNumber)"], color: .DARKGREY)
        lblResendMobileOTP.attributedText = Localize(key: "Didn't receive the OTP? RESEND OTP").attributedStringWithColor(["RESEND OTP"], color: .DARKGREENTINT)
        
        lblVerifyEmailDetail.attributedText = "\(Localize(key: "Please enter the 4 digit code we've sent to your email id")) \(enterEmail)".attributedStringWithColor(["\(enterEmail)"], color: .DARKGREENTINT)
        lblResendEmailOTP.attributedText = Localize(key: "Didn't receive the OTP? RESEND OTP").attributedStringWithColor(["RESEND OTP"], color: .DARKGREENTINT)
        
        //--
        lblPhoneValidation.text = ""
        lblEmailValidation.text = ""
        
//        if isComeForAddingProofofAddress{
//            viewMainVerifyEmail.isHidden = true
//        }
    }
    func setOtpTextField()  {
        txtOtpEmail1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpEmail2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpEmail3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpEmail4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        txtOtpPhone1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpPhone2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpPhone3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtpPhone4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    func openAttemptAlert(){
        //--
        popover = Popover()
        viewbg_AttemptAlert.frame.size = CGSize(width: self.view.frame.width-20, height: viewbg_AttemptAlert.frame.height)
        let aView = UIView()
        aView.frame = viewbg_AttemptAlert.frame
        aView.addSubview(viewbg_AttemptAlert)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblVerifyMobile.text = Localize(key: "Verify Mobile")
        lblDidyouReceiveOtpNow_Mobile.text = Localize(key: "Did you receive the OTP now?")
        btnUndoSkip_Mobile.setTitle(Localize(key: "UNDO SKIP"), for: .normal)
        lblHavingIssueOTP_Mobile.text = Localize(key: "Having issues receiving the OTP?")
        btnYes_Mobile.setTitle(Localize(key: "Yes"), for: .normal)
        btnNo_Mobile.setTitle(Localize(key: "No"), for: .normal)
        btnSkipMobile_Mobile.setTitle(Localize(key: "SKIP MOBILE OTP"), for: .normal)
        
        lblVerifyEmail.text = Localize(key: "Verify Email")
        lblDidyouReceiveOtpNow_Email.text = Localize(key: "Did you receive the OTP now?")
        btnUndoSkip_Email.setTitle(Localize(key: "UNDO SKIP"), for: .normal)
        lblHavingIssueOTP_Email.text = Localize(key: "Having issues receiving the OTP?")
        btnYes_Email.setTitle(Localize(key: "Yes"), for: .normal)
        btnNo_Email.setTitle(Localize(key: "No"), for: .normal)
        btnSkipMobile_Email.setTitle(Localize(key: "SKIP EMAIL OTP"), for: .normal)
        
        lblTitle_AttemptAlert.text = Localize(key: "Sorry!")
        lblDetail_AttemptAlert.text = Localize(key: "You've entered an incorrect OTP 3 times in a row")
        btnBack_AttemptAlert.setTitle(Localize(key: "BACK"), for: .normal)
        btnContactbank_AttemptAlert.setTitle(Localize(key: "CONTACT BANK"), for: .normal)
        
        lblVerifyDetail.text = Localize(key: "VERIFY DETAILS")
        btnSkipMobile_Email.isHidden = true
        btnSkipMobile_Mobile.isHidden = true
    }
    
    //MARK: - Func Mobile Verification
    func startTimerResendPhoneOTP() {
        phoneResendOTPTime = 30
        timerResendPhoneOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerEventResendPhoneOTP(timer:)), userInfo: nil, repeats: true)
    }
    @objc func timerEventResendPhoneOTP(timer: Timer!) {
        if phoneResendOTPTime == 0{
            lblResendMobileOTP.attributedText = Localize(key: "Didn't receive the OTP? RESEND OTP").attributedStringWithColor(["RESEND OTP"], color: .DARKGREENTINT)
            timerResendPhoneOTP?.invalidate()
            timerResendPhoneOTP = nil
            btnResendMobileOTP.isUserInteractionEnabled = true
        }else{
            lblResendMobileOTP.attributedText = "\(Localize(key: "OTP has been resent.\nYou will be able to resend the OTP again in")) \(phoneResendOTPTime) \(Localize(key: "seconds"))".attributedStringWithColor([""], color: .DARKGREENTINT)
            btnResendMobileOTP.isUserInteractionEnabled = false
            phoneResendOTPTime = phoneResendOTPTime - 1
        }
    }
    //188 - Undo skip, 317 - Having issue, 211 - Default View
    func defaultUI_Mobile(){
        viewHavingIssuesMobile.isHidden = true
        viewHavingIssuesHeight.constant = 0
        viewUndoSkip_Mobile.isHidden = true
        viewOTPMobile.isHidden = false
    }
    func havingIssuesReceivingOtp_Mobile(){
        viewHavingIssuesMobile.isHidden = false
        viewHavingIssuesHeight.constant = 91
        viewUndoSkip_Mobile.isHidden = true
        viewOTPMobile.isHidden = false
    }
    func undoSkip_Mobile(){
        viewHavingIssuesMobile.isHidden = true
        viewHavingIssuesHeight.constant = 0
        viewUndoSkip_Mobile.isHidden = false
        viewOTPMobile.isHidden = true
    }

    func defaultUI_Email(){
        viewHavingIssuesEmail.isHidden = true
        viewHavingIssuesHeightEmail.constant = 0
        viewUndoSkip_Email.isHidden = true
        viewOTPEmail.isHidden = false
    }
    func havingIssuesReceivingOtp_Email(){
        viewHavingIssuesEmail.isHidden = false
        viewHavingIssuesHeightEmail.constant = 91
        viewUndoSkip_Email.isHidden = true
        viewOTPEmail.isHidden = false
    }
    func undoSkip_Email(){
        viewHavingIssuesEmail.isHidden = true
        viewHavingIssuesHeightEmail.constant = 0
        viewUndoSkip_Email.isHidden = false
        viewOTPEmail.isHidden = true
    }
    
    //MARK: - Func Email Verification
    func startTimerResendEmailOTP() {
        emailResendOTPTime = 30
        timerResendEmailOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerEventResendEmailOTP(timer:)), userInfo: nil, repeats: true)
    }
    @objc func timerEventResendEmailOTP(timer: Timer!) {
        if emailResendOTPTime == 0{
            lblResendEmailOTP.attributedText = Localize(key: "Didn't receive the OTP? RESEND OTP").attributedStringWithColor(["RESEND OTP"], color: .DARKGREENTINT)
            timerResendEmailOTP?.invalidate()
            timerResendEmailOTP = nil
            btnResendEmailOTP.isUserInteractionEnabled = true
        }else{
            lblResendEmailOTP.attributedText = "\(Localize(key: "OTP has been resent.\nYou will be able to resend the OTP again in")) \(phoneResendOTPTime) \(Localize(key: "seconds"))".attributedStringWithColor([""], color: .DARKGREENTINT)
            btnResendEmailOTP.isUserInteractionEnabled = false
            emailResendOTPTime = emailResendOTPTime - 1
        }
    }
    
    
    

    //MARK: @IBAction
    @IBAction func btnSkipMobile_Mobile(_ sender: Any) {
        undoSkip_Mobile()
    }
    @IBAction func btnNo_Mobile(_ sender: Any) {
        defaultUI_Mobile()
        btnSkipMobile_Email.isHidden = true
        setButtonColor(isSelected: true, btn: btnNo_Mobile)
        setButtonColor(isSelected: false, btn: btnYes_Mobile)
    }
    @IBAction func btnYes_Mobile(_ sender: Any) {
        btnSkipMobile_Mobile.isHidden = false
        setButtonColor(isSelected: true, btn: btnYes_Mobile)
        setButtonColor(isSelected: false, btn: btnNo_Mobile)
    }

    @IBAction func btnUndoSkip_Mobile(_ sender: Any) {
        defaultUI_Mobile()
    }
    @IBAction func btnResendPhoneOTP(_ sender: Any) {
        if totalPhoneResendOTPAttempt == 3{
            openAttemptAlert()
        }else{
            startTimerResendPhoneOTP()
            totalPhoneResendOTPAttempt = totalPhoneResendOTPAttempt + 1
            if totalPhoneResendOTPAttempt == 2{
                lblPhoneValidation.text = "You only have 1 attempt remaining"
            }else{
                lblPhoneValidation.text = ""
            }
            apiCall_resend_otpGeneration(isResendEmail: false)
        }
        havingIssuesReceivingOtp_Mobile()
    }
    @IBAction func btnSkipMobile_Email(_ sender: Any) {
        undoSkip_Email()
    }
    @IBAction func btnNo_Email(_ sender: Any) {
        defaultUI_Email()
        btnSkipMobile_Email.isHidden = true
        setButtonColor(isSelected: true, btn: btnNo_Email)
        setButtonColor(isSelected: false, btn: btnYes_Email)
    }
    @IBAction func btnYes_Email(_ sender: Any) {
        btnSkipMobile_Email.isHidden = false
        setButtonColor(isSelected: true, btn: btnYes_Email)
        setButtonColor(isSelected: false, btn: btnNo_Email)
    }
    @IBAction func btnUndoSkip_Email(_ sender: Any) {
        defaultUI_Email()
    }
    @IBAction func btnResendEmailOTP(_ sender: Any) {
        if totalEmailResendOTPAttempt == 3{
            openAttemptAlert()
        }else{
            startTimerResendEmailOTP()
            totalEmailResendOTPAttempt = totalEmailResendOTPAttempt + 1
            if totalEmailResendOTPAttempt == 2{
                lblEmailValidation.text = "You only have 1 attempt remaining"
            }else{
                lblEmailValidation.text = ""
            }
            apiCall_resend_otpGeneration(isResendEmail: true)
        }
        havingIssuesReceivingOtp_Email()
    }
    @IBAction func btnVerifyDetails(_ sender: Any) {
//        if isComeForAddingProofofAddress{
//            apiCall_ValidateOTP()
//        }else{
            apiCall_ValidateOTP()
        //}
        
    }
    
    @IBAction func txtEditingChange(_ sender: Any) {
        //validateEnput()
    }
    
    @IBAction func btnBack_AttemptAlert(_ sender: Any) {
        popover.dismiss()
    }
    @IBAction func btnContactbank_AttemptAlert(_ sender: Any) {
        popover.dismiss()
        
        //--
        let vc = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setButtonColor(isSelected: Bool, btn: UIButton){
        btn.setTitleColor(isSelected ? UIColor.white : UIColor.GREEN, for: .normal)
        btn.borderColor = isSelected ? UIColor.white : UIColor.GREEN
        btn.backgroundColor = isSelected ? UIColor.GREEN : UIColor.white
    }
}


extension VerifyMobileEmailOTPVC:UITextFieldDelegate{
    func validateEnput(){
        let phone_otp = "\(txtOtpPhone1.text ?? "")\(txtOtpPhone2.text ?? "")\(txtOtpPhone3.text ?? "")\(txtOtpPhone4.text ?? "")"
        let email_otp = "\(txtOtpEmail1.text ?? "")\(txtOtpEmail2.text ?? "")\(txtOtpEmail3.text ?? "")\(txtOtpEmail4.text ?? "")"
        
        /*if isComeForAddingProofofAddress{
            if (phone_otp.count) == 4{
                AppHelper.enableNextBTN(view_: viewbgbtnVerifyDetails)
            }else{
                AppHelper.disableNextBTN(view_: viewbgbtnVerifyDetails)
            }
        }else{*/
            if (phone_otp.count) == 4 && (email_otp.count) == 4{
                AppHelper.enableNextBTN(view_: viewbgbtnVerifyDetails)
            }else{
                AppHelper.disableNextBTN(view_: viewbgbtnVerifyDetails)
            }
        //}
        
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        validateEnput()
        //--
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtOtpEmail1:
                txtOtpEmail2.becomeFirstResponder()
            case txtOtpEmail2:
                txtOtpEmail3.becomeFirstResponder()
            case txtOtpEmail3:
                txtOtpEmail4.becomeFirstResponder()
            case txtOtpEmail4:
                txtOtpEmail4.resignFirstResponder()
                
            case txtOtpPhone1:
                txtOtpPhone2.becomeFirstResponder()
            case txtOtpPhone2:
                txtOtpPhone3.becomeFirstResponder()
            case txtOtpPhone3:
                txtOtpPhone4.becomeFirstResponder()
            case txtOtpPhone4:
                txtOtpPhone4.resignFirstResponder()
            default:
                break
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count ?? 0) >= 1) && (string.count > 0) {
            switch textField{
            case txtOtpEmail1:
                txtOtpEmail2.becomeFirstResponder()
            case txtOtpEmail2:
                txtOtpEmail3.becomeFirstResponder()
            case txtOtpEmail3:
                txtOtpEmail4.becomeFirstResponder()
            case txtOtpEmail4:
                txtOtpEmail4.resignFirstResponder()
                
            case txtOtpPhone1:
                txtOtpPhone2.becomeFirstResponder()
            case txtOtpPhone2:
                txtOtpPhone3.becomeFirstResponder()
            case txtOtpPhone3:
                txtOtpPhone4.becomeFirstResponder()
            case txtOtpPhone4:
                txtOtpPhone4.resignFirstResponder()
            default:
                break
            }
            return false
        }
        
        return true
    }
    
}

//MARK: - Api Call
extension VerifyMobileEmailOTPVC{
    
    func apiCall_ValidateOTP()  {
        let mobile_otp = "\(txtOtpPhone1.text!)\(txtOtpPhone2.text!)\(txtOtpPhone3.text!)\(txtOtpPhone4.text!)"
        let email_otp = "\(txtOtpEmail1.text!)\(txtOtpEmail2.text!)\(txtOtpEmail3.text!)\(txtOtpEmail4.text!)"
        let verification_type = "both"
        /*if isComeForAddingProofofAddress{
            verification_type = "mobile"
        }else{
            verification_type = "both"
        }*/
        
        //--
        let dicParam:[String:AnyObject] = ["operation":"validateOTP" as AnyObject,
                                           "data":["mobile_key":"Q66P4XNHE4LPK4MO",
                                                   "email_key":"RUFHV4RY265PXFQU",
                                                   "mobile_otp":mobile_otp,
                                                   "email_otp":email_otp,
                                                   "step":validateOTPStep,
                                                   "mobile_number":"\(enterMobileNumber)",
                                                   "email":"\(enterEmail)",
                                                   "verification_type":verification_type,
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let validateOTPModel = ValidateOTPModel(JSON: response as! [String : Any])!
            
            //
            if serviceType == .ResumeAccountOpening{
                if validateOTPModel.Response?.Body?.email_message?.status == "Success" && validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ResumeAccountOpening)
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ResumeAccountOpening)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .StartAccountOpening{
                if validateOTPModel.Response?.Body?.email_message?.status == "Success" && validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showNewAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "")
                    }else{
                        showNewAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "")
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .ScheduleVideoCall{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ScheduleVideoCall)
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ScheduleVideoCall)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .CheckApplicationStatus{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showCheckStatusAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "")
                    }else{
                        showCheckStatusAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "")
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .AddOnServices{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .AddOnServices)
                        
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .AddOnServices)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .ProofOfAddress{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ProofOfAddress)
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .ProofOfAddress)
                        
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .HighRiskCustomer{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!, detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .HighRiskCustomer)
                        
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .HighRiskCustomer)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .VeryHighRiskCustomer{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!,detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .VeryHighRiskCustomer)
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType:  .VeryHighRiskCustomer)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
            }else if serviceType == .StartVideoCall{
                if validateOTPModel.Response?.Body?.mobile_message?.status == "Success"{
                    //--
                    let applicationsArrObj = validateOTPModel.Response?.Body?.Result?.applications
                    if applicationsArrObj?.count != 0{
                        if let mobileApiModel_ = applicationsArrObj?.first?.toJSONString(){
                            Login_LocalDB.saveApplicationsInfo(strData: mobileApiModel_)
                        }
                        
                        showResumeAppAlert(validateOTPApplications: (applicationsArrObj?.first!)!,detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType: .StartVideoCall)
                    }else{
                        showResumeAppAlert(detail: validateOTPModel.Response?.Body?.statusMsg ?? "", serviceType:  .StartVideoCall)
                    }
                }else{
                    self.view.makeToast(validateOTPModel.Response?.Body?.email_message?.statusMsg)
                }
                
            }else{
                
            }
      

        }) { (error) in
            print(error)
        }
    }

    func showCheckStatusAppAlert(validateOTPApplications: ValidateOTPApplications? = nil, detail: String){
        let status = validateOTPApplications?.status ?? ""
        //--
        popover = Popover()
        let alert = InProgressAppAlertView.instanceFromNib()
        //--
        alert.lblTitle.text = "Alert!"
        alert.lblMessage.text = detail
        
        if status == ApplicationStatus.New.rawValue{
            //--
            let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }else if status == ApplicationStatus.InProgress.rawValue ||
                    status == ApplicationStatus.submitted_to_compliance.rawValue ||
                    status == ApplicationStatus.submitted_to_headofbranches.rawValue ||
                    status == ApplicationStatus.submitted_to_headofretail.rawValue{
            
            //--navigate to check application status screen
            let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
            vc.validateOTPApplications = validateOTPApplications
            self.navigationController?.pushViewController(vc, animated: true)
            return
            
        }else if status == ApplicationStatus.application_submitted.rawValue ||
                    status == ApplicationStatus.Account_Created.rawValue {
            //--navigate to check application status screen
            let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
            vc.validateOTPApplications = validateOTPApplications
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }else if status == ApplicationStatus.Rejected.rawValue{
            alert.btnContinueApplication.setTitle("CONTACT BANK", for: .normal)
            alert.didTappedContinueAPP = { (sender) in
                //--
                self.popover.dismiss()
                self.openAttemptAlert()
            }
            
            alert.btnCancel.setTitle("CHECK STATUS", for: .normal)
            alert.didTappedCancel = { (sender) in
                //--
                self.popover.dismiss()
                
                //--navigate to check application status screen
                let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
                vc.validateOTPApplications = validateOTPApplications
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            alert.lblMessage.text = status == "" ? "No application found with this mobile number, submit a request to open an account." : detail
            alert.btnGotoApplication.isHidden = true
            alert.btnContinueApplication.isHidden = true
            alert.btnContinueApplication.setTitle("GOT IT", for: .normal)
        }
        
        showAlert(alert: alert, status: status)
    }
    func showResumeAppAlert(validateOTPApplications: ValidateOTPApplications? = nil, detail: String, serviceType: ServiceType){
        let status = validateOTPApplications?.status ?? ""
        //--
        popover = Popover()
        let alert = InProgressAppAlertView.instanceFromNib()
        //--
        alert.lblTitle.text = "Alert!"
        alert.lblMessage.text = detail
        
        if status == ApplicationStatus.New.rawValue{
            if serviceType == .ResumeAccountOpening{
                //--
                let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .ScheduleVideoCall{
                //--
                let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .AddOnServices{
                //--
                let vc = AddonServicesVC(nibName: "AddonServicesVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .ProofOfAddress{
                //--
                let vc = ProofofAddressVC(nibName: "ProofofAddressVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .HighRiskCustomer{
                //--
                let vc = HighCustomerVC(nibName: "HighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .VeryHighRiskCustomer{
                //--
                let vc = VeryHighCustomerVC(nibName: "VeryHighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if serviceType == .StartVideoCall{
                //--
                let vc = VideoCallVC(nibName: "VideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return
        }else if status == ApplicationStatus.InProgress.rawValue{
            if serviceType == .ResumeAccountOpening{
                alert.btnContinueApplication.setTitle("CONTINUE", for: .normal)
                alert.didTappedContinueAPP = { (sender) in
                    
                    self.findLastApplicationStep()
                }
            }else if serviceType == .ScheduleVideoCall{
                //--
                let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .AddOnServices{
                //--
                let vc = AddonServicesVC(nibName: "AddonServicesVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .ProofOfAddress{
                //--
                let vc = ProofofAddressVC(nibName: "ProofofAddressVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .HighRiskCustomer{
                //--
                let vc = HighCustomerVC(nibName: "HighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .VeryHighRiskCustomer{
                //--
                let vc = VeryHighCustomerVC(nibName: "VeryHighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .StartVideoCall{
                //--
                let vc = VideoCallVC(nibName: "VideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }else if status == ApplicationStatus.application_submitted.rawValue ||
                    status == ApplicationStatus.Account_Created.rawValue ||
                    status == ApplicationStatus.submitted_to_compliance.rawValue ||
                    status == ApplicationStatus.submitted_to_headofbranches.rawValue ||
                    status == ApplicationStatus.submitted_to_headofretail.rawValue{
            if serviceType == .ResumeAccountOpening{
                alert.btnContinueApplication.setTitle("CHECK STATUS", for: .normal)
                alert.didTappedContinueAPP = { (sender) in
                    //--
                    self.popover.dismiss()
                    
                    //--navigate to check application status screen
                    let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
                    vc.validateOTPApplications = validateOTPApplications
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if serviceType == .ScheduleVideoCall{
                //--
                let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .AddOnServices{
                //--
                let vc = AddonServicesVC(nibName: "AddonServicesVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .ProofOfAddress{
                //--
                let vc = ProofofAddressVC(nibName: "ProofofAddressVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .HighRiskCustomer{
                //--
                let vc = HighCustomerVC(nibName: "HighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .VeryHighRiskCustomer{
                //--
                let vc = VeryHighCustomerVC(nibName: "VeryHighCustomerVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }else if serviceType == .StartVideoCall{
                //--
                let vc = VideoCallVC(nibName: "VideoCallVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
        }else if status == ApplicationStatus.Rejected.rawValue{
            alert.btnContinueApplication.setTitle("CONTACT BANK", for: .normal)
            alert.didTappedContinueAPP = { (sender) in
                //--
                self.popover.dismiss()
                self.openAttemptAlert()
            }
            
            alert.btnCancel.setTitle("CHECK STATUS", for: .normal)
            alert.didTappedCancel = { (sender) in
                //--
                self.popover.dismiss()
                
                //--navigate to check application status screen
                let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
                vc.validateOTPApplications = validateOTPApplications
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            alert.lblMessage.text = status == "" ? "No application found with this mobile number, submit a request to open an account." : detail
            alert.btnGotoApplication.isHidden = true
            alert.btnContinueApplication.isHidden = true
            alert.btnContinueApplication.setTitle("GOT IT", for: .normal)
        }
        
        showAlert(alert: alert, status: status)
    }
    func showNewAppAlert(validateOTPApplications: ValidateOTPApplications? = nil, detail: String){
        let status = validateOTPApplications?.status ?? ""
        //--
        popover = Popover()
        let alert = InProgressAppAlertView.instanceFromNib()
        //--
        alert.lblTitle.text = "Alert!"
        alert.lblMessage.text = detail
        
        if status == ApplicationStatus.New.rawValue{
            //--
            let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }else if status == ApplicationStatus.InProgress.rawValue{
            alert.btnContinueApplication.setTitle("CONTINUE", for: .normal)
            alert.didTappedContinueAPP = { (sender) in
                self.findLastApplicationStep()
            }
        }else if status == ApplicationStatus.application_submitted.rawValue ||
                    status == ApplicationStatus.Account_Created.rawValue ||
                    status == ApplicationStatus.submitted_to_compliance.rawValue ||
                    status == ApplicationStatus.submitted_to_headofbranches.rawValue ||
                    status == ApplicationStatus.submitted_to_headofretail.rawValue{
            alert.btnContinueApplication.setTitle("CHECK STATUS", for: .normal)
            alert.didTappedContinueAPP = { (sender) in
                //--
                self.popover.dismiss()
                
                //--navigate to check application status screen
                let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
                vc.validateOTPApplications = validateOTPApplications
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if status == ApplicationStatus.Rejected.rawValue{
            alert.btnContinueApplication.setTitle("CONTACT BANK", for: .normal)
            alert.didTappedContinueAPP = { (sender) in
                //--
                self.popover.dismiss()
                self.openAttemptAlert()
            }
            
            alert.btnCancel.setTitle("CHECK STATUS", for: .normal)
            alert.didTappedCancel = { (sender) in
                //--
                self.popover.dismiss()
                
                //--navigate to check application status screen
                let vc = ApplicationStatusVC(nibName: "ApplicationStatusVC", bundle: nil)
                vc.validateOTPApplications = validateOTPApplications
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            alert.lblMessage.text = status == "" ? "No application found with this mobile number, submit a request to open an account." : detail
            alert.btnGotoApplication.isHidden = true
            alert.btnContinueApplication.isHidden = true
            alert.btnContinueApplication.setTitle("GOT IT", for: .normal)
        }
        
        showAlert(alert: alert, status: status)
    }
    func showAlert(alert: InProgressAppAlertView, status:String){
        //--
        alert.frame.size = CGSize(width: UIScreen.main.bounds.width-30, height: alert.viewBG.frame.height)
        let aView = UIView()
        aView.frame = alert.frame
        aView.addSubview(alert)
        popover.dismissOnBlackOverlayTap = false
        popover.showAsDialog(alert, inView: self.view)
        
        alert.didTappedGoToDashboard = { (sender) in
            //--
            let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if status != ApplicationStatus.Rejected.rawValue{
            alert.didTappedCancel = { (sender) in
                self.popover.dismiss()
            }
        }
    }
    
    

    
    func apiCall_resend_otpGeneration(isResendEmail: Bool)  {
        //--
        var verification_type = "both"
    
        
        //--
        var key = ""
        var value = ""
        if isResendEmail{
            key = "email"
            value = enterEmail
        }else{
            key = "mobile_number"
            value = enterMobileNumber
        }
        let dicParam:[String:AnyObject] = ["operation":"otpGeneration" as AnyObject,
                                           "data":[key: value,
                                                   "verification_type":verification_type,
                                                   "mobile_key":"Q66P4XNHE4LPK4MO",
                                                   "email_key":"RUFHV4RY265PXFQU",
                                                   "step":"otp_screen",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "001"{
                
            }else{
                self.view.makeToast(oTPGenerationModel.message)
            }
        }) { (error) in
            print(error)
        }
    }
}

extension UIViewController{
    func findLastApplicationStep(){
        LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getApplicationData { result in
            LoadingView.shared.dismissLoadingView()
            if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.personalInfoScreen.rawValue{
                //--
                let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
                vc.citizenshipType = self.returnCitizenship(citizenship: result.citizenship_c as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.financialInfoScreen.rawValue{
                //--
                let vc = FinancialInfoVC(nibName: "FinancialInfoVC", bundle: nil)
                vc.citizenshipType = self.returnCitizenship(citizenship: result.citizenship_c as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.regularityDeclarationScreen.rawValue{
                //--
                let vc = RegularityDeclVC(nibName: "RegularityDeclVC", bundle: nil)
                vc.citizenshipType = self.returnCitizenship(citizenship: result.citizenship_c as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.highRiskCustomerScreen.rawValue{
                //--
                let vc = HighCustomerVC(nibName: "HighCustomerVC", bundle: nil)
                vc.citizenshipType = self.returnCitizenship(citizenship: result.citizenship_c as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.veryHighRiskCustomerScreen.rawValue{
                //--
                let vc = VeryHighCustomerVC(nibName: "VeryHighCustomerVC", bundle: nil)
                vc.citizenshipType = self.returnCitizenship(citizenship: result.citizenship_c as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.app_current_step_c as? String ?? "")" == STEPS_FRONT_END_NAME.termsAndConditionsScreen.rawValue{
                //--
                let vc = TermsConditionsVC(nibName: "TermsConditionsVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.citizenship_c as? String ?? "")" == CitizenshipType.omani.rawValue{
                //--
                let vc = OmaniCitizenshipDocVC(nibName: "OmaniCitizenshipDocVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.citizenship_c as? String ?? "")" == CitizenshipType.expatriate.rawValue{
                //--
                let vc = ExpatrIateCitizenshipDoc(nibName: "ExpatrIateCitizenshipDoc", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if "\(result.citizenship_c as? String ?? "")" == CitizenshipType.gcc.rawValue{
                //--
                let vc = GCCNationalsCitizenshipDocVC(nibName: "GCCNationalsCitizenshipDocVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                //--
                let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func returnCitizenship(citizenship: String) -> CitizenshipType{
        if citizenship == CitizenshipType.omani.rawValue{
            return .omani
        }else if citizenship == CitizenshipType.expatriate.rawValue{
            return .expatriate
        }else{
            return .gcc
        }
    }
}
