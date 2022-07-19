//
//  CRSVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 14/02/22.
//

import UIKit
import SKCountryPicker

protocol didSelectCRS_protocol {
    func didSelectCRS(txt: String, index: Int)
}

class CRSVC: UIViewController {
    //MARK: - @IBOutlet
    //Step 1
    @IBOutlet weak var viewMain_top: NSLayoutConstraint!
    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var viewStep1_height: NSLayoutConstraint! //229
    @IBOutlet weak var lblTitleStep1: UILabel!
    @IBOutlet weak var tblStep1: UITableView!
    
    //Step 2
    @IBOutlet weak var viewStep2: UIView! //133
    @IBOutlet weak var lblTitleStep2: UILabel!
    @IBOutlet weak var lblYesStep2: UILabel!
    
    //Step 3
    @IBOutlet weak var viewCountryDetail: UIView!
    @IBOutlet weak var viewCountryDetail_height: NSLayoutConstraint! //2160
    @IBOutlet weak var viewSectionLine_height: NSLayoutConstraint! //10
    @IBOutlet weak var viewCountry1: AddCountryCRS!
    @IBOutlet weak var viewCountry2: AddCountryCRS!
    @IBOutlet weak var viewCountry3: AddCountryCRS!
    
    @IBOutlet weak var viewAddCountry: UIView!
    @IBOutlet weak var lblAddCountry: UILabel!
    @IBOutlet weak var lblYouReachedmaximumlimit: UILabel!
    
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var lblbtnSubmit: UILabel!
    
    
    
    //MARK: - Veriable
    var arrListOfDropDown = ManageDropDownOption.getDropDownValue(dropdown_filed: .is_crs_c)
    //["Yes", "No"]
    var selectIndex = 0
    var visibleCountryCount = 1
    var delegate_didSelectCRS_protocol : didSelectCRS_protocol?
    
    var country1ABC = -1
    var country2ABC = -1
    var country3ABC = -1
    
    var selectCountry1Index = -1
    var selectCountry2Index = -1
    var selectCountry3Index = -1
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
        setupTextField()
        setUIStep1()
        tblStep1.reloadData()
        
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblYouReachedmaximumlimit.text = Localize(key: "You have reached a maximum limit of 3 countries")
        lblAddCountry.text = Localize(key: "ADD COUNTRY")
        
        lblbtnSubmit.text = Localize(key: "SUBMIT")
        viewCountry1.btnRemove.setTitle(Localize(key: "REMOVE"), for: .normal)
        viewCountry1.lblTitle.text = Localize(key: "Country Details")
        viewCountry1.lblTitleA.text = Localize(key: "Country1ATitle")
        viewCountry1.lblDetailA.text = Localize(key: "Country1ADetail")
        viewCountry1.lblTitleB.text = Localize(key: "Country1BTitle")
        viewCountry1.lblDetailB.text = Localize(key: "Country1BDetail")
        viewCountry1.lblTitleC.text = Localize(key: "Country1CTitle")
        viewCountry1.lblDetailC.text = Localize(key: "Country1CDetail")
        
        viewCountry2.btnRemove.setTitle(Localize(key: "REMOVE"), for: .normal)
        viewCountry2.lblTitle.text = Localize(key: "Country Details")
        viewCountry2.lblTitleA.text = Localize(key: "Country2ATitle")
        viewCountry2.lblDetailA.text = Localize(key: "Country2ADetail")
        viewCountry2.lblTitleB.text = Localize(key: "Country2BTitle")
        viewCountry2.lblDetailB.text = Localize(key: "Country2BDetail")
        viewCountry2.lblTitleC.text = Localize(key: "Country2CTitle")
        viewCountry2.lblDetailC.text = Localize(key: "Country2CDetail")
        
