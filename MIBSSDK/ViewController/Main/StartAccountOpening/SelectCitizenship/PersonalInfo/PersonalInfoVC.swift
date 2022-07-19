//
//  PersonalInfoVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 28/01/22.
//

import UIKit
import Foundation
//import MaterialComponents
import Popover
import SKCountryPicker
import Lightbox

class PersonalInfoVC: UIViewController {

    //MARK: @IBOutlet
    //--
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblYourDetails_title: UILabel!
    
    //--
    @IBOutlet var viewAlertPopup: UIView!
    @IBOutlet weak var viewInnerAlertPopup: UIView!
    @IBOutlet weak var lblTitleAlertPopup: UILabel!
    @IBOutlet weak var lblDetailAlertPopup: UILabel!
    @IBOutlet weak var btnGotitAlertPopup: UIButton!
    
    //--
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var lblOnScrollHeader: UILabel!
    @IBOutlet weak var onscrollHeaderView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtSalutation: UIFloatingTextField!
    
    @IBOutlet weak var lblViewSteps_title: UILabel!
    @IBOutlet weak var lblNext_title: UILabel!
    @IBOutlet weak var viewbgbtnNext: UIView!
    @IBOutlet weak var txtFullName: UIFloatingTextField!
    @IBOutlet weak var txtDateofBirth: UIFloatingTextField!
    @IBOutlet weak var txtGender: UIFloatingTextField!
    @IBOutlet weak var txtNationality: UIFloatingTextField!
    @IBOutlet weak var txtIDNo: UIFloatingTextField!
    @IBOutlet weak var txtIDExpiryDate: UIFloatingTextField!
    @IBOutlet weak var txtPassportNo: UIFloatingTextField!
    @IBOutlet weak var txtPassportNo_top: NSLayoutConstraint! //10
    @IBOutlet weak var txtPassportNo_height: NSLayoutConstraint! //81
    @IBOutlet weak var txtPassportExpiryDate: UIFloatingTextField!
    @IBOutlet weak var txtPassportExpiryDate_top: NSLayoutConstraint! //10
    @IBOutlet weak var txtPassportExpiryDate_height: NSLayoutConstraint! //81
    @IBOutlet weak var txtCountryofBirth: UIFloatingTextField!
    @IBOutlet weak var txtCityofBirth: UIFloatingTextField!
    @IBOutlet weak var lblPleaseuploadyourphotoid_title: UILabel!
    @IBOutlet weak var lblTakePhoto_title: UILabel!
    @IBOutlet weak var lblTakePhoto_detail: UILabel!
    @IBOutlet weak var lblOptional_TakeHolding_title: UILabel!
    
    @IBOutlet weak var lblAddressDetails_title: UILabel!
    @IBOutlet weak var txtCountry: UIFloatingTextField!
    @IBOutlet weak var txtResidentialStatus: UIFloatingTextField!
    @IBOutlet weak var txtPleaseSpecifyCountry: UIFloatingTextField!
    @IBOutlet weak var txtPleaseSpecifyCountry_height: NSLayoutConstraint! //81
    @IBOutlet weak var txtPleaseSpecifyCountry_top: NSLayoutConstraint! //10
    @IBOutlet weak var txtPOBox: UIFloatingTextField!
    @IBOutlet weak var txtPOBox_height: NSLayoutConstraint!
    @IBOutlet weak var txtPOBox_top: NSLayoutConstraint!
    @IBOutlet weak var txtPostalCode: UIFloatingTextField!
    @IBOutlet weak var txtHouseFlatNumber: UIFloatingTextField!
    @IBOutlet weak var txtCity: UIFloatingTextField!
    @IBOutlet weak var txtArea: UIFloatingTextField!
    
    @IBOutlet weak var lblEmploymentDetails_title: UILabel!
    @IBOutlet weak var txtEmploymentStatus: UIFloatingTextField!
    @IBOutlet weak var txtIndustry: UIFloatingTextField!
    @IBOutlet weak var txtEmploymentSector: UIFloatingTextField!
    @IBOutlet weak var txtEmployername: UIFloatingTextField!
    @IBOutlet weak var txtProfession: UIFloatingTextField!
    @IBOutlet weak var txtNameofBusiness: UIFloatingTextField!
    @IBOutlet weak var imgDoneHoldingImage: UIImageView!
    
    @IBOutlet weak var txtEducationLevel: UIFloatingTextField!
    
    @IBOutlet weak var imgViewTakePhoto: UIImageView!
    @IBOutlet weak var btnViewTakePhotoHoldingId: UIButton!
    
    
    
    //MARK: Veriable
    var scanFrontDocData: ValidateOmniData?
    var scanBackDocData: ValidateOmniData?
    var scanPasswordData: ValidateOmniData?
    
    var popover = Popover()
    var delegate_didTakeCustomPhoto: didTakeCustomPhoto_protocol?
    var citizenshipType = CitizenshipType.non
    var selectSalutationIndex = -1
    var selectGenderIndex = -1
    var selectCountryofNationalityIndex = -1
    var selectCountryofBirthIndex = -1
    var selectCountryIndex = -1
    var selectResidentialStatusIndex = -1
    var selectPostalCodeIndex = -1
    var selectEmployementStatusIndex = -1
    var selectIndustryIndex = -1
    var selectEmployementSectorIndex = -1
    var selectProfessionIndex = -1
    var takedHoldingIDImage = UIImageView()
    var isSelectHoldingImg = false
    var selectEducationLevelIndex = -1
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        managePassportDetailsTextField()
        setupBasic()
        setupHeader()
        hideTakePhotoHolding()
        
