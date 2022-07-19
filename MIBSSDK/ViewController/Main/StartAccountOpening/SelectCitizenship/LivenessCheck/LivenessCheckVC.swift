//
//  LivenessCheckVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 27/01/22.
//

import UIKit
import CoreMedia
import MLKitFaceDetection
import MLKitVision

class LivenessCheckVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewVideoPreview: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewbgBtnNext: UIView!
    @IBOutlet weak var lblNextTitle: UILabel!
    
    //MARK: Veriable
    lazy var faceDetector: FaceDetector = { () -> FaceDetector in
        // Real-time contour detection of multiple faces
        let options = FaceDetectorOptions()
        options.contourMode = .all
        options.classificationMode = .all
        
        return FaceDetector.faceDetector(options: options)
    }()
    var isInference = false
    var videoCapture: VideoCapture!
    var delegateSmileDetection: SmileDetectionDelegate?
    
    var completeLivenessCheck = false
    var CountOfSmileDetectVerify = 1
    var threhold_facematch_fail_attempts = 0
    
    var doc_ocr_id = ""
    var doc_photo_id = ""
    var citizenshipType = CitizenshipType.non
    
    var imgProfile: UIImage?
    var cra_level_c = ""
    var confidence_level = 0
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setUpCamera()
        localization()
        setupBasic()
        
        if Int(getDefaultConfiguration?.threhold_facematch?.omani?.one ?? "") ?? 0 == 0{
            apiCall_getDefaultConfiguration()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitle.attributedText = Localize(key: "Get ready for a selfie").attributedStringWithColor(["selfie"], color: .DARKGREENTINT)
        
        lblDetail.text = Localize(key: "Place your face in center and smile")
        lblNextTitle.text = Localize(key: "NEXT")
        
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        headerView.nav = self.navigationController!
        headerView.lblHeaderTitle.text = Localize(key: "Liveness Check")
        headerView.didTappedBack = { (sender) in
            //--
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupBasic(){
        if applyValidation{
            AppHelper.disableNextBTN(view_: viewbgBtnNext)
        }
        
        apiCall_getApplicationData { [self] result in
            let liveness_check_verified_c = result.liveness_check_verified_c as? String ?? ""
            CountOfSmileDetectVerify = Int(result.liveness_attempts_done_c as? String ?? "") ?? 1
            threhold_facematch_fail_attempts = Int(getDefaultConfiguration?.threhold_facematch_fail_attempts ?? "0") ?? 0
            
            if liveness_check_verified_c == "YES"{
                //--
                let vc = TermsConditionsVC(nibName: "TermsConditionsVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if threhold_facematch_fail_attempts <= CountOfSmileDetectVerify {
                //--
                let vc = FailedLivenessCheckVC(nibName: "FailedLivenessCheckVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                let cra_level_c = result.cra_level_c as? String ?? ""
                //Setup Detault Configration
                
                let defaultValue = "50"
                //--confidence
                if citizenshipType == .omani{
                    if cra_level_c == "1"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.omani?.one ?? defaultValue) ?? 0
                    }else if cra_level_c == "2"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.omani?.two ?? defaultValue) ?? 0
                    }else if cra_level_c == "3"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.omani?.three ?? defaultValue) ?? 0
                    }else if cra_level_c == "4"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.omani?.four ?? defaultValue) ?? 0
                    }
                }else if citizenshipType == .expatriate{
                    if cra_level_c == "1"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.expatriates?.one ?? defaultValue) ?? 0
                    }else if cra_level_c == "2"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.expatriates?.two ?? defaultValue) ?? 0
                    }else if cra_level_c == "3"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.expatriates?.three ?? defaultValue) ?? 0
                    }else if cra_level_c == "4"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.expatriates?.four ?? defaultValue) ?? 0
                    }
                }else{
                    //gcc
                    if cra_level_c == "1"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.gcc?.one ?? defaultValue) ?? 0
                    }else if cra_level_c == "2"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.gcc?.two ?? defaultValue) ?? 0
                    }else if cra_level_c == "3"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.gcc?.three ?? defaultValue) ?? 0
                    }else if cra_level_c == "4"{
                        confidence_level = Int(getDefaultConfiguration?.threhold_facematch?.gcc?.four ?? defaultValue) ?? 0
                    }
                }
            }
        }
    }
    func validateEnput(){
        if completeLivenessCheck == true {
            AppHelper.enableNextBTN(view_: viewbgBtnNext)
        }else{
            AppHelper.disableNextBTN(view_: viewbgBtnNext)
        }
    }
    
    //MARK: Liveness check
    func setUpCamera() {
        
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.viewVideoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                self.videoCapture.start()
            }
        }
    }
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = viewVideoPreview.bounds
    }
    
    //MARK: @IBAction
    @IBAction func btnNext(_ sender: Any) {
        if CountOfSmileDetectVerify <= threhold_facematch_fail_attempts && CountOfSmileDetectVerify >= 1{
            apiCall_UploadImage()
        }
        
        /*
         //--
         let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
         vc.selectCitizenship = "omani"
         self.navigationController?.pushViewController(vc, animated: true)
         */
    }
    func livenessFail(){
        //--
        let vc = RetakeLivenessCheckVC(nibName: "RetakeLivenessCheckVC", bundle: nil)
        vc.CountOfSmileDetectVerify = CountOfSmileDetectVerify
        self.navigationController?.pushViewController(vc, animated: true)
        
        //--
        CountOfSmileDetectVerify = CountOfSmileDetectVerify + 1
    }
    
}