        viewCountry3.btnRemove.setTitle(Localize(key: "REMOVE"), for: .normal)
        viewCountry3.lblTitle.text = Localize(key: "Country Details")
        viewCountry3.lblTitleA.text = Localize(key: "Country3ATitle")
        viewCountry3.lblDetailA.text = Localize(key: "Country3ADetail")
        viewCountry3.lblTitleB.text = Localize(key: "Country3BTitle")
        viewCountry3.lblDetailB.text = Localize(key: "Country3BDetail")
        viewCountry3.lblTitleC.text = Localize(key: "Country3CTitle")
        viewCountry3.lblDetailC.text = Localize(key: "Country3CDetail")
        
    }
    func registerCell(){
        tblStep1.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }
    func setupTextField(){
        //Country 1
        viewCountry1.delegate_AddCountry_protocol = self
        viewCountry1.txtCountry.setICON(img_: .IMGDropDownGreen, hidden: false)
        viewCountry1.txtCountry.setTitlePlaceholder(text_: "Country/Jurisdiction of Tax residence", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        viewCountry1.txtCountry.btnOpenDropDown.isHidden = false
        viewCountry1.txtCountry.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .country_of_tax_residence_crs_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                viewCountry1.txtCountry.txtType.text = countryName
                selectCountry1Index = selectIndex
                viewCountry1.txtCountry.lblError.isHidden = true
            }
            /*
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .country_of_tax_residence_crs_c)
            self.openDropDownPicker(headerTitle: "Country/Jurisdiction of Tax residence",
                                    dropDownType: "Country1",
                                    arrList: list,
                                    selectedIndex: self.selectCountry1Index)
             */
        }
        
        viewCountry1.txtTIN.setICON(hidden: true)
        viewCountry1.txtTIN.setTitlePlaceholder(text_: Localize(key: "Taxpayer Identification Number (TIN)"), placeholder_: Localize(key: "Enter number"), isUserInteraction: true)
        viewCountry1.txtTIN.delegate_UIFloatingTextField_Protocol = self
        viewCountry1.didTappedABC = { [self] (sender) in
            viewCountry1.txtTIN.lblError.isHidden = true
            viewCountry1.txtTIN.txtType.text = ""
            if sender.tag == 100{
                //A
                country1ABC = 1
                viewCountry1.imgA.image = UIImage(named: "ic_radio_fill")
            }else if sender.tag == 200{
                //B
                country1ABC = 2
                viewCountry1.imgB.image = UIImage(named: "ic_radio_fill")
            }else{
                //C - 300
                country1ABC = 3
                viewCountry1.imgC.image = UIImage(named: "ic_radio_fill")
            }
            fillRadioCountry1()
        }
        
        //Country 2
        viewCountry2.delegate_AddCountry_protocol = self
        viewCountry2.txtCountry.setICON(img_: .IMGDropDownGreen, hidden: false)
        viewCountry2.txtCountry.setTitlePlaceholder(text_: "Country/Jurisdiction of Tax residence", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        viewCountry2.txtCountry.btnOpenDropDown.isHidden = false
        viewCountry2.txtCountry.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .receive_remittance_country2_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                viewCountry2.txtCountry.txtType.text = countryName
                selectCountry2Index = selectIndex
                viewCountry2.txtCountry.lblError.isHidden = true
            }
            /*//--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .receive_remittance_country2_c)
            self.openDropDownPicker(headerTitle: "Country/Jurisdiction of Tax residence",
                                    dropDownType: "Country2",
                                    arrList: list,
                                    selectedIndex: self.selectCountry2Index)*/
        }
        viewCountry2.txtTIN.setICON(hidden: true)
        viewCountry2.txtTIN.setTitlePlaceholder(text_: Localize(key: "Taxpayer Identification Number (TIN)"), placeholder_: Localize(key: "Enter number"), isUserInteraction: true)
        viewCountry2.txtTIN.delegate_UIFloatingTextField_Protocol = self
        viewCountry2.didTappedABC = { [self] (sender) in
            viewCountry2.txtTIN.lblError.isHidden = true
            viewCountry2.txtTIN.txtType.text = ""
            if sender.tag == 100{
                //A
                country2ABC = 1
            }else if sender.tag == 200{
                //B
                country2ABC = 2
            }else{
                //C - 300
                country2ABC = 3
            }
            fillRadioCountry2()
        }
        
        //Country 3
        viewCountry3.delegate_AddCountry_protocol = self
        viewCountry3.txtCountry.setICON(img_: .IMGDropDownGreen, hidden: false)
        viewCountry3.txtCountry.setTitlePlaceholder(text_: "Country/Jurisdiction of Tax residence", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        viewCountry3.txtCountry.btnOpenDropDown.isHidden = false
        viewCountry3.txtCountry.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .receive_remittance_country3_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                viewCountry3.txtCountry.txtType.text = countryName
                selectCountry3Index = selectIndex
                viewCountry3.txtCountry.lblError.isHidden = true
            }
            /*//--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .receive_remittance_country3_c)
            self.openDropDownPicker(headerTitle: "Country/Jurisdiction of Tax residence",
                                    dropDownType: "Country3",
                                    arrList: list,
                                    selectedIndex: self.selectCountry3Index)*/
        }
        viewCountry3.txtTIN.setICON(hidden: true)
        viewCountry3.txtTIN.setTitlePlaceholder(text_: Localize(key: "Taxpayer Identification Number (TIN)"), placeholder_: Localize(key: "Enter number"), isUserInteraction: true)
        viewCountry3.txtTIN.delegate_UIFloatingTextField_Protocol = self
        viewCountry3.didTappedABC = { [self] (sender) in
            viewCountry3.txtTIN.lblError.isHidden = true
            viewCountry3.txtTIN.txtType.text = ""
            if sender.tag == 100{
                //A
                country3ABC = 1
            }else if sender.tag == 200{
                //B
                country3ABC = 2
            }else{
                //C - 300
                country3ABC = 3
            }
            fillRadioCountry3()
        }
    }
    
    func fillRadioCountry1(){
        viewCountry1.imgA.image = UIImage(named: "ic_radio_unfill")
        viewCountry1.imgB.image = UIImage(named: "ic_radio_unfill")
        viewCountry1.imgC.image = UIImage(named: "ic_radio_unfill")
        if country1ABC == 1{
            //A
            viewCountry1.imgA.image = UIImage(named: "ic_radio_fill")
        }else if country1ABC == 2{
            //B
            viewCountry1.imgB.image = UIImage(named: "ic_radio_fill")
        }else if country1ABC == 3{
            //C - 300
            viewCountry1.imgC.image = UIImage(named: "ic_radio_fill")
        }
    }
    func fillRadioCountry2(){
        viewCountry2.imgA.image = UIImage(named: "ic_radio_unfill")
        viewCountry2.imgB.image = UIImage(named: "ic_radio_unfill")
        viewCountry2.imgC.image = UIImage(named: "ic_radio_unfill")
        if country2ABC == 1{
            //A
            viewCountry2.imgA.image = UIImage(named: "ic_radio_fill")
        }else if country2ABC == 2{
            //B
            viewCountry2.imgB.image = UIImage(named: "ic_radio_fill")
        }else if country2ABC == 3{
            //C - 300
            viewCountry2.imgC.image = UIImage(named: "ic_radio_fill")
        }
    }
    func fillRadioCountry3(){
        viewCountry3.imgA.image = UIImage(named: "ic_radio_unfill")
        viewCountry3.imgB.image = UIImage(named: "ic_radio_unfill")
        viewCountry3.imgC.image = UIImage(named: "ic_radio_unfill")
        if country3ABC == 1{
            //A
            viewCountry3.imgA.image = UIImage(named: "ic_radio_fill")
        }else if country3ABC == 2{
            //B
            viewCountry3.imgB.image = UIImage(named: "ic_radio_fill")
        }else if country3ABC == 3{
            //C - 300
            viewCountry3.imgC.image = UIImage(named: "ic_radio_fill")
        }
    }
    
    func setUIStep1(){
        let height = UIScreen.main.bounds.height - 260
        viewMain_top.constant = height
        viewStep1.isHidden = false
        viewStep2.isHidden = true
        viewCountryDetail.isHidden = true
        viewCountryDetail_height.constant = 0
        lblYouReachedmaximumlimit.isHidden = true
        
        //
        setCountryViewUI(index: 1)
    }
    func setUIStep2(){
        viewMain_top.constant = 0
        viewStep1.isHidden = true
        viewStep1_height.constant = 133
        viewStep2.isHidden = false
        viewSectionLine_height.constant = 0
        viewCountryDetail.isHidden = false
        viewCountryDetail_height.constant = 2160
    }
    func setUIStep3(){
        viewMain_top.constant = 0
        viewStep1.isHidden = false
        viewStep1_height.constant = 229
        viewStep2.isHidden = true
        viewSectionLine_height.constant = 10
        viewCountryDetail.isHidden = false
        viewCountryDetail_height.constant = 2160
    }
    
    func setCountryViewUI(index: Int){
        if index == 1{
            viewCountry1.isHidden = false
            viewCountry2.isHidden = true
            viewCountry3.isHidden = true
        }else if index == 2{
            viewCountry1.isHidden = false
            viewCountry2.isHidden = false
            viewCountry3.isHidden = true
        }else if index == 3{
            viewCountry1.isHidden = false
            viewCountry2.isHidden = false
            viewCountry3.isHidden = false
        }
        
        if visibleCountryCount == 1{
            viewCountry1.btnRemove.isHidden = true
            viewCountry2.btnRemove.isHidden = true
            viewCountry3.btnRemove.isHidden = true
        }else{
            viewCountry1.btnRemove.isHidden = false
            viewCountry2.btnRemove.isHidden = false
            viewCountry3.btnRemove.isHidden = false
        }
        
        if visibleCountryCount == 3{
            viewAddCountry.isHidden = true
            lblYouReachedmaximumlimit.isHidden = false
        }else{
            viewAddCountry.isHidden = false
            lblYouReachedmaximumlimit.isHidden = true
        }
    }
    
    //MARK: - @IBAction
    @IBAction func btnBackStep1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnBackStep2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnYesStep2(_ sender: Any) {
        setUIStep3()
    }
    @IBAction func btnAddCountry(_ sender: Any) {
        if visibleCountryCount < 3{
            visibleCountryCount = visibleCountryCount + 1
            setCountryViewUI(index: visibleCountryCount)
        }
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if validateEnput(){
            apiCall_updateApplication()
        }
    }



}

