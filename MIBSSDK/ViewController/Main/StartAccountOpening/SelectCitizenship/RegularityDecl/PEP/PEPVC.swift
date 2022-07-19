//
//  PEPVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 13/02/22.
//

import UIKit
import Foundation
import Popover
import SKCountryPicker

protocol didSelectPEP_protocol {
    func didSelectPEP(txt: String, index: Int)
}

class PEPVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var viewMain_top: NSLayoutConstraint!
    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var lblTitleStep1: UILabel!
    @IBOutlet weak var lblDetailStep1: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewStep1_height: NSLayoutConstraint!
    @IBOutlet weak var viewStep2: UIView!
    @IBOutlet weak var lblTitleStep2: UILabel!
    @IBOutlet weak var lblDetailStep2: UILabel!
    @IBOutlet weak var viewPEPDetailSectionLine: UIView!
    @IBOutlet weak var viewPEPDetail: UIView!
    @IBOutlet weak var viewPEPDetail_height: NSLayoutConstraint! //805
    @IBOutlet weak var lblPEPDetail_title: UILabel!
    @IBOutlet weak var txtTypeofPEP: UIFloatingTextField!
    @IBOutlet weak var txtNameofPEP: UIFloatingTextField!
    @IBOutlet weak var txtPositionofPEP: UIFloatingTextField!
    @IBOutlet weak var txtNationalityofPEP: UIFloatingTextField!
    @IBOutlet weak var txtCountryofResidence: UIFloatingTextField!
    @IBOutlet weak var txtRelationshipwithPEP: UIFloatingTextField!
    @IBOutlet weak var txtSourceofwealth: UIFloatingTextField!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var lblbtnSubmit: UILabel!
    
    //--
    @IBOutlet var viewAlertPopup: UIView!
    @IBOutlet weak var viewInnerAlertPopup: UIView!
    @IBOutlet weak var lblTitleAlertPopup: UILabel!
    @IBOutlet weak var lblDetailAlertPopup: UILabel!
    @IBOutlet weak var btnGotitAlertPopup: UIButton!
    
    
    //MARK: - Veriable
    var popover = Popover()
    var arrListOfDropDown = ManageDropDownOption.getDropDownValue(dropdown_filed: .is_pep_c)
    var selectIndex = 2
    var delegate_didSelectPEP_protocol: didSelectPEP_protocol?
    
    var selectTypeofPEPIndex = -1
    var selectNationalityofPEPIndex = -1
    var selectRelationshipWithThePEP = -1
    var selectSourceOfWealthOfPEP = -1
    var selectCountryofResidence = -1
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
        setupTextField()
        setUIStep1()
        tblList.reloadData()
        
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblPEPDetail_title.text = Localize(key: "PEP Details")
        lblbtnSubmit.text = Localize(key: "SUBMIT")
        
    }
    func registerCell(){
        tblList.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }
    func setupTextField(){
        //US Document Details
        txtTypeofPEP.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtTypeofPEP.setTitlePlaceholder(text_: Localize(key: "Type of PEP"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtTypeofPEP.btnOpenDropDown.isHidden = false
        txtTypeofPEP.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .type_of_pep_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Type of PEP"),
                                    dropDownType: "TypeOfPEP",
                                    arrList: list,
                                    selectedIndex: self.selectTypeofPEPIndex)
        }
        
        txtNameofPEP.setICON(hidden: true)
        txtNameofPEP.setTitlePlaceholder(text_: Localize(key: "Name of the PEP"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtNameofPEP.delegate_UIFloatingTextField_Protocol = self
        
        txtPositionofPEP.setICON(hidden: true)
        txtPositionofPEP.setTitlePlaceholder(text_: Localize(key: "Position of the PEP"), placeholder_: Localize(key: "Enter position"), isUserInteraction: true)
        txtPositionofPEP.delegate_UIFloatingTextField_Protocol = self
        
        txtNationalityofPEP.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtNationalityofPEP.setTitlePlaceholder(text_: Localize(key: "Nationality of PEP"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtNationalityofPEP.btnOpenDropDown.isHidden = false
        txtNationalityofPEP.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .nationality_of_pep_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Nationality of PEP"),
                                    dropDownType: "NationalityofPEP",
                                    arrList: list,
                                    selectedIndex: self.selectNationalityofPEPIndex)
        }
        
        txtCountryofResidence.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountryofResidence.setTitlePlaceholder(text_: Localize(key: "Country of Residence of PEP"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtCountryofResidence.btnOpenDropDown.isHidden = false
        txtCountryofResidence.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .country_of_residence_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Country of Residence of PEP"),
                                    dropDownType: "CountryofResidence",
                                    arrList: list,
                                    selectedIndex: self.selectCountryofResidence)
        }
        
        txtRelationshipwithPEP.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtRelationshipwithPEP.setTitlePlaceholder(text_: Localize(key: "Relationship with the PEP"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtRelationshipwithPEP.btnOpenDropDown.isHidden = false
        txtRelationshipwithPEP.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .relationship_with_the_pep_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Relationship with the PEP"),
                                    dropDownType: "RelationshipWithThePEP",
                                    arrList: list,
                                    selectedIndex: self.selectRelationshipWithThePEP)
        }
        
        txtSourceofwealth.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtSourceofwealth.setTitlePlaceholder(text_: "Source of wealth of PEP", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtSourceofwealth.btnOpenDropDown.isHidden = false
        txtSourceofwealth.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .source_of_wealth_of_pep_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Source of wealth of PEP"),
                                    dropDownType: "SourceOfWealthOfPEP",
                                    arrList: list,
                                    selectedIndex: self.selectSourceOfWealthOfPEP)
        }
    }
    func openErrorAlert(title: String, details: String){
        //--
        lblTitleAlertPopup.text = title
        lblDetailAlertPopup.text = details
        
        //--
        popover = Popover()
        viewAlertPopup.frame.size = CGSize(width: UIScreen.main.bounds.width-30, height: viewInnerAlertPopup.frame.height)
        let aView = UIView()
        aView.frame = viewAlertPopup.frame
        aView.addSubview(viewAlertPopup)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    func setUIStep1(){
        let height = UIScreen.main.bounds.height - 280
        viewMain_top.constant = height
        viewStep1.isHidden = false
        viewStep2.isHidden = true
        viewPEPDetailSectionLine.isHidden = true
        viewPEPDetail.isHidden = true
        viewPEPDetail_height.constant = 0
    }
    func setUIStep2(){
        viewMain_top.constant = 0
        viewStep1_height.constant = 117
        viewStep1.isHidden = true
        viewStep2.isHidden = false
        viewPEPDetailSectionLine.isHidden = true
        viewPEPDetail.isHidden = false
        viewPEPDetail_height.constant = 815
    }
    func setUIStep3(){
        viewMain_top.constant = 0
        viewStep1_height.constant = 280
        viewStep1.isHidden = false
        viewStep2.isHidden = true
        viewPEPDetailSectionLine.isHidden = false
        viewPEPDetail.isHidden = false
        viewPEPDetail_height.constant = 815
    }
    
    //MARK: - @IBAction
    @IBAction func btnGotitAlertPopup(_ sender: Any) {
        popover.dismiss()
    }
    @IBAction func btnBackHeaderStep1(_ sender: Any) {
        popover.dismiss()
        //openErrorAlert(title: Localize(key: "Sorry!"), details: Localize(key: "Make sure you fill all mandatory details and then submit the form"))
    }
    @IBAction func btnBackStep2(_ sender: Any) {
        popover.dismiss()
        //openErrorAlert(title: Localize(key: "Sorry!"), details: "Make sure you fill all mandatory details and then submit the form")
    }
    @IBAction func btnOpenListStep2(_ sender: Any) {
        setUIStep3()
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if validateEnput(){
            apiCall_updateApplication()
        }
    }



}

extension PEPVC: UIFloatingTextField_Protocol{
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
        
        if txtTypeofPEP.txtType == textField{
            txtTypeofPEP.lblError.isHidden = AppHelper.isNull(txtTypeofPEP.txtType.text!) == false ? true : false
        }
        if txtNameofPEP.txtType == textField{
            txtNameofPEP.lblError.isHidden = AppHelper.isNull(txtNameofPEP.txtType.text!) == false ? true : false
        }
        if txtPositionofPEP.txtType == textField{
            txtPositionofPEP.lblError.isHidden = AppHelper.isNull(txtPositionofPEP.txtType.text!) == false ? true : false
        }
        if txtNationalityofPEP.txtType == textField{
            txtNationalityofPEP.lblError.isHidden = AppHelper.isNull(txtNationalityofPEP.txtType.text!) == false ? true : false
        }
        if txtCountryofResidence.txtType == textField{
            txtCountryofResidence.lblError.isHidden = AppHelper.isNull(txtCountryofResidence.txtType.text!) == false ? true : false
        }
        if txtRelationshipwithPEP.txtType == textField{
            txtRelationshipwithPEP.lblError.isHidden = AppHelper.isNull(txtRelationshipwithPEP.txtType.text!) == false ? true : false
        }
        if txtSourceofwealth.txtType == textField{
            txtSourceofwealth.lblError.isHidden = AppHelper.isNull(txtSourceofwealth.txtType.text!) == false ? true : false
        }
        
        
    }
    func validateEnput() -> Bool{
        var returnValue = true
        
        if AppHelper.isNull(txtTypeofPEP.txtType.text!){
            txtTypeofPEP.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtNameofPEP.txtType.text!){
            txtNameofPEP.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtPositionofPEP.txtType.text!){
            txtPositionofPEP.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtNationalityofPEP.txtType.text!){
            txtNationalityofPEP.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCountryofResidence.txtType.text!){
            txtCountryofResidence.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtRelationshipwithPEP.txtType.text!){
            txtRelationshipwithPEP.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtSourceofwealth.txtType.text!){
            txtSourceofwealth.lblError.isHidden = false
            returnValue = false
        }
        return returnValue
    }

}

