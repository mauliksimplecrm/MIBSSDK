//
//  OmaniCitizenshipDocVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 24/01/22.
//

import UIKit
//import IDCardCamera
import Lightbox
import MBDocCapture
import Popover
import Alamofire


class OmaniCitizenshipDocVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblScanOmaniNationalID_title: UILabel!
    @IBOutlet weak var btnViewScannedImage: UIButton!
    @IBOutlet weak var viewbg_fronImg: UIView!
    @IBOutlet weak var imgFrontImg: UIImageView!
    @IBOutlet weak var lblFront_title: UILabel!
    @IBOutlet weak var viewbg_backImg: UIView!
    @IBOutlet weak var imgBackImg: UIImageView!
    @IBOutlet weak var lblBvack_title: UILabel!
    @IBOutlet weak var viewbg_btnNext: UIView!
    @IBOutlet weak var lblNext_title: UILabel!
    @IBOutlet weak var imgScanDone: UIImageView!
    
    @IBOutlet var viewbgMain_ErrorAlert: UIView!
    @IBOutlet weak var viewbgInner_ErrorAlert: UIView!
    @IBOutlet weak var lblTitle_ErrorAlert: UILabel!
    @IBOutlet weak var lblDetail_ErrorAlert: UILabel!
    @IBOutlet weak var btnCancel_ErrorAlert: UIButton!
    @IBOutlet weak var btnContactBank_ErrorAlert: UIButton!
    
    //MARK: Veriable
    var selectFrontImg = false
    var selectBackImg = false
    var scanedIDCount = 0
    
    var delegate_didTakeCustomPhoto: didTakeCustomPhoto_protocol?
    var popover = Popover()
    var scanFrontDocData: ValidateOmniData?
    var scanBackDocData: ValidateOmniData?
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupBasic()
        localization()
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblTitle.text = Localize(key: "Omani")
        lblDetail.text = Localize(key: "Please scan and upload your Omani national ID")
        
        lblScanOmaniNationalID_title.text = Localize(key: "Scan Omani National ID")
        lblFront_title.text = Localize(key: "Front")
        lblBvack_title.text = Localize(key: "Back")
        
        lblNext_title.text = Localize(key: "NEXT")
        btnCancel_ErrorAlert.setTitle(Localize(key: "CANCEL"), for: .normal)
        btnContactBank_ErrorAlert.setTitle(Localize(key: "CONTACT BANK"), for: .normal)
        
    }
    
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.btnScheduleaCall.setTitle(Localize(key: "Schedule a Call"), for: .normal)
        headerView.didTappedBack = { (sender) in
            //--
            let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    func setupBasic(){
        if applyValidation{
            AppHelper.disableNextBTN(view_: viewbg_btnNext)
        }
        btnViewScannedImage.isHidden = true
        hiddenFrontBackImg()
        
        getDocumentsList()
        
    }
    func validateEnput(){
        if selectFrontImg == true && selectBackImg == true{
            AppHelper.enableNextBTN(view_: viewbg_btnNext)
            btnViewScannedImage.isHidden = false
        }else{
            AppHelper.disableNextBTN(view_: viewbg_btnNext)
            btnViewScannedImage.isHidden = true
        }
    }
    func hiddenFrontBackImg(){
        viewbg_fronImg.isHidden = true
        viewbg_backImg.isHidden = true
        btnViewScannedImage.setTitle(Localize(key: "VIEW SCANNED IMAGES"), for: .normal)
    }
    func showFrontBackImg(){
        viewbg_fronImg.isHidden = false
        viewbg_backImg.isHidden = false
        btnViewScannedImage.setTitle(Localize(key: "HIDE SCANNED IMAGES"), for: .normal)
    }
    
    func setupLightBoxImageArray(imgOpen:UIImage, msg: String){
        //--
        var images_LightBox:[LightboxImage] = []
        images_LightBox.append(LightboxImage(image: imgOpen, text: msg))
        
        //--
        let controller = LightboxController(images: images_LightBox)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: @IBAction
    @IBAction func btnCancel_ErrorAlert(_ sender: Any) {
        popover.dismiss()
        //openErrorAlert(title: "Sorry!", details: "We're not able to process your request right now. please contact our customer support.")
    }
    @IBAction func btnContactBank_ErrorAlert(_ sender: Any) {
        popover.dismiss()
        //--
        let vc = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnScanOManiNationalID(_ sender: Any) {
        scanedIDCount = 1
        scanIDCard(title: Localize(key: "Scan the front side of your National ID"))
    }
    @IBAction func btnViewScannedImage(_ sender: Any) {
        if viewbg_fronImg.isHidden{
            showFrontBackImg()
        }else{
            hiddenFrontBackImg()
        }
    }
    
    @IBAction func btnViewFrontImg(_ sender: Any) {
        if let img_ = imgFrontImg.image{
            setupLightBoxImageArray(imgOpen: img_, msg: Localize(key: "National ID - Front"))
        }
    }
    @IBAction func btnViewBackImg(_ sender: Any) {
        if let img_ = imgBackImg.image{
            setupLightBoxImageArray(imgOpen: img_, msg: Localize(key: "National ID - Back"))
        }
    }
    @IBAction func btnNext(_ sender: Any) {
        //--
        apiCall_updateApplication()
    }
    
    func scanIDCard(title: String) {
        // Set the scan settings
        // In this example the aspect ratio is that of a typical credit card
        // The width and height units are not important
        //let settings = CardDetectionSettings(width: 85.6, height: 53.98)
        
        // Create the view controller
        let controller = CardDetectionViewController()
        
        // Set the delegate that will receive the result
        controller.delegate = self
        let lbl = UILabel(frame: CGRect(x: 0, y: 50, width: 320, height: 0))
        lbl.text = ""
        controller.view.addSubview(lbl)
        controller.lbltrmp.text = title
        // Present the card detection view controller
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
}

//MARK:- Show Alerts
extension OmaniCitizenshipDocVC{
    
    func openErrorAlert(title: String, details: String){
        //--
        lblTitle_ErrorAlert.text = title
        lblDetail_ErrorAlert.text = details
        
        //--
        popover = Popover()
        viewbgMain_ErrorAlert.frame.size = CGSize(width: UIScreen.main.bounds.width-30, height: viewbgInner_ErrorAlert.frame.height)
        let aView = UIView()
        aView.frame = viewbgMain_ErrorAlert.frame
        aView.addSubview(viewbgMain_ErrorAlert)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    
}

/*
 extension OmaniCitizenshipDocVC: LoadingView_Protocol{
 func btnCancelLoding(){
 popover.dismiss()
 openErrorAlert(title: Localize(key: "Unfortunately your country is not supported"), details: "")
 }
 }
 */
extension OmaniCitizenshipDocVC: CardDetectionViewControllerDelegate{
    func cardDetectionViewController(_ viewController: CardDetectionViewController, didDetectCard image: CGImage, withSettings settings: CardDetectionSettings) {
        // The card has been scanned
        // Display the image in the image view
        if scanedIDCount == 1{
            selectFrontImg = true
            imgFrontImg.image = UIImage(cgImage: image)
            
            scanedIDCount = 2
            scanIDCard(title: Localize(key: "Scan the back side of your National ID"))
            
            validateEnput()
        }else if scanedIDCount == 2{
            scanedIDCount = 0
            
            selectBackImg = true
            imgBackImg.image = UIImage(cgImage: image)
            
            btnViewScannedImage.isHidden = false
            imgScanDone.image = UIImage(named: "ic_fill_correct_green")
            showFrontBackImg()
            
            validateEnput()
        }
        
    }
}




extension OmaniCitizenshipDocVC: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate{
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
}

//MARK: - Api Call
extension OmaniCitizenshipDocVC{
    func getDocumentsList(){
        //LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getDocumentsList (showProgress: true){ [self] docResult in
            //LoadingView.shared.dismissLoadingView()
            
            docResult.documents.forEach { getDocumentsListDocuments in
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.national.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        selectFrontImg = true
                        imgFrontImg.setImage(url: url)
                        validateEnput()
                    }
                }
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.national.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.rear)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        selectBackImg = true
                        imgBackImg.setImage(url: url)
                        validateEnput()
                        imgScanDone.image = UIImage(named: "ic_fill_correct_green")
                    }
                }
            }
        }
    }
    
    func apiCall_updateApplication()  {
        LoadingView.shared.openLodingAlert(view: self.view)
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.selectDocumentTypeScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["citizenship_c": CitizenshipType.omani.rawValue,
                                                                 "application_status_c": ApplicationStatus.InProgress.rawValue,
                                                                 "id_type_c":"1"
                                                                ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: false, completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    //--
                    apiCall_UploadImage(isFront: true)
                }else{
                    LoadingView.shared.dismissLoadingView()
                    self.view.makeToast(oTPGenerationModel.Response?.Body?.statusMsg ?? "")
                }
            }else{
                LoadingView.shared.dismissLoadingView()
                self.view.makeToast(oTPGenerationModel.message)
            }
        }) { (error) in
            print(error)
            LoadingView.shared.dismissLoadingView()
        }
    }
    func apiCall_UploadImage(isFront: Bool)  {
        //--
        //if isFront{
        //self.openLodingAlert()
        //}
        let docBase64 = isFront ? imgFrontImg.image?.convertImageToBase64String() : imgBackImg.image?.convertImageToBase64String()
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.national.getValue(),
                                                   "view_type":isFront ? viewType.front.getValue() : viewType.rear.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.selectDocumentTypeScreen)(),
                                                   "document_base64":docBase64 ?? "",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: false, completion: { [self] (response) in
            print(response as Any)
            let validateOTPModel = OmniResponseModel(JSON: response as! [String : Any])!
            if validateOTPModel.Response?.Body?.status == "Success"{
                if validateOTPModel.Response?.Body?.Result?.data?.valid == 1{
                    //--
                    if !isFront{
                        LoadingView.shared.dismissLoadingView()
                        self.scanBackDocData = validateOTPModel.Response?.Body?.Result?.data
                        //self.apiCall_ValildateDoc()
                        //--
                        let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
                        vc.scanFrontDocData = scanFrontDocData
                        vc.scanBackDocData = scanBackDocData
                        vc.citizenshipType = CitizenshipType.omani
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if isFront{
                        //--
                        self.scanFrontDocData = validateOTPModel.Response?.Body?.Result?.data
                        
                        //-- Check DOB valid
                        let yearAgo = AppHelper.stringToDate(strDate: self.scanFrontDocData?.date_of_birth ?? "", strFormate: "dd/MM/yyyy").getYearAgo()
                        if yearAgo >= 18{
                            //--
                            self.apiCall_UploadImage(isFront: false)
                        }else{
                            //--
                            LoadingView.shared.dismissLoadingView()
                            openErrorAlert(title: "Error", details: "You should be greater than 18 to create account")
                        }
                    }
                }else{
                    LoadingView.shared.dismissLoadingView()
                    self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
                }
            }else{
                LoadingView.shared.dismissLoadingView()
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response == "" ? validateOTPModel.message : validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
            
        }) { (error) in
            print(error)
            LoadingView.shared.dismissLoadingView()
        }
    }

}