extension CRSVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        /*if droDownType == "Country1"{
            viewCountry1.txtCountry.txtType.text = title
            selectCountry1Index = index
            viewCountry1.txtCountry.lblError.isHidden = true
        }
        if droDownType == "Country2"{
            viewCountry2.txtCountry.txtType.text = title
            selectCountry2Index = index
            viewCountry2.txtCountry.lblError.isHidden = true
        }
        if droDownType == "Country3"{
            viewCountry3.txtCountry.txtType.text = title
            selectCountry3Index = index
            viewCountry3.txtCountry.lblError.isHidden = true
        }*/
    }
}

extension CRSVC: UIFloatingTextField_Protocol{
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
        if viewCountry1.txtTIN.txtType == textField{
            viewCountry1.txtTIN.lblError.isHidden = AppHelper.isNull(viewCountry1.txtTIN.txtType.text!) == false ? true : false
            
            country1ABC = -1
            fillRadioCountry1()
        }
        if viewCountry2.txtTIN.txtType == textField{
            viewCountry2.txtTIN.lblError.isHidden = AppHelper.isNull(viewCountry2.txtTIN.txtType.text!) == false ? true : false
            
            country2ABC = -1
            fillRadioCountry2()
        }
        if viewCountry3.txtTIN.txtType == textField{
            viewCountry3.txtTIN.lblError.isHidden = AppHelper.isNull(viewCountry3.txtTIN.txtType.text!) == false ? true : false
            
            country3ABC = -1
            fillRadioCountry3()
        }
    }
    func validateEnput() -> Bool{
        var returnValue = true
        
        if AppHelper.isNull(viewCountry1.txtCountry.txtType.text!){
            viewCountry1.txtCountry.lblError.isHidden = false
            returnValue = false
        }
        
        if country1ABC == -1{
            if AppHelper.isNull(viewCountry1.txtTIN.txtType.text!){
                viewCountry1.txtTIN.lblError.isHidden = false
                returnValue = false
            }
        }
        if visibleCountryCount > 1{
            if AppHelper.isNull(viewCountry2.txtCountry.txtType.text!){
                viewCountry2.txtCountry.lblError.isHidden = false
                returnValue = false
            }
            if country2ABC == -1{
                if AppHelper.isNull(viewCountry2.txtTIN.txtType.text!){
                    viewCountry2.txtTIN.lblError.isHidden = false
                    returnValue = false
                }
            }
        }
        
        if visibleCountryCount > 2{
            if AppHelper.isNull(viewCountry3.txtCountry.txtType.text!){
                viewCountry3.txtCountry.lblError.isHidden = false
                returnValue = false
            }
            if country3ABC == -1{
                if AppHelper.isNull(viewCountry3.txtTIN.txtType.text!){
                    viewCountry3.txtTIN.lblError.isHidden = false
                    returnValue = false
                }
            }
        }
        
        return returnValue
    }

}

