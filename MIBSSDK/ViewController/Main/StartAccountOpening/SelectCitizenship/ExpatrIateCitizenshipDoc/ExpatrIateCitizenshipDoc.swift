//
//  ExpatrIateCitizenshipDoc.swift
//  Maisarah
//
//  Created by Maulik Vora on 25/01/22.
//

import UIKit
import Lightbox
import MBDocCapture
import Popover

class ExpatrIateCitizenshipDoc: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var viewbgbtnNext: UIView!
    @IBOutlet weak var lblUploadFileSize_visa: UILabel!
    @IBOutlet weak var lblUploadFileName_visa: UILabel!
    @IBOutlet weak var imgUploadDocDone: UIImageView!
    @IBOutlet weak var viewbg_passport_height: NSLayoutConstraint!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblResidentID_title: UILabel!
    @IBOutlet weak var lblScanResidentID: UILabel!
    @IBOutlet weak var imgScanResidentID_done: UIImageView!
    @IBOutlet weak var btnViewScannedImg_residentID: UIButton!
    @IBOutlet weak var lblFront_ResidentId: UILabel!
    @IBOutlet weak var imgViewResidentId: UIImageView!
    @IBOutlet weak var viewbg_view_residentid: UIView!
    @IBOutlet weak var viewbgResidentID_height: NSLayoutConstraint!
    
    @IBOutlet weak var viewbgF_ResidentID: UIView!
    @IBOutlet weak var viewbgB_ResidentID: UIView!
    @IBOutlet weak var imgback_ResidentId: UIImageView!
    @IBOutlet weak var lblBack_ResidentID: UILabel!
    @IBOutlet weak var lblPassport_title: UILabel!
    @IBOutlet weak var lblScanPassport_title: UILabel!
    
    @IBOutlet weak var viewbgViewZ_passport: UIView!
    @IBOutlet weak var btnViewScanImg_passport: UIButton!
    @IBOutlet weak var viewbgFimg_passport: UIView!
    @IBOutlet weak var imgF_passport: UIImageView!
    @IBOutlet weak var lblFront_passport: UILabel!
    @IBOutlet weak var imgScanImgDone_passport: UIImageView!
    
    @IBOutlet var viewbgMain_ErrorAlert: UIView!
    @IBOutlet weak var viewbgInner_ErrorAlert: UIView!
    @IBOutlet weak var lblTitle_ErrorAlert: UILabel!
    @IBOutlet weak var lblDetail_ErrorAlert: UILabel!
    @IBOutlet weak var btnCancel_ErrorAlert: UIButton!
    @IBOutlet weak var btnContactBank_ErrorAlert: UIButton!
    @IBOutlet weak var lblValidVisa_title: UILabel!
    @IBOutlet weak var lblUploadValidVisaCopy: UILabel!
    
    
    //MARK: Veriable
    var delegate_didTakeCustomPhoto: didTakeCustomPhoto_protocol?
    var selectFrontImg_ResidentID = false
    var selectBackImg_ResidentID = false
    var selectImg_Passport = false
    var selectVisaDoc = false
    var scanedIDCount = 0
    var selectVisaImag = UIImageView()
    var popover = Popover()
    var scanPasswordData: ValidateOmniData?
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
        
        lblTitle.text = Localize(key: "Expatriate")
        lblDetail.text = Localize(key: "Please scan and upload the following documents")
        
        lblResidentID_title.text = Localize(key: "Resident ID")
        lblScanResidentID.text = Localize(key: "Scan Resident ID")
        lblPassport_title.text = Localize(key: "Passport")
        lblScanPassport_title.text = Localize(key: "Scan Passport")
        lblValidVisa_title.text = Localize(key: "Valid Visa")
        lblUploadValidVisaCopy.text = Localize(key: "Upload Valid visa copy")
        
        lblNext.text = Localize(key: "NEXT")
        
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
            AppHelper.disableNextBTN(view_: viewbgbtnNext)
        }
        hiddenScanedResident()
        hiddenScanedPassport()
        lblUploadFileName_visa.text = ""
        lblUploadFileSize_visa.text = ""
        
        getDocumentsList()
    }
    func hiddenScanedResident(){
        viewbgResidentID_height.constant = 0
        viewbg_view_residentid.isHidden = true
        btnViewScannedImg_residentID.isHidden = true
    }
    func showScanedResident(){
        viewbgResidentID_height.constant = 30
        viewbg_view_residentid.isHidden = false
        btnViewScannedImg_residentID.isHidden = false
        viewbgF_ResidentID.isHidden = true
        viewbgB_ResidentID.isHidden = true
        imgScanResidentID_done.image = UIImage(named: "ic_fill_correct_green")
    }
    func hiddenFrontBackImg_ResidentID(){
        viewbgF_ResidentID.isHidden = true
        viewbgB_ResidentID.isHidden = true
        viewbgResidentID_height.constant = 30
        btnViewScannedImg_residentID.setTitle(Localize(key: "VIEW SCANNED IMAGES"), for: .normal)
    }
    func showFrontBackImg_ResidentID(){
        viewbgF_ResidentID.isHidden = false
        viewbgB_ResidentID.isHidden = false
        viewbgResidentID_height.constant = 195
        btnViewScannedImg_residentID.setTitle(Localize(key: "HIDE SCANNED IMAGES"), for: .normal)
    }
    func hiddenScanedPassport(){
        viewbg_passport_height.constant = 0
        viewbgViewZ_passport.isHidden = true
        btnViewScanImg_passport.isHidden = true
    }
    func showScanedPassport(){
        viewbg_passport_height.constant = 30
        viewbgViewZ_passport.isHidden = false
        btnViewScanImg_passport.isHidden = false
        viewbgFimg_passport.isHidden = true
        imgScanImgDone_passport.image = UIImage(named: "ic_fill_correct_green")
    }
    func hiddenFrontBackImg_Passport(){
        viewbgFimg_passport.isHidden = true
        viewbg_passport_height.constant = 30
        btnViewScanImg_passport.setTitle(Localize(key: "VIEW SCANNED IMAGES"), for: .normal)
    }
    func showFrontBackImg_Passport(){
        viewbgFimg_passport.isHidden = false
        viewbg_passport_height.constant = 195
        btnViewScanImg_passport.setTitle(Localize(key: "HIDE SCANNED IMAGES"), for: .normal)
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
    func validateEnput(){
        if selectFrontImg_ResidentID && selectBackImg_ResidentID && selectImg_Passport && selectVisaDoc{
            AppHelper.enableNextBTN(view_: viewbgbtnNext)
        }else{
            AppHelper.disableNextBTN(view_: viewbgbtnNext)
        }
    }
    /*func openLodingAlert(){
     //--
     loadingView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     let aView = UIView()
     aView.frame = loadingView.frame
     aView.addSubview(loadingView)
     popover.dismissOnBlackOverlayTap = true
     popover.showAsDialog(loadingView, inView: self.view)
     loadingView.viewbg_loading.rotate()
     loadingView.delegate_LoadingView_Protocol = self
     loadingView.btnCancel.isHidden = true
     /*viewbg_loading.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      let aView = UIView()
      aView.frame = viewbg_loading.frame
      aView.addSubview(viewbg_loading)
      popover.dismissOnBlackOverlayTap = true
      popover.showAsDialog(aView, inView: self.view)*/
     }*/
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
    
    //MARK: @IBAction
    @IBAction func btnScanResidentID(_ sender: Any) {
        scanedIDCount = 1
        scanIDCard(title: Localize(key: "Scan the front side of your Resident ID"))
    }
    @IBAction func btnViewScannedImg_ResidentID(_ sender: Any) {
        if viewbgF_ResidentID.isHidden{
            showFrontBackImg_ResidentID()
        }else{
            hiddenFrontBackImg_ResidentID()
        }
    }
    @IBAction func btnViewFimgResidentID(_ sender: Any) {
        if let img_ = imgViewResidentId.image{
            setupLightBoxImageArray(imgOpen: img_, msg: Localize(key: "Resident ID - Front"))
        }
    }
    @IBAction func btnViewBImg_ResidentID(_ sender: Any) {
        if let img_ = imgback_ResidentId.image{
            setupLightBoxImageArray(imgOpen: img_, msg: Localize(key: "Resident ID - Back"))
        }
    }
    @IBAction func btnScanPassport(_ sender: Any) {
        scanedIDCount = 3
        scanIDCard(title: Localize(key: "Scan the first page of your passport"))
    }
    @IBAction func btnViewScannedImg_passport(_ sender: Any) {
        if viewbgFimg_passport.isHidden{
            showFrontBackImg_Passport()
        }else{
            hiddenFrontBackImg_Passport()
        }
    }
    @IBAction func btnFImgView_passport(_ sender: Any) {
        if let img_ = imgF_passport.image{
            setupLightBoxImageArray(imgOpen: img_, msg: Localize(key: "Passport - First Page"))
        }
    }
    @IBAction func btnSelectDocument(_ sender: Any) {
        //        let scannerViewController = ImageScannerController(delegate: self)
        //        scannerViewController.shouldScanTwoFaces = false // Use this to scan the front and the back of a document
        //
        //        self.present(scannerViewController, animated: true)
        let vc = CustomCameraVC(nibName: "CustomCameraVC", bundle: nil)
        vc.delegate_didTakeCustomPhoto = self
        vc.avCaptureDevicePosition = .back
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnNext(_ sender: Any) {
        self.apiCall_updateApplication()
    }
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
    
    
    func scanIDCard(title: String) {
        let controller = CardDetectionViewController()
        controller.delegate = self
        let lbl = UILabel(frame: CGRect(x: 0, y: 50, width: 320, height: 0))
        lbl.text = ""
        controller.view.addSubview(lbl)
        controller.lbltrmp.text = title
        self.present(controller, animated: true, completion: nil)
    }
}