extension PEPVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        if droDownType == "TypeOfPEP"{
            txtTypeofPEP.txtType.text = title
            selectTypeofPEPIndex = index
            txtTypeofPEP.lblError.isHidden = true
        }
        if droDownType == "NationalityofPEP"{
            txtNationalityofPEP.txtType.text = title
            selectNationalityofPEPIndex = index
            txtNationalityofPEP.lblError.isHidden = true
        }
        if droDownType == "CountryofResidence"{
            txtCountryofResidence.txtType.text = title
            selectCountryofResidence = index
            txtCountryofResidence.lblError.isHidden = true
        }
        if droDownType == "RelationshipWithThePEP"{
            txtRelationshipwithPEP.txtType.text = title
            selectRelationshipWithThePEP = index
            txtRelationshipwithPEP.lblError.isHidden = true
        }
        if droDownType == "SourceOfWealthOfPEP"{
            txtSourceofwealth.txtType.text = title
            selectSourceOfWealthOfPEP = index
            txtSourceofwealth.lblError.isHidden = true
        }
    }
}

extension PEPVC: UITableViewDelegate, UITableViewDataSource
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
        if indexPath.row == 0{
           setUIStep2()
            //--
            apiCall_getApplicationData { result in
                self.setFormData(result: result)
            }
        }else{
            
            //--
            delegate_didSelectPEP_protocol?.didSelectPEP(txt: arrListOfDropDown[indexPath.row], index: selectIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

//MARK: - Api Call
extension PEPVC{
    
    
    func setFormData(result: GetApplicationDataResult){
        let type_of_pep_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .type_of_pep_c, backendvalue: result.type_of_pep_c as? String ?? "")
        txtTypeofPEP.txtType.text = type_of_pep_c.0
        selectTypeofPEPIndex = type_of_pep_c.1
        txtNameofPEP.txtType.text = result.name_of_the_pep_c as? String ?? ""
        txtPositionofPEP.txtType.text = result.position_of_pep_c as? String ?? ""
        
        let nationality_of_pep_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .nationality_of_pep_c, backendvalue: result.nationality_of_pep_c as? String ?? "")
        txtNationalityofPEP.txtType.text = nationality_of_pep_c.0
        selectNationalityofPEPIndex = nationality_of_pep_c.1
        
        let country_of_residence_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .country_of_residence_c, backendvalue: result.country_of_residence_c as? String ?? "")
        txtCountryofResidence.txtType.text = country_of_residence_c.0
        selectCountryofResidence = country_of_residence_c.1
        
        let relationship_with_the_pep_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .relationship_with_the_pep_c, backendvalue: result.relationship_with_the_pep_c as? String ?? "")
        txtRelationshipwithPEP.txtType.text = relationship_with_the_pep_c.0
        selectRelationshipWithThePEP = relationship_with_the_pep_c.1
        
        let source_of_wealth_of_pep_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .source_of_wealth_of_pep_c, backendvalue: result.source_of_wealth_of_pep_c as? String ?? "")
        txtSourceofwealth.txtType.text = source_of_wealth_of_pep_c.0
        selectSourceOfWealthOfPEP = source_of_wealth_of_pep_c.1
        
    }
    func apiCall_updateApplication()  {
        //--
        let type_of_pep_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .type_of_pep_c, index: selectTypeofPEPIndex)
        let nationality_of_pep_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .nationality_of_pep_c, index: selectNationalityofPEPIndex)
        let country_of_residence_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .country_of_residence_c, index: selectCountryofResidence)
        let relationship_with_the_pep_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .relationship_with_the_pep_c, index: selectRelationshipWithThePEP)
        let source_of_wealth_of_pep_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .source_of_wealth_of_pep_c, index: selectSourceOfWealthOfPEP)
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["type_of_pep_c":type_of_pep_c,
                                                                 "name_of_the_pep_c":txtNameofPEP.txtType.text!,
                                                                 "position_of_pep_c":txtPositionofPEP.txtType.text!,
                                                                 "nationality_of_pep_c":nationality_of_pep_c,
                                                                 "country_of_residence_c":country_of_residence_c,
                                                                 "relationship_with_the_pep_c":relationship_with_the_pep_c,
                                                                 "source_of_wealth_of_pep_c":source_of_wealth_of_pep_c
                                                                 ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    
                    //--
                    delegate_didSelectPEP_protocol?.didSelectPEP(txt: (arrListOfDropDown.count != 0 ? arrListOfDropDown[0] : ""), index: selectIndex)
                    self.dismiss(animated: true, completion: nil)
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
