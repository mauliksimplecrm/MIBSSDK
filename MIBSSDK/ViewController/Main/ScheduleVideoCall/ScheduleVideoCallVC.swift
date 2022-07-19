//
//  ScheduleVideoCallVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 26/01/22.
//

import UIKit

class ScheduleVideoCallVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblSelectedDate_title: UILabel!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var viewbg_selectDate: UIView!
    @IBOutlet weak var lblSelectDate_title: UILabel!
    @IBOutlet weak var lblSelectTime: UILabel!
    @IBOutlet weak var viewbgSelectTime: UIView!
    @IBOutlet weak var lblSelectedTime_title: UILabel!
    @IBOutlet weak var lblSelectTime_title: UILabel!
    @IBOutlet weak var txtAddNote: UIFloatingTextField!
    @IBOutlet weak var lblBtnScheduleCall: UILabel!
    @IBOutlet weak var viewbgBtnScheduleCall: UIView!
    
    //MARK: Veriable
    var selectDateValidation = false
    var selectTimeValidation = false
    var isComeFromLivenessCheck = false
    var isComeFromVeryHighRisk = false
    
    var selectTimeSlotIndex = -1
    var selectDateBackendValue = ""
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        setupBasic()
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitle.attributedText = Localize(key: "Schedule Video Call").attributedStringWithColor(["Video Call"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Schedule Video Call Detail")
        
        lblSelectedDate_title.text = Localize(key: "Select Date")
        lblSelectDate_title.text = Localize(key: "Select Date")
        lblSelectedTime_title.text = Localize(key: "Select Time")
        lblSelectTime_title.text = Localize(key: "Select Time")
        
        lblBtnScheduleCall.text = Localize(key: "SCHEDULE CALL")
        
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        headerView.nav = self.navigationController!
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupBasic(){
        if applyValidation{
            AppHelper.disableNextBTN(view_: viewbgBtnScheduleCall)
        }
        
        //--
        
        txtAddNote.setICON(hidden: true)
        txtAddNote.setTitlePlaceholder(text_: Localize(key: "Add a note"), placeholder_: Localize(key: "How can we help you?"), isUserInteraction: true)
        
      
    }

    func validateEnput(){
        if selectDateValidation && selectTimeValidation{
            AppHelper.enableNextBTN(view_: viewbgBtnScheduleCall)
        }else{
            AppHelper.disableNextBTN(view_: viewbgBtnScheduleCall)
        }
    }

    //MARK: @IBAction
    @IBAction func btnSelectDate(_ sender: Any) {
        //--
        let vc = SelectDateVC(nibName: "SelectDateVC", bundle: nil)
        vc.delegate_didSelectDate_Protocol = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnSelectTime(_ sender: Any) {
        //--
        let vc = SelectTimeVC(nibName: "SelectTimeVC", bundle: nil)
        vc.delegate_didSelectTimeSlot_Protocol = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnScheduleCall(_ sender: Any) {
        apiCall_updateApplication()
//        if isComeFromLivenessCheck{
//            //--
//            let vc = RequestSentLivenesscheckVC(nibName: "RequestSentLivenesscheckVC", bundle: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else if isComeFromVeryHighRisk{
//            //--
//            let vc = ThankYouVC(nibName: "ThankYouVC", bundle: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            apiCall_updateApplication()
//        }
        
    }
    

}

extension ScheduleVideoCallVC: didSelectDate_Protocol{
    func didSelectDate(selectDate: String) {
        lblSelectDate.text = selectDate
        viewbg_selectDate.isHidden = true
        selectDateValidation = true
        validateEnput()
        selectDateBackendValue = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "EEEE, dd/MM/yyyy", dateNewFTR: "yyyy-MM-dd", strDate: selectDate)
    }
}

extension ScheduleVideoCallVC: didSelectTimeSlot_Protocol{
    func didSelectTimeSlot(timeSlot: String, index: Int) {
        lblSelectTime.text = timeSlot
        viewbgSelectTime.isHidden = true
        selectTimeValidation = true
        validateEnput()
        selectTimeSlotIndex = index
    }
}

//MARK: - Api Call
extension ScheduleVideoCallVC{

    func apiCall_updateApplication()  {
        //--
        let contact_time_preference_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .contact_time_preference_c, index: selectTimeSlotIndex)
        
        var crm_data:[String:AnyObject] = ["contact_time_preference_c": contact_time_preference_c,
                                           "contact_date_preference_c": selectDateBackendValue,
                                           "description":txtAddNote.txtType.text!
                                           ] as [String:AnyObject]
        if isComeFromLivenessCheck{
            crm_data["step"] = STEPS_FRONT_END_NAME.getValue(.termsAndConditionsScreen)() as AnyObject
        }
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "device_info": deviceInfo,
                                                    "crm_data": crm_data
                                                   ] as AnyObject]
        
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    if isComeFromLivenessCheck{
                        //--
                        let vc = RequestSentLivenesscheckVC(nibName: "RequestSentLivenesscheckVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if isComeFromVeryHighRisk{
                        //--
                        let vc = ThankYouVC(nibName: "ThankYouVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        //--
                        let vc = ThankYouScheduleVideoCallVC(nibName: "ThankYouScheduleVideoCallVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }else{
                    self.view.makeToast(oTPGenerationModel.Response?.Body?.statusMsg ?? "")
                }
            }else{
                self.view.makeToast(oTPGenerationModel.message)
            }
        }) { (error) in
            print(error)
        }
    }
}