        apiCall_getApplicationData { result in
            self.setFormData(result: result)
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        progressBar.setProgress(0.33, animated: true)
        localization()
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        self.view.endEditing(true)
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        
        //--
        lblOnScrollHeader.text = Localize(key: "Personal Information")
        lblTitle.attributedText = Localize(key: "Personal Information").attributedStringWithColor(["Personal"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Personal Information detail")
        
        lblPleaseuploadyourphotoid_title.text = Localize(key: "Please upload your photo holding the ID")
        lblTakePhoto_title.text = Localize(key: "Take Photo")
        lblOptional_TakeHolding_title.text = Localize(key: "*optional")
        lblAddressDetails_title.text = Localize(key: "Address Details")
        lblEmploymentDetails_title.text = Localize(key: "Employment Details")
        lblViewSteps_title.text = Localize(key: "VIEW STEPS")
        lblNext_title.text = Localize(key: "NEXT")
        
        
        //--
        if Managelanguage.getLanguageCode() == "ar"
        {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            lblYourDetails_title.semanticContentAttribute = .forceRightToLeft
            lblPleaseuploadyourphotoid_title.semanticContentAttribute = .forceRightToLeft
            lblTakePhoto_title.semanticContentAttribute = .forceRightToLeft
            lblOptional_TakeHolding_title.semanticContentAttribute = .forceRightToLeft
            lblAddressDetails_title.semanticContentAttribute = .forceRightToLeft
            lblEmploymentDetails_title.semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            lblTitle.semanticContentAttribute = .forceLeftToRight
            lblDetail.semanticContentAttribute = .forceLeftToRight
            lblYourDetails_title.semanticContentAttribute = .forceLeftToRight
            lblPleaseuploadyourphotoid_title.semanticContentAttribute = .forceLeftToRight
            lblTakePhoto_title.semanticContentAttribute = .forceLeftToRight
            lblOptional_TakeHolding_title.semanticContentAttribute = .forceLeftToRight
            lblAddressDetails_title.semanticContentAttribute = .forceLeftToRight
            lblEmploymentDetails_title.semanticContentAttribute = .forceLeftToRight
        }
    }
    func setupBasic(){
        
        //--

        
       
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.btnScheduleaCall.setTitle(Localize(key: "Schedule a Call"), for: .normal)
        headerView.didTappedBack = { (sender) in
            if self.citizenshipType == .omani{
                //--
                let vc = OmaniCitizenshipDocVC(nibName: "OmaniCitizenshipDocVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: false)
            }else if self.citizenshipType == .expatriate{
                //--
                let vc = ExpatrIateCitizenshipDoc(nibName: "ExpatrIateCitizenshipDoc", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: false)
            }else{
                //--
                let vc = GCCNationalsCitizenshipDocVC(nibName: "GCCNationalsCitizenshipDocVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    func managePassportDetailsTextField(){
        
        if citizenshipType == .omani{
            txtPassportNo.isHidden = true
            txtPassportNo_top.constant = 0
            txtPassportNo_height.constant = 0
            
            txtPassportExpiryDate.isHidden = true
            txtPassportExpiryDate_top.constant = 0
            txtPassportExpiryDate_height.constant = 0
            
        }else{
            txtPassportExpiryDate.isHidden = false
            txtPassportExpiryDate_top.constant = 10
            txtPassportExpiryDate_height.constant = 81
        }
        
        //--
        set_OCR_Dtail()
    }
    
    func set_OCR_Dtail(){
        
        if citizenshipType == .gcc{
            txtFullName.txtType.text = "\(scanBackDocData?.first_name ?? "") \(scanBackDocData?.last_name ?? "")"
            txtDateofBirth.txtType.text = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: scanBackDocData?.date_of_birth ?? "")
            txtIDNo.txtType.text = "\(scanBackDocData?.ID ?? "")"
            txtIDExpiryDate.txtType.text = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: scanBackDocData?.exp_date ?? "")
        }else{
            txtFullName.txtType.text = "\(scanBackDocData?.first_name ?? "") \(scanBackDocData?.last_name ?? "")"
            txtDateofBirth.txtType.text = scanFrontDocData?.date_of_birth ?? ""
            txtIDNo.txtType.text = "\(scanFrontDocData?.civil_id ?? 0)"
            txtIDExpiryDate.txtType.text = scanFrontDocData?.civil_id_expiry_date ?? ""
        }
        
        //set passport detail
        if citizenshipType == .expatriate || citizenshipType == .gcc{
            txtPassportNo.txtType.text = "\(scanPasswordData?.passport_number ?? "")"
            txtPassportExpiryDate.txtType.text = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: scanPasswordData?.exp_date ?? "")
        }
    }
    
    func setupTextField(){
        //Your details
        txtSalutation.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtSalutation.setTitlePlaceholder(text_: "Salutation", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtSalutation.btnOpenDropDown.isHidden = false
        txtSalutation.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .salutation_c)
            self.openDropDownPicker(headerTitle: "",
                                    dropDownType: "salutation",
                                    arrList: list,
                                    selectedIndex: self.selectSalutationIndex)
        }
        
        txtFullName.setICON(img_: .IMGDoneGreen, hidden: false)
        txtFullName.setTitlePlaceholder(text_: Localize(key: "Full Name"), placeholder_: Localize(key: "Full Name"), isUserInteraction: false)
        txtFullName.btnOpenDropDown.isHidden = false
        txtFullName.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtDateofBirth.setICON(img_: .IMGDoneGreen, hidden: false)
        txtDateofBirth.setTitlePlaceholder(text_: Localize(key: "Date of Birth"), placeholder_: Localize(key: "Date of Birth"), isUserInteraction: false)
        txtDateofBirth.btnOpenDropDown.isHidden = false
        txtDateofBirth.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtGender.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtGender.setTitlePlaceholder(text_: Localize(key: "Gender"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtGender.btnOpenDropDown.isHidden = false
        txtGender.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .gender_c)
            self.openDropDownPicker(headerTitle: "Gender",
                                    dropDownType: "gender",
                                    arrList: list,
                                    selectedIndex: self.selectGenderIndex)
        }
        
        txtNationality.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtNationality.setTitlePlaceholder(text_: Localize(key: "Nationality"), placeholder_: Localize(key: "Nationality"), isUserInteraction: true)
        txtNationality.btnOpenDropDown.isHidden = false
        txtNationality.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .nationality_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                txtNationality.setSelectedDropDownUI()
                txtNationality.txtType.text = countryName
                selectCountryofNationalityIndex = selectIndex
                txtNationality.lblError.isHidden = true
            }
            /*
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .nationality_c)
            self.openDropDownPicker(headerTitle: "Country of Nationality",
                                    dropDownType: "country_of_nationality",
                                    arrList: list,
                                    selectedIndex: self.selectCountryofNationalityIndex)*/
        }
        
        txtIDNo.setICON(img_: .IMGDoneGreen, hidden: false)
        txtIDNo.setTitlePlaceholder(text_: Localize(key: "ID No."), placeholder_: Localize(key: "ID No."), isUserInteraction: false)
        txtIDNo.btnOpenDropDown.isHidden = false
        txtIDNo.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtIDExpiryDate.setICON(img_: .IMGDoneGreen, hidden: false)
        txtIDExpiryDate.setTitlePlaceholder(text_: Localize(key: "ID Expiry Date"), placeholder_: Localize(key: "ID Expiry Date"), isUserInteraction: false)
        txtIDExpiryDate.btnOpenDropDown.isHidden = false
        txtIDExpiryDate.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtPassportNo.setICON(img_: .IMGDoneGreen, hidden: false)
        txtPassportNo.setTitlePlaceholder(text_: Localize(key: "Passport No"), placeholder_: Localize(key: "Passport No"), isUserInteraction: false)
        txtPassportNo.btnOpenDropDown.isHidden = false
        txtPassportNo.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtPassportExpiryDate.setICON(img_: .IMGDoneGreen, hidden: false)
        txtPassportExpiryDate.setTitlePlaceholder(text_: Localize(key: "Passport Expiry Date"), placeholder_: Localize(key: "Passport Expiry Date"), isUserInteraction: false)
        txtPassportExpiryDate.btnOpenDropDown.isHidden = false
        txtPassportExpiryDate.didTappedDropDown = { (sender) in
            self.openErrorAlert(title: "Sorry!", details: "To edit this field, you will need to re-scan your Passport")
        }
        
        txtCountryofBirth.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountryofBirth.setTitlePlaceholder(text_: Localize(key: "Country of Birth"), placeholder_: Localize(key: "Select"), isUserInteraction: false)
        txtCountryofBirth.btnOpenDropDown.isHidden = false
        txtCountryofBirth.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .country_of_birth_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                txtCountryofBirth.setSelectedDropDownUI()
                txtCountryofBirth.txtType.text = countryName
                selectCountryofBirthIndex = selectIndex
                txtCountryofBirth.lblError.isHidden = true
            }
            /*
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .country_of_birth_c)
            self.openDropDownPicker(headerTitle: "Country of Birth",
                                    dropDownType: "country_of_birth",
                                    arrList: list,
                                    selectedIndex: self.selectCountryofBirthIndex)*/
        }
        
        txtCityofBirth.setICON(hidden: true)
        txtCityofBirth.setTitlePlaceholder(text_: Localize(key: "City of Birth"), placeholder_: Localize(key: "Enter City"), isUserInteraction: true)
        txtCityofBirth.delegate_UIFloatingTextField_Protocol = self
        
        //Address Detail
        txtCountry.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtCountry.setTitlePlaceholder(text_: Localize(key: "Country"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtCountry.btnOpenDropDown.isHidden = false
        txtCountry.didTappedDropDown = { (sender) in
            //--
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                txtCountry.setSelectedDropDownUI()
                txtCountry.txtType.text = countryName
                selectCountryIndex = selectIndex
                txtCountry.lblError.isHidden = true
            }
            /*
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .resident_country_c)
            self.openDropDownPicker(headerTitle: "Country",
                                    dropDownType: "country",
                                    arrList: list,
                                    selectedIndex: self.selectCountryIndex)*/
        }
        
        txtResidentialStatus.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtResidentialStatus.setTitlePlaceholder(text_: Localize(key: "Residential Status"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtResidentialStatus.btnOpenDropDown.isHidden = false
        txtResidentialStatus.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .resident_status_c)
            self.openDropDownPicker(headerTitle: "Residential Status",
                                    dropDownType: "residential_status",
                                    arrList: list,
                                    selectedIndex: self.selectResidentialStatusIndex)
        }
        
        txtPleaseSpecifyCountry.setICON(hidden: true)
        txtPleaseSpecifyCountry.setTitlePlaceholder(text_: Localize(key: "Please Specify"), placeholder_: Localize(key: "Please Specify Country"), isUserInteraction: true)
        txtPleaseSpecifyCountry.hiddenTextField(txtView: txtPleaseSpecifyCountry, layoutConTop: txtPleaseSpecifyCountry_top, layoutConHeight: txtPleaseSpecifyCountry_height)
        
        txtPOBox.setICON(hidden: true)
        txtPOBox.setTitlePlaceholder(text_: Localize(key: "P.O Box"), placeholder_: Localize(key: "Enter P.O Box number"), isUserInteraction: true)
        txtPOBox.delegate_UIFloatingTextField_Protocol = self
        
        txtPostalCode.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtPostalCode.setTitlePlaceholder(text_: Localize(key: "Postal Code"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtPostalCode.btnOpenDropDown.isHidden = false
        txtPostalCode.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownBackendValueList(dropdown_filed: .resident_postal_code_c)
            self.openDropDownPicker(headerTitle: "Postal Code",
                                    dropDownType: "postal_code",
                                    arrList: list,
                                    selectedIndex: self.selectPostalCodeIndex)
        }
        
        txtHouseFlatNumber.setICON(hidden: true)
        txtHouseFlatNumber.setTitlePlaceholder(text_: Localize(key: "House/Flat Number"), placeholder_: Localize(key: "Enter Number"), isUserInteraction: true)
        txtHouseFlatNumber.delegate_UIFloatingTextField_Protocol = self
        
        txtCity.setICON(hidden: true)
        txtCity.setTitlePlaceholder(text_: "City", placeholder_: Localize(key: "Enter City"), isUserInteraction: false)
        txtCity.delegate_UIFloatingTextField_Protocol = self
        
        txtArea.setICON(hidden: true)
        txtArea.setTitlePlaceholder(text_: Localize(key: "Area"), placeholder_: Localize(key: "Enter Area"), isUserInteraction: true)
        txtArea.delegate_UIFloatingTextField_Protocol = self
        
        //Employment Details
        txtEmploymentStatus.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtEmploymentStatus.setTitlePlaceholder(text_: Localize(key: "Employment status"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtEmploymentStatus.btnOpenDropDown.isHidden = false
        txtEmploymentStatus.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .employment_status_c)
            self.openDropDownPicker(headerTitle: "Employment Status",
                                    dropDownType: "employment_status",
                                    arrList: list,
                                    selectedIndex: self.selectEmployementStatusIndex)
        }
        
        txtIndustry.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtIndustry.setTitlePlaceholder(text_: Localize(key: "Industry"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtIndustry.btnOpenDropDown.isHidden = false
        txtIndustry.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .industry_type_c)
            self.openDropDownPicker(headerTitle: "Industry",
                                    dropDownType: "industry",
                                    arrList: list,
                                    selectedIndex: self.selectIndustryIndex)
        }
        
        txtEmploymentSector.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtEmploymentSector.setTitlePlaceholder(text_: Localize(key: "Employment sector"), placeholder_: Localize(key: "Select"), isUserInteraction: false)
        txtEmploymentSector.btnOpenDropDown.isHidden = false
        txtEmploymentSector.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .employment_sector_c)
            self.openDropDownPicker(headerTitle: "Employment sector",
                                    dropDownType: "employment_sector",
                                    arrList: list,
                                    selectedIndex: self.selectEmployementSectorIndex)
        }
        
        txtEmployername.setICON(hidden: true)
        txtEmployername.setTitlePlaceholder(text_: Localize(key: "Employer Name"), placeholder_: Localize(key: "Enter Employer Name"), isUserInteraction: true)
        txtEmployername.delegate_UIFloatingTextField_Protocol = self
        
        txtProfession.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtProfession.setTitlePlaceholder(text_: Localize(key: "Profession"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtProfession.btnOpenDropDown.isHidden = false
        txtProfession.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .profession_c)
            self.openDropDownPicker(headerTitle: "Profession",
                                    dropDownType: "profession",
                                    arrList: list,
                                    selectedIndex: self.selectProfessionIndex)
        }
        
        txtNameofBusiness.setICON(hidden: true)
        txtNameofBusiness.setTitlePlaceholder(text_: Localize(key: "Name of Business"), placeholder_: Localize(key: "Enter Name of Business"), isUserInteraction: true)
        txtNameofBusiness.delegate_UIFloatingTextField_Protocol = self
        
        txtEducationLevel.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtEducationLevel.setTitlePlaceholder(text_: "Education level", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtEducationLevel.btnOpenDropDown.isHidden = false
        txtEducationLevel.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .education_level_c)
            self.openDropDownPicker(headerTitle: "Education level",
                                    dropDownType: "education_level",
                                    arrList: list,
                                    selectedIndex: self.selectEducationLevelIndex)
        }
        
        defaultEmploymentDetailsView()
        
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
    
    //MARK: @IBAction
    @IBAction func btnGotitAlertPopup(_ sender: Any) {
        popover.dismiss()
    }
    @IBAction func btnBackOnScrollHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMenuOnScrollHeader(_ sender: Any) {
        //--
        let vc = ScheduleCallOptionAlertVC(nibName: "ScheduleCallOptionAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnViewSteps(_ sender: Any) {
        //--
        let vc = StepIndicatorVC(nibName: "StepIndicatorVC", bundle: nil)
        vc.selectIndex = 0
        vc.totalStep = 3
        vc.progress = 0.33
        vc.arrListOfDropDown = [Localize(key: "Personal Information"), Localize(key: "Financial Information"), Localize(key: "Regularity Declaration")]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        if validateEnput(){
            apiCall_UploadImage()
        }
        
    }
    @IBAction func btnTakePhotoHoldingID(_ sender: Any) {
        let vc = CustomCameraVC(nibName: "CustomCameraVC", bundle: nil)
        vc.delegate_didTakeCustomPhoto = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.avCaptureDevicePosition = .front
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnViewTakePhotoHoldingId(_ sender: Any) {
        if let img_ = takedHoldingIDImage.image{
            setupLightBoxImageArray(imgOpen: img_, msg: "")
        }
    }
    
    
}

extension PersonalInfoVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        if droDownType == "salutation"{
            txtSalutation.setSelectedDropDownUI()
            txtSalutation.txtType.text = title
            selectSalutationIndex = index
            txtSalutation.lblError.isHidden = true
        }
        if droDownType == "gender"{
            txtGender.setSelectedDropDownUI()
            txtGender.txtType.text = title
            selectGenderIndex = index
            txtGender.lblError.isHidden = true
        }
        /*if droDownType == "country_of_nationality"{
            txtNationality.setSelectedDropDownUI()
            txtNationality.txtType.text = title
            selectCountryofNationalityIndex = index
            txtNationality.lblError.isHidden = true
        }
        if droDownType == "country_of_birth"{
            txtCountryofBirth.setSelectedDropDownUI()
            txtCountryofBirth.txtType.text = title
            selectCountryofBirthIndex = index
            txtCountryofBirth.lblError.isHidden = true
        }*/
        /*if droDownType == "country"{
            txtCountry.setSelectedDropDownUI()
            txtCountry.txtType.text = title
            selectCountryIndex = index
            txtCountry.lblError.isHidden = true
        }*/
        if droDownType == "residential_status"{
            txtResidentialStatus.setSelectedDropDownUI()
            txtResidentialStatus.txtType.text = title
            selectResidentialStatusIndex = index
            txtResidentialStatus.lblError.isHidden = true
            if index == 0{
                txtPleaseSpecifyCountry.hiddenTextField(txtView: txtPleaseSpecifyCountry, layoutConTop: txtPleaseSpecifyCountry_top, layoutConHeight: txtPleaseSpecifyCountry_height)
            }else{
                txtPleaseSpecifyCountry.showTextField(txtView: txtPleaseSpecifyCountry, layoutConTop: txtPleaseSpecifyCountry_top, layoutConHeight: txtPleaseSpecifyCountry_height)
            }
        }
        if droDownType == "postal_code"{
            txtPostalCode.setSelectedDropDownUI()
            txtPostalCode.txtType.text = title
            selectPostalCodeIndex = index
            txtPostalCode.lblError.isHidden = true
            //-- Set City
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .resident_postal_code_c)
            txtCity.txtType.text = list[selectPostalCodeIndex]
        }
        if droDownType == "employment_status"{
            txtEmploymentStatus.setSelectedDropDownUI()
            txtEmploymentStatus.txtType.text = title
            selectEmployementStatusIndex = index
            txtEmploymentStatus.lblError.isHidden = true
            
            let employment_status_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .employment_status_c, index: selectEmployementStatusIndex)
            manageEmploymentDetailView(backendValue: employment_status_c)
        }
        if droDownType == "industry"{
            txtIndustry.setSelectedDropDownUI()
            txtIndustry.txtType.text = title
            selectIndustryIndex = index
            txtIndustry.lblError.isHidden = true
        }
        if droDownType == "employment_sector"{
            txtEmploymentSector.setSelectedDropDownUI()
            txtEmploymentSector.txtType.text = title
            selectEmployementSectorIndex = index
            txtEmploymentSector.lblError.isHidden = true
        }
        if droDownType == "profession"{
            txtProfession.setSelectedDropDownUI()
            txtProfession.txtType.text = title
            selectProfessionIndex = index
            txtProfession.lblError.isHidden = true
        }
        if droDownType == "education_level"{
            txtEducationLevel.setSelectedDropDownUI()
            txtEducationLevel.txtType.text = title
            selectEducationLevelIndex = index
            txtEducationLevel.lblError.isHidden = true
        }
        
    
    }
    
    func manageEmploymentDetailView(backendValue: String){
        if backendValue == "1"{
            //Employed
            selectEmployementSectorIndex = -1
            txtEmploymentSector.txtType.text = "Other"
            txtEmploymentSector.setbtnDropDownUserInteraction(isUserInteraction: true)
            
            txtEmployername.isHidden = false
            txtEmployername.txtType.text = ""
            
            txtNameofBusiness.isHidden = true
            txtNameofBusiness.txtType.text = ""
        }else if backendValue == "6_7" || backendValue == "4" || backendValue == "6_6"{
            //"Business man", "Self-Employed", "Investor",
            
            selectEmployementSectorIndex = -1
            txtEmploymentSector.txtType.text = "Other"
            txtEmploymentSector.setbtnDropDownUserInteraction(isUserInteraction: false)
            
            txtEmployername.isHidden = true
            txtEmployername.txtType.text = ""
            
            txtNameofBusiness.isHidden = false
            txtNameofBusiness.txtType.text = ""
        }else{
            defaultEmploymentDetailsView()
        }
    }
    func defaultEmploymentDetailsView(){
        
        selectEmployementSectorIndex = -1
        txtEmploymentSector.txtType.text = "Other"
        txtEmploymentSector.setbtnDropDownUserInteraction(isUserInteraction: false)
        
        txtEmployername.isHidden = true
        txtEmployername.txtType.text = ""
        
        txtNameofBusiness.isHidden = true
        txtNameofBusiness.txtType.text = ""
        
    }
    
}