extension ExpatrIateCitizenshipDoc: CardDetectionViewControllerDelegate{
    func cardDetectionViewController(_ viewController: CardDetectionViewController, didDetectCard image: CGImage, withSettings settings: CardDetectionSettings) {
        // The card has been scanned
        // Display the image in the image view
        if scanedIDCount == 1{
            selectFrontImg_ResidentID = true
            imgViewResidentId.image = UIImage(cgImage: image)
            
            scanedIDCount = 2
            scanIDCard(title: Localize(key: "Scan the back side of your Resident ID"))
            
            validateEnput()
        }else if scanedIDCount == 2{
            scanedIDCount = 0
            
            selectBackImg_ResidentID = true
            imgback_ResidentId.image = UIImage(cgImage: image)
            
            showScanedResident()
            
            validateEnput()
        }else if scanedIDCount == 3{
            scanedIDCount = 0
            
            selectImg_Passport = true
            imgF_passport.image = UIImage(cgImage: image)
            
            showScanedPassport()
            
            validateEnput()
        }
        
    }
}

extension ExpatrIateCitizenshipDoc: didTakeCustomPhoto_protocol{
    func didTakeCustomPhoto_protocol(image_: UIImage) {
        selectVisaImag.image = image_
        
        imgUploadDocDone.image = UIImage(named: "ic_fill_correct_green")
        selectVisaDoc = true
        validateEnput()
    }
}