extension CRSVC: UITableViewDelegate, UITableViewDataSource
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
        tblStep1.reloadData()
        
        //--
        if indexPath.row == 0{
           setUIStep2()
            //--
            apiCall_getApplicationData { result in
                self.setFormData(result: result)
            }
        }else{
            
            //--
            delegate_didSelectCRS_protocol?.didSelectCRS(txt: arrListOfDropDown[indexPath.row], index: selectIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}



extension CRSVC: AddCountry_protocol{
    func btnRemove() {
        visibleCountryCount = visibleCountryCount - 1
        setCountryViewUI(index: visibleCountryCount)
    }
  
}

//MARK: - Api Call
extension CRSVC{
    
    
    func setFormData(result: GetApplicationDataResult){
        //--
        let country_of_tax_residence_crs_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .country_of_tax_residence_crs_c, backendvalue: result.country_of_tax_residence_crs_c as? String ?? "")
        viewCountry1.txtCountry.txtType.text = country_of_tax_residence_crs_c.0
        selectCountry1Index = country_of_tax_residence_crs_c.1
        
        viewCountry1.txtTIN.txtType.text = result.tin_c as? String ?? ""
        country1ABC = Int(result.reason_if_no_taxpayerid_crs_c as? String ?? "") ?? -1
        fillRadioCountry1()
        
        //--
        let country_of_tax_residence2_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .receive_remittance_country2_c, backendvalue: result.country_of_tax_residence2_c as? String ?? "")
        viewCountry2.txtCountry.txtType.text = country_of_tax_residence2_c.0
        selectCountry2Index = country_of_tax_residence2_c.1
       
        viewCountry2.txtTIN.txtType.text = result.tin2_c as? String ?? ""
        country2ABC = Int(result.reason_if_no_taxpayerid_crs2_c as? String ?? "") ?? -1
        fillRadioCountry2()
        
        //--
        let country_of_tax_residence3_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .receive_remittance_country3_c, backendvalue: result.country_of_tax_residence3_c as? String ?? "")
        viewCountry3.txtCountry.txtType.text = country_of_tax_residence3_c.0
        selectCountry3Index = country_of_tax_residence3_c.1
        
        viewCountry3.txtTIN.txtType.text = result.tin3_c as? String ?? ""
        country3ABC = Int(result.reason_if_no_taxpayerid_crs3_c as? String ?? "") ?? -1
        fillRadioCountry3()
        
    }
    func apiCall_updateApplication()  {
        //--
        let country_of_tax_residence_crs_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .country_of_tax_residence_crs_c, index: selectCountry1Index)
        let country_of_tax_residence2_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .receive_remittance_country2_c, index: selectCountry2Index)
        let country_of_tax_residence3_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .receive_remittance_country3_c, index: selectCountry3Index)
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.regularityDeclarationScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["country_of_tax_residence_crs_c":country_of_tax_residence_crs_c,
                                                                 "tin_c":viewCountry1.txtTIN.txtType.text!,
                                                                 "reason_if_no_taxpayerid_crs_c":country1ABC,
                                                                 
                                                                 "country_of_tax_residence2_c":country_of_tax_residence2_c,
                                                                 "tin2_c":viewCountry2.txtTIN.txtType.text!,
                                                                 "reason_if_no_taxpayerid_crs2_c":country2ABC,
                                                                 
                                                                 "country_of_tax_residence3_c":country_of_tax_residence3_c,
                                                                 "tin3_c":viewCountry3.txtTIN.txtType.text!,
                                                                 "reason_if_no_taxpayerid_crs3_c":country3ABC
                                                                 ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    
                    //--
                    delegate_didSelectCRS_protocol?.didSelectCRS(txt: (arrListOfDropDown.count != 0 ? arrListOfDropDown[0] : ""), index: selectIndex)
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
