//
//  TaxResidentofUSAVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 12/02/22.
//

import UIKit
import SKCountryPicker

class TaxResidentofUSAVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var tblList_height: NSLayoutConstraint!
    //US Document Details
    @IBOutlet weak var lblUSDocumentDetail_title: UILabel!
    @IBOutlet weak var txtNameofIndividual: UIFloatingTextField!
    @IBOutlet weak var txtCountryofCitizenship: UIFloatingTextField!
    //Permanent Address Information
    @IBOutlet weak var lblParmanentAddressInfo_title: UILabel!
    @IBOutlet weak var txtAddress: UIFloatingTextField!
    @IBOutlet weak var txtStreetName: UIFloatingTextField!
    @IBOutlet weak var txtFlatVillaNo: UIFloatingTextField!
    @IBOutlet weak var txtCity: UIFloatingTextField!
    @IBOutlet weak var txtState: UIFloatingTextField!
    @IBOutlet weak var txtZipCode: UIFloatingTextField!
    @IBOutlet weak var txtCountry1: UIFloatingTextField!
    //Is your mailing address the same as any of the following?
    @IBOutlet weak var lblIsYourMailing_title: UILabel!
    @IBOutlet weak var imgPermanentAddressInfo: UIImageView!
    @IBOutlet weak var lblPermanentAddressInfo: UILabel!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var lblOther: UILabel!
    //--
    @IBOutlet weak var txtUSTaxpayer: UIFloatingTextField!
    @IBOutlet weak var txtForeginTax: UIFloatingTextField!
    @IBOutlet weak var txtReferenceNumber: UIFloatingTextField!
    //--
    @IBOutlet weak var viewbgSubmit: UIView!
    @IBOutlet weak var lblBtnSubmit: UILabel!
    
    //-- Other Address
    @IBOutlet weak var txtAddress_Other: UIFloatingTextField!
    @IBOutlet weak var txtStreetName_Other: UIFloatingTextField!
    @IBOutlet weak var txtFlatVillaNo_Other: UIFloatingTextField!
    @IBOutlet weak var txtCity_Other: UIFloatingTextField!
    @IBOutlet weak var txtState_Other: UIFloatingTextField!
    @IBOutlet weak var txtZipCode_Other: UIFloatingTextField!
    @IBOutlet weak var txtCountry_Other: UIFloatingTextField!
    
    
    
    //MARK: - Veriable
    var arrListOfDropDown = ManageDropDownOption.getDropDownValue(dropdown_filed: .fatca_classification_c)
    var selectIndex = 2
    var mailing_address_same_w8_c = ""
    
    
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
    override func viewDidLayoutSubviews() {
        tblList_height.constant = tblList.contentSize.height
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblHeaderTitle.text = Localize(key: "Are you a holder of any of the following?")
        lblUSDocumentDetail_title.text = Localize(key: "US Document Details")
        lblPermanentAddressInfo.text = Localize(key: "Permanent Address Information")
        lblIsYourMailing_title.text = Localize(key: "Is your mailing address the same as any of the following?")
        lblPermanentAddressInfo.text = Localize(key: "Permanent Address Information")
        lblOther.text = Localize(key: "Other")
        
        lblBtnSubmit.text = Localize(key: "SUBMIT")
    }
    func registerCell(){
        tblList.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }
    func setupTextField(){
        //US Document Details
        txtNameofIndividual.setICON(hidden: true)
        txtNameofIndividual.setTitlePlaceholder(text_: Localize(key: "Name of individual who is the beneficial owner"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtNameofIndividual.delegate_UIFloatingTextField_Protocol = self
        
        txtCountryofCitizenship.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountryofCitizenship.setTitlePlaceholder(text_: Localize(key: "Country of Citizenship"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtCountryofCitizenship.btnOpenDropDown.isHidden = false
        txtCountryofCitizenship.didTappedDropDown = { (sender) in
           
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtCountryofCitizenship.txtType.text = countryName
                self.txtCountryofCitizenship.lblError.isHidden = true
            }
            /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtCountryofCitizenship.txtType.text = country.countryName
                self.txtCountryofCitizenship.lblError.isHidden = true
            }*/
        }
        
        //--Permanent Address
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
        
        txtCountry1.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountry1.setTitlePlaceholder(text_: Localize(key: "Country"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtCountry1.btnOpenDropDown.isHidden = false
        txtCountry1.didTappedDropDown = { (sender) in
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtCountry1.txtType.text = countryName
                self.txtCountry1.lblError.isHidden = true
            }
            /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtCountry1.txtType.text = country.countryName
                self.txtCountry1.lblError.isHidden = true
            }*/
        }
        
        //-- Other Address
        txtAddress_Other.setICON(hidden: true)
        txtAddress_Other.setTitlePlaceholder(text_: Localize(key: "Address"), placeholder_: Localize(key: "Enter address"), isUserInteraction: true)
        txtAddress_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtStreetName_Other.setICON(hidden: true)
        txtStreetName_Other.setTitlePlaceholder(text_: Localize(key: "Street Name"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtStreetName_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtFlatVillaNo_Other.setICON(hidden: true)
        txtFlatVillaNo_Other.setTitlePlaceholder(text_: Localize(key: "Flat/Villa No."), placeholder_: Localize(key: "Enter no."), isUserInteraction: true)
        txtFlatVillaNo_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtCity_Other.setICON(hidden: true)
        txtCity_Other.setTitlePlaceholder(text_: Localize(key: "City"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtCity_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtState_Other.setICON(hidden: true)
        txtState_Other.setTitlePlaceholder(text_: Localize(key: "State"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtState_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtZipCode_Other.setICON(hidden: true)
        txtZipCode_Other.setTitlePlaceholder(text_: Localize(key: "Zip Code"), placeholder_: Localize(key: "Enter code"), isUserInteraction: true)
        txtZipCode_Other.delegate_UIFloatingTextField_Protocol = self
        
        txtCountry_Other.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountry_Other.setTitlePlaceholder(text_: Localize(key: "Country"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtCountry_Other.btnOpenDropDown.isHidden = false
        txtCountry_Other.didTappedDropDown = { (sender) in
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtCountry_Other.txtType.text = countryName
                self.txtCountry_Other.lblError.isHidden = true
            }
            /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtCountry_Other.txtType.text = country.countryName
                self.txtCountry_Other.lblError.isHidden = true
            }*/
        }
        
        //--
        txtUSTaxpayer.setICON(hidden: true)
        txtUSTaxpayer.setTitlePlaceholder(text_: Localize(key: "U.S. taxpayer identification number (SSN or ITIN)"), placeholder_: Localize(key: "Enter number"), isUserInteraction: true)
        txtUSTaxpayer.delegate_UIFloatingTextField_Protocol = self
        
        txtForeginTax.setICON(hidden: true)
        txtForeginTax.setTitlePlaceholder(text_: Localize(key: "Foreign tax identifying number"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtForeginTax.delegate_UIFloatingTextField_Protocol = self
        
        txtReferenceNumber.setICON(hidden: true)
        txtReferenceNumber.setTitlePlaceholder(text_: Localize(key: "Reference number(s)"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        txtReferenceNumber.delegate_UIFloatingTextField_Protocol = self
    }
    func manageIsYourMailing(clearData:Bool){
        if mailing_address_same_w8_c == "permanent_address_information"{
            imgPermanentAddressInfo.image = UIImage(named: "ic_radio_fill")
            imgOther.image = UIImage(named: "ic_radio_unfill")
            lblPermanentAddressInfo.textColor = .DARKGREY
            lblPermanentAddressInfo.font = UIFont.font_(name: "Gotham-Medium", size: 16.0)
            lblOther.textColor = .MIDGREY
            lblOther.font = UIFont.font_(name: "Gotham-Book", size: 16.0)
            
            hideOtherAddress(clearData: clearData)
        }else{
            imgPermanentAddressInfo.image = UIImage(named: "ic_radio_unfill")
            imgOther.image = UIImage(named: "ic_radio_fill")
            lblPermanentAddressInfo.textColor = .MIDGREY
            lblPermanentAddressInfo.font = UIFont.font_(name: "Gotham-Book", size: 16.0)
            lblOther.textColor = .DARKGREY
            lblOther.font = UIFont.font_(name: "Gotham-Medium", size: 16.0)
            
            showOtherAddress(clearData: clearData)
        }
    }
    func hideOtherAddress(clearData:Bool){
        txtAddress_Other.isHidden = true
        txtStreetName_Other.isHidden = true
        txtFlatVillaNo_Other.isHidden = true
        txtCity_Other.isHidden = true
        txtState_Other.isHidden = true
        txtZipCode_Other.isHidden = true
        txtCountry_Other.isHidden = true
        if clearData{
        txtAddress_Other.txtType.text = ""
        txtStreetName_Other.txtType.text = ""
        txtFlatVillaNo_Other.txtType.text = ""
        txtCity_Other.txtType.text = ""
        txtState_Other.txtType.text = ""
        txtZipCode_Other.txtType.text = ""
        txtCountry_Other.txtType.text = ""
        }
    }
    func showOtherAddress(clearData:Bool){
        txtAddress_Other.isHidden = false
        txtStreetName_Other.isHidden = false
        txtFlatVillaNo_Other.isHidden = false
        txtCity_Other.isHidden = false
        txtState_Other.isHidden = false
        txtZipCode_Other.isHidden = false
        txtCountry_Other.isHidden = false
        if clearData{
        txtAddress_Other.txtType.text = ""
        txtStreetName_Other.txtType.text = ""
        txtFlatVillaNo_Other.txtType.text = ""
        txtCity_Other.txtType.text = ""
        txtState_Other.txtType.text = ""
        txtZipCode_Other.txtType.text = ""
        txtCountry_Other.txtType.text = ""
        }
    }
    //MARK: - @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnRadioPermanentAddressInfo(_ sender: Any) {
        mailing_address_same_w8_c = "permanent_address_information"
        manageIsYourMailing(clearData: true)
    }
    @IBAction func btnRadioOther(_ sender: Any) {
        mailing_address_same_w8_c = "others"
        manageIsYourMailing(clearData: true)
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if validateEnput(){
            apiCall_updateApplication()
        }
    }
    


}

extension TaxResidentofUSAVC: UIFloatingTextField_Protocol{
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
        
        if txtNameofIndividual.txtType == textField{
            txtNameofIndividual.lblError.isHidden = AppHelper.isNull(txtNameofIndividual.txtType.text!) == false ? true : false
        }
        if txtCountryofCitizenship.txtType == textField{
            txtCountryofCitizenship.lblError.isHidden = AppHelper.isNull(txtCountryofCitizenship.txtType.text!) == false ? true : false
        }
        
        //--
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
        if txtCountry1.txtType == textField{
            txtCountry1.lblError.isHidden = AppHelper.isNull(txtCountry1.txtType.text!) == false ? true : false
        }
        
        //-- Other Address
        if txtAddress_Other.txtType == textField{
            txtAddress_Other.lblError.isHidden = AppHelper.isNull(txtAddress_Other.txtType.text!) == false ? true : false
        }
        if txtStreetName_Other.txtType == textField{
            txtStreetName_Other.lblError.isHidden = AppHelper.isNull(txtStreetName_Other.txtType.text!) == false ? true : false
        }
        if txtFlatVillaNo_Other.txtType == textField{
            txtFlatVillaNo_Other.lblError.isHidden = AppHelper.isNull(txtFlatVillaNo_Other.txtType.text!) == false ? true : false
        }
        if txtCity_Other.txtType == textField{
            txtCity_Other.lblError.isHidden = AppHelper.isNull(txtCity_Other.txtType.text!) == false ? true : false
        }
        if txtState_Other.txtType == textField{
            txtState_Other.lblError.isHidden = AppHelper.isNull(txtState_Other.txtType.text!) == false ? true : false
        }
        if txtZipCode_Other.txtType == textField{
            txtZipCode_Other.lblError.isHidden = AppHelper.isNull(txtZipCode_Other.txtType.text!) == false ? true : false
        }
        if txtCountry_Other.txtType == textField{
            txtCountry_Other.lblError.isHidden = AppHelper.isNull(txtCountry_Other.txtType.text!) == false ? true : false
        }
        
        //--
        if txtUSTaxpayer.txtType == textField{
            txtUSTaxpayer.lblError.isHidden = AppHelper.isNull(txtUSTaxpayer.txtType.text!) == false ? true : false
        }
        if txtForeginTax.txtType == textField{
            txtForeginTax.lblError.isHidden = AppHelper.isNull(txtForeginTax.txtType.text!) == false ? true : false
        }
        if txtReferenceNumber.txtType == textField{
            txtReferenceNumber.lblError.isHidden = AppHelper.isNull(txtReferenceNumber.txtType.text!) == false ? true : false
        }
        
    }
    func validateEnput() -> Bool{
        var returnValue = true
        
        if AppHelper.isNull(txtNameofIndividual.txtType.text!){
            txtNameofIndividual.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCountryofCitizenship.txtType.text!){
            txtCountryofCitizenship.lblError.isHidden = false
            returnValue = false
        }
        
        //--
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
        if AppHelper.isNull(txtCountry1.txtType.text!){
            txtCountry1.lblError.isHidden = false
            returnValue = false
        }
        
        if mailing_address_same_w8_c == "others"{
            //-- Other Address
            if AppHelper.isNull(txtAddress_Other.txtType.text!){
                txtAddress_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtStreetName_Other.txtType.text!){
                txtStreetName_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtFlatVillaNo_Other.txtType.text!){
                txtFlatVillaNo_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtCity_Other.txtType.text!){
                txtCity_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtState_Other.txtType.text!){
                txtState_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtZipCode_Other.txtType.text!){
                txtZipCode_Other.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtCountry_Other.txtType.text!){
                txtCountry_Other.lblError.isHidden = false
                returnValue = false
            }
        }
        
        //--
        if AppHelper.isNull(txtUSTaxpayer.txtType.text!){
            txtUSTaxpayer.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtForeginTax.txtType.text!){
            txtForeginTax.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtReferenceNumber.txtType.text!){
            txtReferenceNumber.lblError.isHidden = false
            returnValue = false
        }
        return returnValue
    }

}


extension TaxResidentofUSAVC: UITableViewDelegate, UITableViewDataSource
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
           
            
        }else{
            
            //--
            //delegate_didSelectSourceofFunds_protocol?.didSelectSourceofFunds(text: arrListOfDropDown[indexPath.row], index: selectIndex)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Api Call
extension TaxResidentofUSAVC{
    
   
    func setFormData(result: GetApplicationDataResult){
        txtNameofIndividual.txtType.text = result.name_fatca_w8_c as? String ?? ""
        txtCountryofCitizenship.txtType.text = result.country_of_citizenship_w8_c as? String ?? ""
        
        txtAddress.txtType.text = result.address_number_fatca_w8_c as? String ?? ""
        txtStreetName.txtType.text = result.street_fatca_w8_c as? String ?? ""
        txtFlatVillaNo.txtType.text = result.apt_suite_no_facta_w8_c as? String ?? ""
        txtCity.txtType.text = result.city_fatca_w8_c as? String ?? ""
        txtState.txtType.text = result.state_fatca_w8_c as? String ?? ""
        txtZipCode.txtType.text = "\(result.zip_code_w8_c as? Int ?? 0)"
        txtCountry1.txtType.text = result.country_facta_w8_c as? String ?? ""
        
        txtAddress_Other.txtType.text = result.mailing_address_number_w8_c as? String ?? ""
        txtStreetName_Other.txtType.text = result.mailing_street_fatca_w8_c as? String ?? ""
        txtFlatVillaNo_Other.txtType.text = result.mailing_apt_suite_no_w8_c as? String ?? ""
        txtCity_Other.txtType.text = result.mailing_city_w8_c as? String ?? ""
        txtState_Other.txtType.text = result.mailing_state_fatca_w8_c as? String ?? ""
        txtZipCode_Other.txtType.text = result.mailing_postal_code_fatca_w8_c as? String ?? ""
        txtCountry_Other.txtType.text = result.mailing_country_fatca_w8_c as? String ?? ""
        
        txtUSTaxpayer.txtType.text = result.us_taxpayer_id_fatca_w8_c as? String ?? ""
        txtForeginTax.txtType.text = result.foreign_tax_id_number_w8_c as? String ?? ""
        txtReferenceNumber.txtType.text = result.reference_number_w8_c as? String ?? ""
        
        mailing_address_same_w8_c = (result.mailing_address_same_w8_c as? String ?? "").count == 0 ? "permanent_address_information" : result.mailing_address_same_w8_c as? String ?? ""
        manageIsYourMailing(clearData: false)
    }
    func apiCall_updateApplication()  {
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["name_fatca_w8_c":txtNameofIndividual.txtType.text!,
                                                                 "country_of_citizenship_w8_c":txtCountryofCitizenship.txtType.text!,
                                                                 "address_number_fatca_w8_c":txtAddress.txtType.text!,
                                                                 "street_fatca_w8_c":txtStreetName.txtType.text!,
                                                                 "apt_suite_no_facta_w8_c":txtFlatVillaNo.txtType.text!,
                                                                 "city_fatca_w8_c":txtCity.txtType.text!,
                                                                 "state_fatca_w8_c":txtState.txtType.text!,
                                                                 "zip_code_w8_c":txtZipCode.txtType.text!,
                                                                 "country_facta_w8_c":txtCountry1.txtType.text!,
                                                                 "mailing_address_same_w8_c":mailing_address_same_w8_c,
                                                                 "mailing_address_number_w8_c":txtAddress_Other.txtType.text!,
                                                                 "mailing_street_fatca_w8_c":txtStreetName_Other.txtType.text!,
                                                                 "mailing_apt_suite_no_w8_c":txtFlatVillaNo_Other.txtType.text!,
                                                                 "mailing_city_w8_c":txtCity_Other.txtType.text!,
                                                                 "mailing_state_fatca_w8_c":txtState_Other.txtType.text!,
                                                                 "mailing_postal_code_fatca_w8_c":txtZipCode_Other.txtType.text!,
                                                                 "mailing_country_fatca_w8_c":txtCountry_Other.txtType.text!,
                                                                 "us_taxpayer_id_fatca_w8_c":txtUSTaxpayer.txtType.text!,
                                                                 "foreign_tax_id_number_w8_c":txtForeginTax.txtType.text!,
                                                                 "reference_number_w8_c":txtReferenceNumber.txtType.text!
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
