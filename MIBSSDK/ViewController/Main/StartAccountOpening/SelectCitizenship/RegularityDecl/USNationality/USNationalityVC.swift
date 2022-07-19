//
//  USNationalityVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 12/02/22.
//

import UIKit

class USNationalityVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var viewbgHeader1: UIView!
    @IBOutlet weak var lblHeader1Title: UILabel!
    @IBOutlet weak var lblHeader1_usaNationality: UILabel!
    @IBOutlet weak var viewbgheader2: UIView!
    @IBOutlet weak var lblHeader2Title: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var tblList_height: NSLayoutConstraint!
    @IBOutlet weak var viewbgLine1_height: NSLayoutConstraint!
    @IBOutlet weak var lblUSDocumentDetail: UILabel!
    @IBOutlet weak var txtName: UIFloatingTextField!
    @IBOutlet weak var lblAddressInformation: UILabel!
    @IBOutlet weak var txtAddress: UIFloatingTextField!
    @IBOutlet weak var txtStreetName: UIFloatingTextField!
    @IBOutlet weak var txtFlatVillaNo: UIFloatingTextField!
    @IBOutlet weak var txtCity: UIFloatingTextField!
    @IBOutlet weak var txtState: UIFloatingTextField!
    @IBOutlet weak var txtZipCode: UIFloatingTextField!
    @IBOutlet weak var txtSocialSecurityNumber: UIFloatingTextField!
    @IBOutlet weak var viewbgbtnSubmit: UIView!
    @IBOutlet weak var lblbtnSubmit: UILabel!
    

    //MARK: - Veriable
    var arrListOfDropDown = ManageDropDownOption.getDropDownValue(dropdown_filed: .fatca_classification_c)
    var selectIndex = 0

    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
        setupTextField()
        tblList.reloadData()

        apiCall_getApplicationData { result in
            self.setFormData(result: result)
        }
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblUSDocumentDetail.text = Localize(key: "US Document Details")
        lblAddressInformation.text = Localize(key: "Address Information")
        lblbtnSubmit.text = Localize(key: "SUBMIT")
        
    }
    func registerCell(){
        tblList.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }
    func setupTextField(){
        //US Document Details
        txtName.setICON(hidden: true)
        txtName.setTitlePlaceholder(text_: Localize(key: "Name (as shown on your income tax return)"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtName.delegate_UIFloatingTextField_Protocol = self
        
        //Address Information
        txtAddress.setICON(hidden: true)
        txtAddress.setTitlePlaceholder(text_: Localize(key: "Address"), placeholder_: Localize(key: "Enter address"), isUserInteraction: true)
        txtAddress.delegate_UIFloatingTextField_Protocol = self
        
        txtStreetName.setICON(hidden: true)
        txtStreetName.setTitlePlaceholder(text_: Localize(key: "Street Name"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtStreetName.delegate_UIFloatingTextField_Protocol = self
        
        txtFlatVillaNo.setICON(hidden: true)
        txtFlatVillaNo.setTitlePlaceholder(text_: Localize(key: "Flat/Villa No."), placeholder_: Localize(key: "Enter no."), isUserInteraction: true)
        txtFlatVillaNo.delegate_UIFloatingTextField_Protocol = self
        
        txtCity.setICON(hidden: true)
        txtCity.setTitlePlaceholder(text_: Localize(key: "City"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtCity.delegate_UIFloatingTextField_Protocol = self
        
        txtState.setICON(hidden: true)
        txtState.setTitlePlaceholder(text_: Localize(key: "State"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtState.delegate_UIFloatingTextField_Protocol = self
        
        txtZipCode.setICON(hidden: true)
        txtZipCode.setTitlePlaceholder(text_: Localize(key: "Zip Code"), placeholder_: Localize(key: "Enter code"), isUserInteraction: true)
        txtZipCode.delegate_UIFloatingTextField_Protocol = self
        
        txtSocialSecurityNumber.setICON(hidden: true)
        txtSocialSecurityNumber.setTitlePlaceholder(text_: Localize(key: "Social security number / Employer identification number"), placeholder_: Localize(key: "Enter number"), isUserInteraction: true)
        txtSocialSecurityNumber.txtType.keyboardType = .numberPad
        txtSocialSecurityNumber.delegate_UIFloatingTextField_Protocol = self
    }

    //MARK: - @IBAction
    @IBAction func btnBackHeader1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnBackHeader2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnHeader1_usaNationality(_ sender: Any) {
        tblList_height.constant = 470 //self.tblList.contentSize.height
        viewbgLine1_height.constant = 10
        viewbgHeader1.isHidden = true
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if validateEnput(){
            apiCall_updateApplication()
        }
    }
    

}

extension USNationalityVC: UIFloatingTextField_Protocol{
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    func btnOpenCountryCodePicker(textField: UITextField) {
    }
    func editingChanged(textField: UITextField) {
        validateErrorMsg(textField: textField)
    }
    func shouldChangeCharactersIn(textField: UITextField, txt: String) {
    }
    
    //Validation
    func validateErrorMsg(textField: UITextField){
        
        if txtName.txtType == textField{
            txtName.lblError.isHidden = AppHelper.isNull(txtName.txtType.text!) == false ? true : false
        }
        if txtAddress.txtType == textField{
            txtAddress.lblError.isHidden = AppHelper.isNull(txtAddress.txtType.text!) == false ? true : false
        }
        if txtStreetName.txtType == textField{
            txtStreetName.lblError.isHidden = AppHelper.isNull(txtStreetName.txtType.text!) == false ? true : false
        }
        if txtFlatVillaNo.txtType == textField{
            txtFlatVillaNo.lblError.isHidden = AppHelper.isNull(txtFlatVillaNo.txtType.text!) == false ? true : false
        }
        if txtCity.txtType == textField{
            txtCity.lblError.isHidden = AppHelper.isNull(txtCity.txtType.text!) == false ? true : false
        }
        if txtState.txtType == textField{
            txtState.lblError.isHidden = AppHelper.isNull(txtState.txtType.text!) == false ? true : false
        }
        if txtZipCode.txtType == textField{
            txtZipCode.lblError.isHidden = AppHelper.isNull(txtZipCode.txtType.text!) == false ? true : false
        }
        if txtSocialSecurityNumber.txtType == textField{
            txtSocialSecurityNumber.lblError.isHidden = AppHelper.isNull(txtSocialSecurityNumber.txtType.text!) == false ? true : false
        }
    }
    func validateEnput() -> Bool{
        var returnValue = true
        
        if AppHelper.isNull(txtName.txtType.text!){
            txtName.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtAddress.txtType.text!){
            txtAddress.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtStreetName.txtType.text!){
            txtStreetName.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtFlatVillaNo.txtType.text!){
            txtFlatVillaNo.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCity.txtType.text!){
            txtCity.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtState.txtType.text!){
            txtState.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtZipCode.txtType.text!){
            txtZipCode.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtSocialSecurityNumber.txtType.text!){
            txtSocialSecurityNumber.lblError.isHidden = false
            returnValue = false
        }
        return returnValue
    }

}
extension USNationalityVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfDropDown.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDropDownTblCell", for: indexPath) as! CustomDropDownTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrListOfDropDown[indexPath.row]
        
        if indexPath.row == selectIndex{
            cell.imgSelectIcon.isHidden = false
        }else{
            cell.imgSelectIcon.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //--
        selectIndex = indexPath.row
        tblList.reloadData()
        
        //--
        if indexPath.row == 2{
            //--
            let vc = TaxResidentofUSAVC(nibName: "TaxResidentofUSAVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }else{
            
            //--
            //delegate_didSelectSourceofFunds_protocol?.didSelectSourceofFunds(text: arrListOfDropDown[indexPath.row], index: selectIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

//MARK: - Api Call
extension USNationalityVC{
    func setFormData(result: GetApplicationDataResult){
        
        txtName.txtType.text = result.name_fatca_w9_c as? String ?? ""
        txtAddress.txtType.text = result.address_number_w9_c as? String ?? ""
        txtStreetName.txtType.text = result.street_number_facta_w9_c as? String ?? ""
        txtFlatVillaNo.txtType.text = result.apt_suite_no_facta_w9_c as? String ?? ""
        txtCity.txtType.text = result.city_facta_w9_c as? String ?? ""
        txtState.txtType.text = result.state_facta_w9_c as? String ?? ""
        txtZipCode.txtType.text = result.zip_code_facta_w9_c as? String ?? ""
        txtSocialSecurityNumber.txtType.text = "\(result.ustaxpayer_id_fatca_w9_c as? Int ?? 0)"
        
    }
    
    func apiCall_updateApplication()  {
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["name_fatca_w9_c":txtName.txtType.text!,
                                                                 "address_number_w9_c":txtAddress.txtType.text!,
                                                                 "street_number_facta_w9_c":txtStreetName.txtType.text!,
                                                                 "apt_suite_no_facta_w9_c":txtFlatVillaNo.txtType.text!,
                                                                 "city_facta_w9_c":txtCity.txtType.text!,
                                                                 "state_facta_w9_c":txtState.txtType.text!,
                                                                 "zip_code_facta_w9_c":txtZipCode.txtType.text!,
                                                                 "ustaxpayer_id_fatca_w9_c":txtSocialSecurityNumber.txtType.text!
                                                                 ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    //--
                    self.dismiss(animated: true, completion: nil)
                    //apiCall_UploadImage(isFront: true)
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
