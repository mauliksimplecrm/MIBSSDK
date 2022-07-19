//
//  ProofofAddressVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 23/02/22.
//

import UIKit
import Lightbox

class ProofofAddressVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblListofDoc: UILabel!
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblUploadProofofAddress: UILabel!
    
    @IBOutlet weak var imgDoneProofOfAddress: UIImageView!
    @IBOutlet weak var viewbtnNext: UIView!
    
    @IBOutlet weak var imgViewTakePhoto: UIImageView!
    @IBOutlet weak var btnViewTakePhotoHoldingId: UIButton!
    
    //MARK: - Veriable
    var isSelectProofOfAddressDoc = false
    var takedProofOfAddressDoc = UIImageView()
    
    let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .proof_of_address_doctype_c)
    
    
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
        setupHeader()
        setupBasic()
        hideTakePhotoHolding()
        getDocumentsList()
        
        tblList.reloadData()
    }
    
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblTitle.attributedText = Localize(key: "Proof of Address").attributedStringWithColor(["Address"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "To check your liveness, please upload a photo of your face at present")
        
        lblUploadProofofAddress.text = Localize(key: "Upload Proof of Address")
        lblListofDoc.text = Localize(key: "List of documents considered as Proof of Address:")
        
        lblNext.text = Localize(key: "NEXT")
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
            AppHelper.disableNextBTN(view_: viewbtnNext)
        }
        
        //--
        
    }
    
    func registerCell(){
        tblList.register(UINib(nibName: "ProofofAddressTblCell", bundle: nil), forCellReuseIdentifier: "ProofofAddressTblCell")
    }
    
    
    
    //MARK: - @IBAction
    @IBAction func btnUploadDoc(_ sender: Any) {
        let vc = CustomCameraVC(nibName: "CustomCameraVC", bundle: nil)
        vc.delegate_didTakeCustomPhoto = self
        vc.headerTitle = "Take a photo of the your address proof"
        vc.avCaptureDevicePosition = .back
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnViewTakePhotoHoldingId(_ sender: Any) {
        if let img_ = takedProofOfAddressDoc.image{
            setupLightBoxImageArray(imgOpen: img_, msg: "")
        }
    }
    @IBAction func btnNext(_ sender: Any) {
        
        apiCall_UploadImage()
    }
    
    
}

extension ProofofAddressVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProofofAddressTblCell", for: indexPath) as! ProofofAddressTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = list[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ProofofAddressVC: didTakeCustomPhoto_protocol{
    func didTakeCustomPhoto_protocol(image_: UIImage) {
        isSelectProofOfAddressDoc = true
        takedProofOfAddressDoc.image = image_
        selectTakePhotoHolding()
        AppHelper.enableNextBTN(view_: viewbtnNext)
    }
    
    func selectTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = false
        imgViewTakePhoto.isHidden = false
        imgDoneProofOfAddress.image = .IMGDoneGreen
    }
    func hideTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = true
        imgViewTakePhoto.isHidden = true
    }
}

//MARK: - Api Call
extension ProofofAddressVC{
    func getDocumentsList(){
        //LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getDocumentsList (showProgress: false){ [self] docResult in
            //LoadingView.shared.dismissLoadingView()
            
            //let proof_of_address_doctype_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .proof_of_address_doctype_c, index: selectDocumentIndex)
            docResult.documents.forEach { getDocumentsListDocuments in
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.address_proof.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.other)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        isSelectProofOfAddressDoc = true
                        takedProofOfAddressDoc.setImage(url: url)
                        
                        selectTakePhotoHolding()
                    }
                }
            }
        }
    }
    func apiCall_UploadImage()  {
        //--
        let docBase64 = takedProofOfAddressDoc.image?.convertImageToBase64String()
        
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.getValue(.address_proof)(),
                                                   "view_type":viewType.other.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                   "document_base64":docBase64 ?? "",
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let validateOTPModel = OmniResponseModel(JSON: response as! [String : Any])!
            if validateOTPModel.Response?.Body?.status == "Success"{
                apiCall_updateApplication()
            }else{
                self.view.makeToast(validateOTPModel.Response?.Body?.Result?.data?.error_response ?? "")
            }
        }) { (error) in
            print(error)
        }
    }
    func apiCall_updateApplication()  {
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.proofOfAddressScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": [
                                                        "application_status_c": ApplicationStatus.application_submitted.rawValue
                                                    ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    //--
                    let vc = ThankYouVC(nibName: "ThankYouVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
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

extension ProofofAddressVC: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate{
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
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
}