extension LivenessCheckVC: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if !self.isInference, let pixelBuffer = pixelBuffer {
            self.isInference = true
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        let ciimage: CIImage = CIImage(cvImageBuffer: pixelBuffer)
        let ciContext = CIContext()
        guard let cgImage: CGImage = ciContext.createCGImage(ciimage, from: ciimage.extent) else {
            self.isInference = false
            return
        }
        let uiImage: UIImage = UIImage(cgImage: cgImage)
        let visionImage = VisionImage(image: uiImage)
        faceDetector.process(visionImage) { (features, error) in
            if error == nil, let faces: [Face] = features {
                
                if (faces.first?.smilingProbability ?? 0) > 0.9 {
                    self.videoCapture.stop()
                    self.imgProfile = uiImage
                    self.completeLivenessCheck = true
                    self.validateEnput()
                    
                } else {
                    //self.livenessFail()
                }
            } else {
            }
            self.isInference = false
        }
    }
    
}




//MARK: - Api Call
extension LivenessCheckVC{
    
    
    func apiCall_UploadImage()  {
        //--
        let docBase64 = imgProfile?.convertImageToBase64String()
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.profile_pic.getValue(),
                                                   "view_type":viewType.front.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.livenessCheckScreen)(),
                                                   "document_base64":docBase64 ?? "",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let validateOTPModel = OmniResponseModel(JSON: response as! [String : Any])!
            if validateOTPModel.Response?.Body?.status == "Success"{
                
                //--
                self.doc_photo_id = validateOTPModel.Response?.Body?.Result?.document_id ?? ""
                getDocumentsList()
                
            }else{
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    func getDocumentsList(){
        apiCall_getDocumentsList(showProgress: true) { docResult in
            docResult.documents.forEach { getDocumentsListDocuments in
                if self.citizenshipType == .omani{
                    if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.national.rawValue) &&
                        getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                        self.doc_ocr_id = getDocumentsListDocuments.doc_id
                    }
                }else if self.citizenshipType == .expatriate{
                    if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.resident.rawValue) &&
                        getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                        self.doc_ocr_id = getDocumentsListDocuments.doc_id
                    }
                }else{
                    //gcc
                    if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.gcc.rawValue) &&
                        getDocumentsListDocuments.card_type == viewType.getValue(.front)(){
                        self.doc_ocr_id = getDocumentsListDocuments.doc_id
                    }
                }
            }
            self.apiCall_ValildateUploadPhoto()
        }
    }
    
    func apiCall_ValildateUploadPhoto()  {
        //--
        let dicParam:[String:AnyObject] = ["operation":"getFacePrediction" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_ocr_id": self.doc_ocr_id,
                                                   "doc_photo_id": self.doc_photo_id,
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let getFacePredictionModel = GetFacePredictionModel(JSON: response as! [String : Any])!
            if getFacePredictionModel.Response?.Code == "200" && getFacePredictionModel.Response?.Body?.status == "Success"{
                
                if getFacePredictionModel.Response?.Body?.Result?.confidence ?? 0 > 50{
                    /*//--
                     let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
                     vc.citizenshipType = citizenshipType
                     self.navigationController?.pushViewController(vc, animated: true)*/
                    //--
                    let vc = TermsConditionsVC(nibName: "TermsConditionsVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    apiCall_updateApplication()
                    if CountOfSmileDetectVerify == 3{
                        //--
                        let vc = FailedLivenessCheckVC(nibName: "FailedLivenessCheckVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        livenessFail()
                    }
                }
                
            }else{
                self.view.makeToast(getFacePredictionModel.Response?.Body?.statusMsg ?? "")
            }
        }) { (error) in
            print(error)
        }
    }
    
    func apiCall_updateApplication()  {
  
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": [
                                                                 "liveness_attempts_done_c":CountOfSmileDetectVerify
                                                                 ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    
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