extension ExpatrIateCitizenshipDoc: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate{
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
}

extension ExpatrIateCitizenshipDoc: ImageScannerControllerDelegate{
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
        selectVisaImag.image = results.scannedImage
        
        imgUploadDocDone.image = UIImage(named: "ic_fill_correct_green")
        selectVisaDoc = true
        
        validateEnput()
    }
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithPage1Results page1Results: ImageScannerResults, andPage2Results page2Results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
    }
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        scanner.dismiss(animated: true, completion: nil)
        
    }
}
/*
 extension ExpatrIateCitizenshipDoc: LoadingView_Protocol{
 func btnCancelLoding(){
 popover.dismiss()
 openErrorAlert(title: Localize(key: "Unfortunately your country is not supported"), details: "")
 }
 }
 */
//MARK: - Api Call
extension ExpatrIateCitizenshipDoc{
    func getDocumentsList(){
        //LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getDocumentsList (showProgress: true){ [self] docResult in
            //LoadingView.shared.dismissLoadingView()
            
            docResult.documents.forEach { getDocumentsListDocuments in
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.resident.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        selectFrontImg_ResidentID = true
                        imgViewResidentId.setImage(url: url)
                        validateEnput()
                    }
                }
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.resident.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.rear)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        selectBackImg_ResidentID = true
                        imgback_ResidentId.setImage(url: url)
                        validateEnput()
                        showScanedResident()
                    }
                }
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.passport.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        selectImg_Passport = true
                        imgF_passport.setImage(url: url)
                        validateEnput()
                        showScanedPassport()
                    }
                }
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.visa.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.other)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        
                        selectVisaDoc = true
                        selectVisaImag.setImage(url: url)
                        
                        imgUploadDocDone.image = UIImage(named: "ic_fill_correct_green")
                        validateEnput()
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
                                                    "crm_data": ["citizenship_c": CitizenshipType.expatriate.rawValue,
                                                                 "application_status_c": ApplicationStatus.InProgress.rawValue,
                                                                 "id_type_c":"10"
                                                                ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: false, completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    //--
                    apiCall_UploadResidentImage(isFront: true)
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
    func apiCall_UploadResidentImage(isFront: Bool)  {
        //--
        //        if isFront{
        //            self.openLodingAlert()
        //        }
        let docBase64 = isFront ? imgViewResidentId.image?.convertImageToBase64String() : imgback_ResidentId.image?.convertImageToBase64String()
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.resident.getValue(),
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
                        self.scanBackDocData = validateOTPModel.Response?.Body?.Result?.data
                        self.apiCall_UploadPassport()
                    }else if isFront{
                        //--
                        self.scanFrontDocData = validateOTPModel.Response?.Body?.Result?.data
                        
                        //-- Check DOB valid
                        let yearAgo = AppHelper.stringToDate(strDate: self.scanFrontDocData?.date_of_birth ?? "", strFormate: "dd/MM/yyyy").getYearAgo()
                        if yearAgo >= 18{
                            //--
                            self.apiCall_UploadResidentImage(isFront: false)
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
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
            
        }) { (error) in
            print(error)
            LoadingView.shared.dismissLoadingView()
        }
    }
    
    func apiCall_UploadPassport()  {
        //--
        let docBase64 = imgF_passport.image?.convertImageToBase64String()
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.passport.getValue(),
                                                   "view_type":viewType.front.getValue(),
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
                    self.scanPasswordData = validateOTPModel.Response?.Body?.Result?.data
                    
                    //-- Check Passport expire date
                    let exp_date = AppHelper.stringToDate(strDate: self.scanPasswordData?.exp_date ?? "", strFormate: "yyyy-MM-dd")
                    if Date().ticks < exp_date.ticks{
                        //--
                        self.apiCall_UploadValidVisa()
                    }else{
                        //--
                        openErrorAlert(title: "Error", details: "You have submitted an expired document. Please check and retry")
                    }
                    LoadingView.shared.dismissLoadingView()
                }else{
                    LoadingView.shared.dismissLoadingView()
                    self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
                }
            }else{
                LoadingView.shared.dismissLoadingView()
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
            
        }) { (error) in
            print(error)
            LoadingView.shared.dismissLoadingView()
        }
    }
    
    func apiCall_UploadValidVisa()  {
        //--
        let docBase64 = selectVisaImag.image?.convertImageToBase64String()
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.visa.getValue(),
                                                   "view_type":viewType.other.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.selectDocumentTypeScreen)(),
                                                   "document_base64":docBase64 ?? "",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: false, completion: { [self] (response) in
            print(response as Any)
            let validateOTPModel = OmniResponseModel(JSON: response as! [String : Any])!
            if validateOTPModel.Response?.Body?.status == "Success"{
                //--
                LoadingView.shared.dismissLoadingView()
                
                //--
                let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
                vc.scanPasswordData = scanPasswordData
                vc.scanFrontDocData = scanFrontDocData
                vc.scanBackDocData = scanBackDocData
                vc.citizenshipType = CitizenshipType.expatriate
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                LoadingView.shared.dismissLoadingView()
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
            
        }) { (error) in
            print(error)
            LoadingView.shared.dismissLoadingView()
        }
    }

}