extension PersonalInfoVC: didTakeCustomPhoto_protocol{
    func didTakeCustomPhoto_protocol(image_: UIImage) {
        isSelectHoldingImg = true
        takedHoldingIDImage.image = image_
        selectTakePhotoHolding()
    }
    
    func selectTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = false
        imgViewTakePhoto.isHidden = false
        imgDoneHoldingImage.image = .IMGDoneGreen
        lblTakePhoto_detail.text = "Profile Pic.png"
    }
    func hideTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = true
        imgViewTakePhoto.isHidden = true
        lblTakePhoto_detail.text = ""
    }
}

extension PersonalInfoVC: UIFloatingTextField_Protocol{
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool {
        return true
    }
    
    
    func btnOpenCountryCodePicker(textField: UITextField) {
        self.view.endEditing(true)
        
    }
    func editingChanged(textField: UITextField) {
        validateErrorMsg(textField: textField)
        
    }
    func shouldChangeCharactersIn(textField: UITextField, txt: String) {
        
    }
    func textFieldDidBeginEditing(textField: UITextField){
        
    }
    
    
    //Validation
    func validateErrorMsg(textField: UITextField){
        if txtSalutation.txtType == textField{
            txtSalutation.lblError.isHidden = AppHelper.isNull(txtSalutation.txtType.text!) == false ? true : false
        }
        if txtGender.txtType == textField{
            txtGender.lblError.isHidden = AppHelper.isNull(txtGender.txtType.text!) == false ? true : false
        }
        if txtNationality.txtType == textField{
            txtNationality.lblError.isHidden = AppHelper.isNull(txtNationality.txtType.text!) == false ? true : false
        }
        if txtCountryofBirth.txtType == textField{
            txtCountryofBirth.lblError.isHidden = AppHelper.isNull(txtCountryofBirth.txtType.text!) == false ? true : false
        }
        if txtCityofBirth.txtType == textField{
            txtCityofBirth.lblError.isHidden = AppHelper.isNull(txtCityofBirth.txtType.text!) == false ? true : false
        }
        if txtCountry.txtType == textField{
            txtCountry.lblError.isHidden = AppHelper.isNull(txtCountry.txtType.text!) == false ? true : false
        }
        if txtResidentialStatus.txtType == textField{
            txtResidentialStatus.lblError.isHidden = AppHelper.isNull(txtResidentialStatus.txtType.text!) == false ? true : false
        }
        if txtPOBox.txtType == textField{
            txtPOBox.lblError.isHidden = AppHelper.isNull(txtPOBox.txtType.text!) == false ? true : false
        }
        if txtPostalCode.txtType == textField{
            txtPostalCode.lblError.isHidden = AppHelper.isNull(txtPostalCode.txtType.text!) == false ? true : false
        }
        if txtArea.txtType == textField{
            txtArea.lblError.isHidden = AppHelper.isNull(txtArea.txtType.text!) == false ? true : false
        }
        if txtEmploymentStatus.txtType == textField{
            txtEmploymentStatus.lblError.isHidden = AppHelper.isNull(txtEmploymentStatus.txtType.text!) == false ? true : false
        }
        if txtIndustry.txtType == textField{
            txtIndustry.lblError.isHidden = AppHelper.isNull(txtIndustry.txtType.text!) == false ? true : false
        }
        if txtProfession.txtType == textField{
            txtProfession.lblError.isHidden = AppHelper.isNull(txtProfession.txtType.text!) == false ? true : false
        }
        if txtEducationLevel.txtType == textField{
            txtEducationLevel.lblError.isHidden = AppHelper.isNull(txtEducationLevel.txtType.text!) == false ? true : false
        }
        
        let employment_status_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .employment_status_c, index: selectEmployementStatusIndex)
        if employment_status_c == "1"{
            //Employed
            if txtEmployername.txtType == textField{
                txtEmployername.lblError.isHidden = AppHelper.isNull(txtEmployername.txtType.text!) == false ? true : false
            }
            
        }else if employment_status_c == "6_7" || employment_status_c == "4" || employment_status_c == "6_6"{
            //"Business man", "Self-Employed", "Investor",
            if txtNameofBusiness.txtType == textField{
                txtNameofBusiness.lblError.isHidden = AppHelper.isNull(txtNameofBusiness.txtType.text!) == false ? true : false
            }
        }else{
            
        }
    }
    func validateEnput() -> Bool{
        var returnValue = true
        if AppHelper.isNull(txtSalutation.txtType.text!){
            txtSalutation.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtGender.txtType.text!){
            txtGender.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtNationality.txtType.text!){
            txtNationality.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCountryofBirth.txtType.text!){
            txtCountryofBirth.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCityofBirth.txtType.text!){
            txtCityofBirth.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtCountry.txtType.text!){
            txtCountry.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtResidentialStatus.txtType.text!){
            txtResidentialStatus.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtPOBox.txtType.text!){
            txtPOBox.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtPostalCode.txtType.text!){
            txtPostalCode.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtArea.txtType.text!){
            txtArea.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtEmploymentStatus.txtType.text!){
            txtEmploymentStatus.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtIndustry.txtType.text!){
            txtIndustry.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtProfession.txtType.text!){
            txtProfession.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtEducationLevel.txtType.text!){
            txtEducationLevel.lblError.isHidden = false
            returnValue = false
        }
        
        let employment_status_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .employment_status_c, index: selectEmployementStatusIndex)
        if employment_status_c == "1"{
            //Employed
            
            if AppHelper.isNull(txtEmployername.txtType.text!){
                txtEmployername.lblError.isHidden = false
                returnValue = false
            }
            
        }else if employment_status_c == "6_7" || employment_status_c == "4" || employment_status_c == "6_6"{
            //"Business man", "Self-Employed", "Investor",
            
            if AppHelper.isNull(txtNameofBusiness.txtType.text!){
                txtNameofBusiness.lblError.isHidden = false
                returnValue = false
            }
        }else{
            
        }
        
        return returnValue
    }
    
}

extension PersonalInfoVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollContainer{
            if scrollContainer.contentOffset.y > 370{
                onscrollHeaderView.isHidden = false
            }else{
                onscrollHeaderView.isHidden = true
            }
        }
    }
}

//MARK: - Api Call
extension PersonalInfoVC{
    
    func setFormData(result: GetApplicationDataResult){
        if (scanBackDocData?.first_name ?? "").count == 0{
            
            let date_of_birth_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: result.date_of_birth_c as? String ?? "")
            let civil_id_expiry_date_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: result.civil_id_expiry_date_c as? String ?? "")
            let passport_expiry_date_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "yyyy-MM-dd", dateNewFTR: "dd/MM/yyyy", strDate: result.passport_expiry_date_c as? String ?? "")
            
            txtFullName.txtType.text = result.full_name_c as? String ?? ""
            txtDateofBirth.txtType.text = date_of_birth_c
            txtIDNo.txtType.text = result.civil_id_c as? String ?? ""
            txtIDExpiryDate.txtType.text = civil_id_expiry_date_c
          
            //set passport detail
            if citizenshipType == .expatriate || citizenshipType == .gcc{
                txtPassportNo.txtType.text = result.passport_number_c as? String ?? ""
                txtPassportExpiryDate.txtType.text = passport_expiry_date_c
            }
        }
        
        //--
        let salutation_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .salutation_c, backendvalue: result.salutation_c as? String ?? "")
        txtSalutation.txtType.text = salutation_c.0
        selectSalutationIndex = salutation_c.1
        
        let gender_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .gender_c, backendvalue: result.gender_c as? String ?? "")
        txtGender.txtType.text = gender_c.0
        selectGenderIndex = gender_c.1
        
        let nationality_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .nationality_c, backendvalue: result.nationality_c as? String ?? "")
        txtNationality.txtType.text = nationality_c.0
        selectCountryofNationalityIndex = nationality_c.1
        
        let country_of_birth_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .country_of_birth_c, backendvalue: result.country_of_birth_c as? String ?? "")
        txtCountryofBirth.txtType.text = country_of_birth_c.0
        selectCountryofBirthIndex = country_of_birth_c.1
        
        txtCityofBirth.txtType.text = result.city_of_birth_c as? String ?? ""
        txtCountry.txtType.text = result.resident_country_c as? String ?? ""
        
        let resident_status_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .resident_status_c, backendvalue: result.resident_status_c as? String ?? "")
        txtResidentialStatus.txtType.text = resident_status_c.0
        selectResidentialStatusIndex = resident_status_c.1
        if selectResidentialStatusIndex == 0{
            txtPleaseSpecifyCountry.hiddenTextField(txtView: txtPleaseSpecifyCountry, layoutConTop: txtPleaseSpecifyCountry_top, layoutConHeight: txtPleaseSpecifyCountry_height)
        }else{
            txtPleaseSpecifyCountry.showTextField(txtView: txtPleaseSpecifyCountry, layoutConTop: txtPleaseSpecifyCountry_top, layoutConHeight: txtPleaseSpecifyCountry_height)
        }
        
        txtPOBox.txtType.text = result.resident_po_box_c as? String ?? ""
        
        let resident_postal_code_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .resident_postal_code_c, backendvalue: result.resident_postal_code_c as? String ?? "")
        txtPostalCode.txtType.text = result.resident_postal_code_c as? String ?? ""
        selectPostalCodeIndex = resident_postal_code_c.1
        
        txtHouseFlatNumber.txtType.text = result.resident_house_no_c as? String ?? ""
        txtCity.txtType.text = result.city_c as? String ?? ""
        txtArea.txtType.text = result.area_c as? String ?? ""
        
        let resident_country_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .resident_country_c, backendvalue: result.resident_country_c as? String ?? "")
        txtCountry.txtType.text = resident_country_c.0
        selectCountryIndex = resident_country_c.1
        
        let employment_status_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .employment_status_c, backendvalue: result.employment_status_c as? String ?? "")
        txtEmploymentStatus.txtType.text = employment_status_c.0
        selectEmployementStatusIndex = employment_status_c.1
        manageEmploymentDetailView(backendValue: result.employment_status_c as? String ?? "")
        
        let industry_type_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .industry_type_c, backendvalue: result.industry_type_c as? String ?? "")
        txtIndustry.txtType.text = industry_type_c.0
        selectIndustryIndex = industry_type_c.1
        
        let employment_sector_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .employment_sector_c, backendvalue: result.employment_sector_c as? String ?? "")
        txtEmploymentSector.txtType.text = employment_sector_c.0.count == 0 ? "Other" : employment_sector_c.0
        selectEmployementSectorIndex = employment_sector_c.1
        
        txtEmployername.txtType.text = result.employer_name_c as? String ?? ""
        
        let profession_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .profession_c, backendvalue: result.profession_c as? String ?? "")
        txtProfession.txtType.text = profession_c.0
        selectProfessionIndex = profession_c.1
        
        txtNameofBusiness.txtType.text = result.name_of_business_c as? String ?? ""
        txtPleaseSpecifyCountry.txtType.text = result.other_resident_country_c as? String ?? ""
        
        let education_level_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .education_level_c, backendvalue: result.education_level_c as? String ?? "")
        txtEducationLevel.txtType.text = education_level_c.0
        selectEducationLevelIndex = education_level_c.1
        
        //--
        getDocumentsList()
    }

    func getDocumentsList(){
        //LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getDocumentsList (showProgress: false){ [self] docResult in
            //LoadingView.shared.dismissLoadingView()
            docResult.documents.forEach { getDocumentsListDocuments in
                if getDocumentsListDocuments.document_type == docTypeBackendValue(value: docType.customer_photo.rawValue) &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.other)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        isSelectHoldingImg = true
                        takedHoldingIDImage.setImage(url: url)
                        imgDoneHoldingImage.image = .IMGDoneGreen
                        selectTakePhotoHolding()
                    }
                }
            }
        }
    }
    
    func apiCall_UploadImage()  {
        //--
        let docBase64 = takedHoldingIDImage.image?.convertImageToBase64String()
        if docBase64?.count == 0{
            apiCall_updateApplication()
            return
        }
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.customer_photo.getValue(),
                                                   "view_type":viewType.other.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.personalInfoScreen)(),
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
        let salutation_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .salutation_c, index: selectSalutationIndex)
        var fName = ""
        var lName = ""
        if let fullName = txtFullName.txtType.text{
            let nameArr = fullName.description.components(separatedBy: " ")
            fName = nameArr.count != 0 ? nameArr[0] : ""
            lName = nameArr.count > 1 ? nameArr[1] : ""
        }
        let gender_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .gender_c, index: selectGenderIndex)
        let nationality_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .nationality_c, index: selectCountryofNationalityIndex)
        let country_of_birth_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .country_of_birth_c, index: selectCountryofBirthIndex)
        let resident_country_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .resident_country_c, index: selectResidentialStatusIndex)
        let resident_status_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .resident_status_c, index: selectResidentialStatusIndex)
        let resident_postal_code_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .resident_postal_code_c, index: selectPostalCodeIndex)
        let employment_status_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .employment_status_c, index: selectEmployementStatusIndex)
        let industry_type_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .industry_type_c, index: selectIndustryIndex)
        let employment_sector_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .employment_sector_c, index: selectEmployementSectorIndex)
        let profession_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .profession_c, index: selectProfessionIndex)
        let education_level_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .education_level_c, index: selectEducationLevelIndex)
        
        
        let date_of_birth_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "dd/MM/yyyy", dateNewFTR: "yyyy-MM-dd", strDate: txtDateofBirth.txtType.text!)
        let civil_id_expiry_date_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "dd/MM/yyyy", dateNewFTR: "yyyy-MM-dd", strDate: txtIDExpiryDate.txtType.text!)
        let passport_expiry_date_c = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "dd/MM/yyyy", dateNewFTR: "yyyy-MM-dd", strDate: txtPassportExpiryDate.txtType.text!)
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.personalInfoScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["citizenship_c": citizenshipType.rawValue,
                                                                 "salutation_c":  salutation_c,
                                                                 "full_name_c": txtFullName.txtType.text!,
                                                                 "first_name_c": fName,
                                                                 "last_name_c": lName,
                                                                 "date_of_birth_c": date_of_birth_c,
                                                                 "gender_c": gender_c,
                                                                 "nationality_c": nationality_c,
                                                                 "civil_id_c": txtIDNo.txtType.text!,
                                                                 "civil_id_expiry_date_c": civil_id_expiry_date_c,
                                                                 "passport_number_c": txtPassportNo.txtType.text!,
                                                                 "passport_expiry_date_c": passport_expiry_date_c,
                                                                 "country_of_birth_c": country_of_birth_c,
                                                                 "city_of_birth_c": txtCityofBirth.txtType.text!,
                                                                 "resident_country_c": resident_country_c,
                                                                 "resident_status_c": resident_status_c,
                                                                 "resident_po_box_c": txtPOBox.txtType.text!,
                                                                 "resident_postal_code_c": resident_postal_code_c,
                                                                 "resident_house_no_c": txtHouseFlatNumber.txtType.text!,
                                                                 "city_c": txtCity.txtType.text!,
                                                                 "area_c": txtArea.txtType.text!,
                                                                 "employment_status_c": employment_status_c,
                                                                 "industry_type_c": industry_type_c,
                                                                 "employment_sector_c": selectEmployementSectorIndex == -1 ? "7" : employment_sector_c,
                                                                 "employer_name_c": txtEmployername.txtType.text!,
                                                                 "profession_c": profession_c,
                                                                 "name_of_business_c": txtNameofBusiness.txtType.text!,
                                                                 "other_resident_country_c": txtPleaseSpecifyCountry.txtType.text!,
                                                                 "education_level_c":education_level_c]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    apiCall_checkAmlDedubCBO()
                    /*if citizenshipType == CitizenshipType.omani{
                        apiCall_checkAmlDedubCBO()
                    }else{
                        //--
                        let vc = FinancialInfoVC(nibName: "FinancialInfoVC", bundle: nil)
                        vc.selectedEmploymentStatus = employment_status_c
                        vc.citizenshipType = citizenshipType
                        vc.scanPasswordData = scanPasswordData
                        vc.scanFrontDocData = scanFrontDocData
                        vc.scanBackDocData = scanBackDocData
                        self.navigationController?.pushViewController(vc, animated: false)
                    }*/
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
    func apiCall_checkAmlDedubCBO()  {
        //--
        let dicParam:[String:AnyObject] = ["operation":"checkAmlDedubCBO" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "device_info":deviceInfo
                                                  ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            self.popover.dismiss()
            let validateOTPModel = OmniResponseModel(JSON: response as! [String : Any])!
            if validateOTPModel.Response?.Code == "200"{
                //--
                let vc = FinancialInfoVC(nibName: "FinancialInfoVC", bundle: nil)
                vc.citizenshipType = citizenshipType
                self.navigationController?.pushViewController(vc, animated: false)
                
            }else{
                self.popover.dismiss()
                openErrorAlert(title: "Error", details: validateOTPModel.Response?.Body?.statusMsg ?? "")
            }
        }) { (error) in
            print(error)
        }
    }

}


extension PersonalInfoVC: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate{
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
