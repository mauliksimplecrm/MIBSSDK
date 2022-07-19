//
//  FinancialInfoVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 01/02/22.
//

import UIKit
import SKCountryPicker
import Lightbox

class FinancialInfoVC: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var lblOnScrollHeader: UILabel!
    @IBOutlet weak var onscrollHeaderView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblViewSteps_title: UILabel!
    @IBOutlet weak var lblNext_title: UILabel!
    @IBOutlet weak var viewbgbtnNext: UIView!
    
    //IncomeDetail
    @IBOutlet weak var viewbgIncomeDetail: UIView!
    @IBOutlet weak var viewbgIncomeDetail_height: NSLayoutConstraint!
    @IBOutlet weak var viewbgLineSection_IncomeDetail_height: NSLayoutConstraint!
    
    //IncomeDetail Employed
    @IBOutlet var viewbg_IncomeDetailEmployed: UIView! //393
    @IBOutlet weak var viewbg_IncomeDetailEmployed_width: NSLayoutConstraint!
    @IBOutlet weak var viewbg_IncomeDetailEmployed_height: NSLayoutConstraint!
    @IBOutlet var viewbgInner_IncomeDetailEmployed: UIView!
    @IBOutlet weak var lblIncomeDetails_IncomeDetailEmployed: UILabel!
    @IBOutlet weak var txtSalaryIncome_IncomeDetailEmployed: FloatingTextFieldWithCode!
    @IBOutlet weak var txtSourceofFunds_IncomeDetailEmployed: UIFloatingTextField!
    @IBOutlet weak var lblPleaseUploadDoc_IncomeDetailEmployed: UILabel!
    @IBOutlet weak var icUploadDocDone_IncomeDetailEmployed: UIImageView!
    @IBOutlet weak var lblUploadDoc_IncomeDetailEmployed: UILabel!
    @IBOutlet weak var lblUploadDocDetail_IncomeDetailEmployed: UILabel!
    @IBOutlet weak var lblProofofEmployment_IncomeDetailEmployed: UILabel!
    
    //IncomeDetail Housewife, Student, Minor, or Un-Employed
    @IBOutlet var viewbg_IncomeDetail2: UIView! //417
    @IBOutlet weak var viewbg_IncomeDetail2_width: NSLayoutConstraint!
    @IBOutlet weak var viewbg_IncomeDetail2_height: NSLayoutConstraint!
    @IBOutlet weak var lblIncomeDetailviewbg_IncomeDetail2: UILabel!
    @IBOutlet weak var txtSourceofFund_IncomeDetail2: UIFloatingTextField!
    @IBOutlet weak var txtRelationshipwithCust_IncomeDetail2: UIFloatingTextField!
    @IBOutlet weak var txtOccuooFundProvider_IncomeDetail2: UIFloatingTextField!
    @IBOutlet weak var txtMonthlyIncomeRangeofFundProvider_IncomeDetail2: FloatingTextFieldWithCode!
    
    @IBOutlet weak var txtOtherIncomeSource: UIFloatingTextField!
    @IBOutlet weak var txtSpecifyOtherIncomeSource: UIFloatingTextField!
    
    //Monthly Transaction
    @IBOutlet weak var lblMonthlyTransactions: UILabel!
    @IBOutlet weak var txtExpectedNoofMonthlyCreditTrans: UIFloatingTextField!
    @IBOutlet weak var txtExpectedCreditAmount: FloatingTextFieldWithCode!
    
    @IBOutlet weak var txtExpectedNoofMonthlyDebitTrans: UIFloatingTextField!
    @IBOutlet weak var txtExpectedDebitAmount: FloatingTextFieldWithCode!
    
    
    //UsualModeofTransaction
    @IBOutlet weak var lblUsualModeofTransaction: UILabel!
    @IBOutlet weak var tblUsualModeOfTransaction: UITableView!
    @IBOutlet weak var tblUsualModeOfTransaction_height: NSLayoutConstraint!
    @IBOutlet weak var txtOtherusualModetransaction: UIFloatingTextField!
    @IBOutlet weak var txtOtherUsualModeofTransaction_height: NSLayoutConstraint!
    
    //Business Detail
    @IBOutlet weak var viewbgSectionLine_Bussinesdetail: UIView!
    @IBOutlet weak var txtNameofBusiness: UIFloatingTextField!
    @IBOutlet weak var txtPercentageofOwnship: UIFloatingTextField!
    @IBOutlet weak var txtMonthlyIncome: UIFloatingTextField!
    
    @IBOutlet weak var imgViewTakePhoto: UIImageView!
    @IBOutlet weak var btnViewTakePhotoHoldingId: UIButton!
    
    
    //MARK: Veriable
    var citizenshipType = CitizenshipType.non
    //var selectedEmploymentStatus = ""
    var arrUsualModeofTransaction = ManageDropDownOption.getDropDownValue(dropdown_filed: .usual_mode_of_transactions_c)
    var selectUsualModeofTransactionArr:[String] = []
    var selectSourceofFunds_IncomeDetailEmployedIndex = -1
    var selectSourceofFunds_IncomeDetail2 = -1
    var selectRelationshipwithCustomerIndex = -1
    var selectOccupation_of_funds_providerIndex = -1
    var selectOther_Income_SourceIndex = -1
    var selectMonthly_credit_transactionsIndex = -1
    var selectMonthly_debit_transactionsIndex = -1
    var selectPercentage_of_ownershipIndex = -1
    
    var isSelectUploadDoc_IncomeDetailEmployed = false
    var imgUploadDoc_IncomeDetailEmployed = UIImageView()
    
    var otherTextSourceofFund_IncomeDetailEmployed = ""
    var resultGetApplicationDataResult: GetApplicationDataResult?
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        setupBasic()
        registerCell()
        setupTextField()
        hideTakePhotoHolding()
        
        apiCall_getApplicationData { result in
            self.setFormData(result: result)
            self.manageViewOnSelectedEmpStatus(result: result)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        progressBar.setProgress(0.66, animated: true)
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        //--
        lblOnScrollHeader.text = Localize(key: "Financial Information")
        lblTitle.attributedText = Localize(key: "Financial Information").attributedStringWithColor(["Financial"], color: UIColor(named: "DARKGREENTINT")!)
        lblDetail.text = Localize(key: "Financial Information detail")
        
        lblIncomeDetails_IncomeDetailEmployed.text = Localize(key: "Income Details")
        lblMonthlyTransactions.text = Localize(key: "Monthly Transactions")
        lblUsualModeofTransaction.text = Localize(key: "Usual Mode of transactions")
        lblPleaseUploadDoc_IncomeDetailEmployed.text = Localize(key: "Please upload a document as Proof Of Employment")
        lblUploadDoc_IncomeDetailEmployed.text = Localize(key: "Upload Document")
        lblProofofEmployment_IncomeDetailEmployed.text = Localize(key: "Proof of Employment could be salary certificate or employment letter")
        
        lblViewSteps_title.text = Localize(key: "VIEW STEPS")
        lblNext_title.text = Localize(key: "NEXT")
        
        //--
        if Managelanguage.getLanguageCode() == "ar"
        {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            
            lblIncomeDetails_IncomeDetailEmployed.semanticContentAttribute = .forceRightToLeft
            lblPleaseUploadDoc_IncomeDetailEmployed.semanticContentAttribute = .forceRightToLeft
            lblUploadDoc_IncomeDetailEmployed.semanticContentAttribute = .forceRightToLeft
            lblProofofEmployment_IncomeDetailEmployed.semanticContentAttribute = .forceRightToLeft
            
            lblMonthlyTransactions.semanticContentAttribute = .forceRightToLeft
            lblUsualModeofTransaction.semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            lblTitle.semanticContentAttribute = .forceLeftToRight
            lblDetail.semanticContentAttribute = .forceLeftToRight
            
            lblIncomeDetails_IncomeDetailEmployed.semanticContentAttribute = .forceLeftToRight
            lblPleaseUploadDoc_IncomeDetailEmployed.semanticContentAttribute = .forceLeftToRight
            lblUploadDoc_IncomeDetailEmployed.semanticContentAttribute = .forceLeftToRight
            lblProofofEmployment_IncomeDetailEmployed.semanticContentAttribute = .forceLeftToRight
            
            lblMonthlyTransactions.semanticContentAttribute = .forceLeftToRight
            lblUsualModeofTransaction.semanticContentAttribute = .forceLeftToRight
        }
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.btnScheduleaCall.setTitle(Localize(key: "Schedule a Call"), for: .normal)
        headerView.didTappedBack = { (sender) in
            //--
            let vc = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    func registerCell(){
        tblUsualModeOfTransaction.register(UINib(nibName: "UsualModeTblCell", bundle: nil), forCellReuseIdentifier: "UsualModeTblCell")
    }
    func setupBasic(){
        
        
    }
    func manageViewOnSelectedEmpStatus(result: GetApplicationDataResult){
        //
        hideOtherModeofTransaction(clearText: false)
        
        //Hide Income Detail
        viewbgIncomeDetail_height.constant = 0
        viewbgLineSection_IncomeDetail_height.constant = 0
        
        //Hide Business Detail
        viewbgSectionLine_Bussinesdetail.isHidden = true
        txtNameofBusiness.isHidden = true
        txtPercentageofOwnship.isHidden = true
        txtMonthlyIncome.isHidden = true
        
        //--
        let employment_status_c = result.employment_status_c as? String ?? ""
        if employment_status_c == "1"{
            //Employed
            viewbgIncomeDetail_height.constant = 393
            viewbgLineSection_IncomeDetail_height.constant = 10
            viewbg_IncomeDetailEmployed_width.constant = UIScreen.main.bounds.width
            viewbgIncomeDetail.addSubview(viewbg_IncomeDetailEmployed)
            viewbg_IncomeDetailEmployed.frame = viewbgIncomeDetail.bounds
            
        }else if employment_status_c == "6_6" || employment_status_c == "4" || employment_status_c == "6_7"{
            //Investor, "Self-Employed", Business man
            
            //Show Business Detail
            viewbgSectionLine_Bussinesdetail.isHidden = false
            txtNameofBusiness.isHidden = false
            txtPercentageofOwnship.isHidden = false
            txtMonthlyIncome.isHidden = false
        }else{
            //Housewife, Student, Minor, or Un-Employed
            viewbgIncomeDetail_height.constant = 417
            viewbgLineSection_IncomeDetail_height.constant = 10
            viewbg_IncomeDetail2_width.constant = UIScreen.main.bounds.width
            viewbgIncomeDetail.addSubview(viewbg_IncomeDetail2)
            
        }
    }
    func setupTextField(){
        //Employed
        txtSalaryIncome_IncomeDetailEmployed.setTitlePlaceholder(text_: Localize(key: "Salary Income"), placeholder_: "", isUserInteraction: true)
        txtSalaryIncome_IncomeDetailEmployed.delegate_UIFloatingTextField_Protocol = self
        
        txtSourceofFunds_IncomeDetailEmployed.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtSourceofFunds_IncomeDetailEmployed.setTitlePlaceholder(text_: Localize(key: "Source of Funds"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtSourceofFunds_IncomeDetailEmployed.btnOpenDropDown.isHidden = false
        txtSourceofFunds_IncomeDetailEmployed.didTappedDropDown = { (sender) in
            //--
            let vc = SourceofFundsVC(nibName: "SourceofFundsVC", bundle: nil)
            vc.selectIndex = 0
            vc.arrListOfDropDown = ManageDropDownOption.getDropDownValue(dropdown_filed: .sources_of_fund_c)
            vc.stepTitle = Localize(key: "Source of Funds")
            vc.pleaseSpecifyText = Localize(key: "Please specify your source of funds")
            vc.pleaseSpecifyTextPlaceHolder = Localize(key: "Enter source")
            vc.delegate_didSelectSourceofFunds_protocol = self
            vc.selectIndex = self.selectSourceofFunds_IncomeDetailEmployedIndex
            vc.otherTextSourceofFund = self.otherTextSourceofFund_IncomeDetailEmployed
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
        //2
        txtSourceofFund_IncomeDetail2.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtSourceofFund_IncomeDetail2.setTitlePlaceholder(text_: Localize(key: "Source of fund/ Name of provider"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtSourceofFund_IncomeDetail2.btnOpenDropDown.isHidden = false
        txtSourceofFund_IncomeDetail2.didTappedDropDown = { (sender) in
            //--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .name_of_fund_provider_c)
            self.openDropDownPicker(headerTitle: Localize(key: "Source of Funds"),
                                    dropDownType: "SourceoffundNameofprovider",
                                    arrList: list,
                                    selectedIndex: self.selectSourceofFunds_IncomeDetail2)
        }
        
        txtRelationshipwithCust_IncomeDetail2.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtRelationshipwithCust_IncomeDetail2.setTitlePlaceholder(text_: Localize(key: "Relationship with Customer"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtRelationshipwithCust_IncomeDetail2.btnOpenDropDown.isHidden = false
        txtRelationshipwithCust_IncomeDetail2.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .relation_with_funds_provider_c)
            self.openDropDownPicker(headerTitle: "Relationship with Customer",
                                    dropDownType: "relationshipwithcust",
                                    arrList: list,
                                    selectedIndex: self.selectRelationshipwithCustomerIndex)
        }
        
        txtOccuooFundProvider_IncomeDetail2.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtOccuooFundProvider_IncomeDetail2.setTitlePlaceholder(text_: Localize(key: "Occupation of Fund Provider"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtOccuooFundProvider_IncomeDetail2.btnOpenDropDown.isHidden = false
        txtOccuooFundProvider_IncomeDetail2.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .occupation_of_fund_provider_c)
            self.openDropDownPicker(headerTitle: "Occupation of Fund Provider",
                                    dropDownType: "occupation_of_funds_provider",
                                    arrList: list,
                                    selectedIndex: self.selectOccupation_of_funds_providerIndex)
        }
        
        txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.setTitlePlaceholder(text_: Localize(key: "Monthly income range of fund provider"), placeholder_: "", isUserInteraction: true)
        txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.delegate_UIFloatingTextField_Protocol = self
        
        //--
        txtOtherIncomeSource.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtOtherIncomeSource.setTitlePlaceholder(text_: Localize(key: "Do you have other income source?"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtOtherIncomeSource.btnOpenDropDown.isHidden = false
        txtOtherIncomeSource.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .have_other_source_of_income_c)
            self.openDropDownPicker(headerTitle: "Other Income Source",
                                    dropDownType: "other_income_source",
                                    arrList: list,
                                    selectedIndex: self.selectOther_Income_SourceIndex)
        }
        
        txtSpecifyOtherIncomeSource.setICON(hidden: true)
        txtSpecifyOtherIncomeSource.setTitlePlaceholder(text_: Localize(key: "Please Specify"), placeholder_: Localize(key: "Enter other income source"), isUserInteraction: true)
        txtSpecifyOtherIncomeSource.isHidden = true
        txtSpecifyOtherIncomeSource.delegate_UIFloatingTextField_Protocol = self
        
        //Monthly Transactions
        txtExpectedNoofMonthlyCreditTrans.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtExpectedNoofMonthlyCreditTrans.setTitlePlaceholder(text_: "Expected No of Monthly credit transactions", placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtExpectedNoofMonthlyCreditTrans.btnOpenDropDown.isHidden = false
        txtExpectedNoofMonthlyCreditTrans.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .expected_no_of_credit_trans_c)
            self.openDropDownPicker(headerTitle: "Select Exp Monthly Credit Transactions",
                                    dropDownType: "monthly_transactions",
                                    arrList: list,
                                    selectedIndex: self.selectMonthly_credit_transactionsIndex)
        }
        
        txtExpectedCreditAmount.setTitlePlaceholder(text_: Localize(key: "Expected Credit Amount"), placeholder_: "", isUserInteraction: true)
        txtExpectedCreditAmount.delegate_UIFloatingTextField_Protocol = self
        
        txtExpectedNoofMonthlyDebitTrans.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtExpectedNoofMonthlyDebitTrans.setTitlePlaceholder(text_: Localize(key: "Expected No of Monthly debit transactions"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtExpectedNoofMonthlyDebitTrans.btnOpenDropDown.isHidden = false
        txtExpectedNoofMonthlyDebitTrans.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .expected_no_of_debit_trans_c)
            self.openDropDownPicker(headerTitle: "Monthly Debit Transactions",
                                    dropDownType: "monthly_debit_transactions",
                                    arrList: list,
                                    selectedIndex: self.selectMonthly_debit_transactionsIndex)
        }
        
        txtExpectedDebitAmount.setTitlePlaceholder(text_: Localize(key: "Expected Debit Amount"), placeholder_: "", isUserInteraction: true)
        txtExpectedDebitAmount.delegate_UIFloatingTextField_Protocol = self
        
        txtOtherusualModetransaction.setICON(hidden: true)
        txtOtherusualModetransaction.setTitlePlaceholder(text_: Localize(key: "Mention other mode of transaction"), placeholder_: Localize(key: "Mention other mode of transaction"), isUserInteraction: true)
        txtOtherusualModetransaction.delegate_UIFloatingTextField_Protocol = self
        
        txtNameofBusiness.setICON(hidden: true)
        txtNameofBusiness.setTitlePlaceholder(text_: Localize(key: "Name of Business"), placeholder_: Localize(key: "Name of Business"), isUserInteraction: true)
        txtNameofBusiness.delegate_UIFloatingTextField_Protocol = self
        
        txtPercentageofOwnship.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtPercentageofOwnship.setTitlePlaceholder(text_: Localize(key: "Percentage of ownership"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtPercentageofOwnship.btnOpenDropDown.isHidden = false
        txtPercentageofOwnship.didTappedDropDown = { (sender) in
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: .percentage_of_ownership_c)
            self.openDropDownPicker(headerTitle: "Percentage of Ownership",
                                    dropDownType: "percentage_of_ownership",
                                    arrList: list,
                                    selectedIndex: self.selectPercentage_of_ownershipIndex)
        }
        
        txtMonthlyIncome.setICON(hidden: true)
        txtMonthlyIncome.setTitlePlaceholder(text_: Localize(key: "Monthly Income"), placeholder_: Localize(key: "Monthly Income"), isUserInteraction: true)
        txtMonthlyIncome.delegate_UIFloatingTextField_Protocol = self
        
    }
    
    
    //MARK: @IBAction
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
        vc.selectIndex = 1
        vc.totalStep = 3
        vc.progress = 0.66
        vc.arrListOfDropDown = [Localize(key: "Personal Information"), Localize(key: "Financial Information"), Localize(key: "Regularity Declaration")]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnNext(_ sender: Any) {
        if validateEnput(){
            isSelectUploadDoc_IncomeDetailEmployed ? apiCall_UploadDoc_IncomeDetailEmployed() : apiCall_updateApplication()
        }
    }
    @IBAction func btnUploadDoc_IncomeDetailEmployed(_ sender: Any) {
        //--
        let vc = CustomCameraVC(nibName: "CustomCameraVC", bundle: nil)
        vc.delegate_didTakeCustomPhoto = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.avCaptureDevicePosition = .back
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnViewTakePhotoHoldingId(_ sender: Any) {
        if let img_ = imgUploadDoc_IncomeDetailEmployed.image{
            setupLightBoxImageArray(imgOpen: img_, msg: "")
        }
    }
    
}
extension FinancialInfoVC: didTakeCustomPhoto_protocol{
    func didTakeCustomPhoto_protocol(image_: UIImage) {
        isSelectUploadDoc_IncomeDetailEmployed = true
        imgUploadDoc_IncomeDetailEmployed.image = image_
        
        selectTakePhotoHolding()
    }
    
    func selectTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = false
        imgViewTakePhoto.isHidden = false
        icUploadDocDone_IncomeDetailEmployed.image = .IMGDoneGreen
        lblUploadDocDetail_IncomeDetailEmployed.text = "Proof Of Employment.png"
        lblUploadDocDetail_IncomeDetailEmployed.isHidden = false
    }
    func hideTakePhotoHolding(){
        btnViewTakePhotoHoldingId.isHidden = true
        imgViewTakePhoto.isHidden = true
        lblUploadDocDetail_IncomeDetailEmployed.isHidden = true
    }
    
}
extension FinancialInfoVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        if droDownType == "SourceoffundNameofprovider"{
            txtSourceofFund_IncomeDetail2.txtType.text = title
            selectSourceofFunds_IncomeDetail2 = index
            txtSourceofFund_IncomeDetail2.lblError.isHidden = true
        }
        if droDownType == "relationshipwithcust"{
            txtRelationshipwithCust_IncomeDetail2.txtType.text = title
            selectRelationshipwithCustomerIndex = index
            txtRelationshipwithCust_IncomeDetail2.lblError.isHidden = true
        }
        if droDownType == "occupation_of_funds_provider"{
            txtOccuooFundProvider_IncomeDetail2.txtType.text = title
            selectOccupation_of_funds_providerIndex = index
            txtOccuooFundProvider_IncomeDetail2.lblError.isHidden = true
        }
        if droDownType == "other_income_source"{
            txtOtherIncomeSource.txtType.text = title
            selectOther_Income_SourceIndex = index
            txtOtherIncomeSource.lblError.isHidden = true
            if index == 0{
                txtSpecifyOtherIncomeSource.isHidden = false
                txtSpecifyOtherIncomeSource.txtType.text = ""
            }else{
                txtSpecifyOtherIncomeSource.isHidden = true
                txtSpecifyOtherIncomeSource.txtType.text = ""
            }
        }
        if droDownType == "monthly_transactions"{
            txtExpectedNoofMonthlyCreditTrans.txtType.text = title
            selectMonthly_credit_transactionsIndex = index
            txtExpectedNoofMonthlyCreditTrans.lblError.isHidden = true
        }
        if droDownType == "monthly_debit_transactions"{
            txtExpectedNoofMonthlyDebitTrans.txtType.text = title
            selectMonthly_debit_transactionsIndex = index
            txtExpectedNoofMonthlyDebitTrans.lblError.isHidden = true
        }
        if droDownType == "percentage_of_ownership"{
            txtPercentageofOwnship.txtType.text = title
            selectPercentage_of_ownershipIndex = index
            txtPercentageofOwnship.lblError.isHidden = true
        }
    }
}

extension FinancialInfoVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsualModeofTransaction.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsualModeTblCell", for: indexPath) as! UsualModeTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrUsualModeofTransaction[indexPath.row]
        
        let selectBackendValue = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .usual_mode_of_transactions_c, index: indexPath.row)

        if selectUsualModeofTransactionArr.contains(selectBackendValue){
            cell.imgCheckBox.image = .IMGCheckGreen
            cell.lblTitle.textColor = .DARKGREY
        }else{
            cell.imgCheckBox.image = .IMGUnCheckGray
            cell.lblTitle.textColor = .MIDGREY
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectBackendValue = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .usual_mode_of_transactions_c, index: indexPath.row)
        
        if selectUsualModeofTransactionArr.contains(selectBackendValue){
            var index = 0
            selectUsualModeofTransactionArr.forEach { obj in
                if  obj == selectBackendValue{
                    selectUsualModeofTransactionArr.remove(at: index)
                }
                index = index + 1
            }
        }else{
            selectUsualModeofTransactionArr.append(selectBackendValue)
        }
        tblUsualModeOfTransaction.reloadData()
        
        if selectUsualModeofTransactionArr.contains("8"){
            showOtherModeofTransaction(clearText: true)
        }else{
            hideOtherModeofTransaction(clearText: true)
        }
    }
    
    func hideOtherModeofTransaction(clearText:Bool){
        txtOtherUsualModeofTransaction_height.constant = 0
        txtOtherusualModetransaction.isHidden = true
        if clearText{
            txtOtherusualModetransaction.txtType.text = ""
        }
    }
    func showOtherModeofTransaction(clearText:Bool){
        txtOtherUsualModeofTransaction_height.constant = 81
        txtOtherusualModetransaction.isHidden = false
        if clearText{
            txtOtherusualModetransaction.txtType.text = ""
        }
    }
}

extension FinancialInfoVC: UIScrollViewDelegate{
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

extension FinancialInfoVC: didSelectSourceofFunds_protocol{
    func didSelectSourceofFunds(text: String, otherEnterText: String, index: Int) {
        //Employed
        txtSourceofFunds_IncomeDetailEmployed.txtType.text = text.count == 0 ? otherEnterText : text
        selectSourceofFunds_IncomeDetailEmployedIndex = index
        otherTextSourceofFund_IncomeDetailEmployed = otherEnterText
        
    }
    
}

extension FinancialInfoVC: UIFloatingTextField_Protocol{
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    func btnOpenCountryCodePicker(textField: UITextField) {
        self.view.endEditing(true)
        if textField == txtSalaryIncome_IncomeDetailEmployed.txtType{
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtSalaryIncome_IncomeDetailEmployed.lblCode.text = countryCode
                self.txtSalaryIncome_IncomeDetailEmployed.imgFlag.image = UIImage(named: "\(countryCode)")
            }
            /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtSalaryIncome_IncomeDetailEmployed.lblCode.text = country.countryCode
                self.txtSalaryIncome_IncomeDetailEmployed.imgFlag.image = country.flag
            }*/
        }
        if textField == txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType{
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.lblCode.text = countryCode
                self.txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.imgFlag.image = UIImage(named: "\(countryCode)")
            }
            /*CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.lblCode.text = country.countryCode
                self.txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.imgFlag.image = country.flag
            }*/
        }
        if textField == txtExpectedCreditAmount.txtType{
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtExpectedCreditAmount.lblCode.text = countryCode
                self.txtExpectedCreditAmount.imgFlag.image = UIImage(named: "\(countryCode)")
            }
            /*
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtExpectedCreditAmount.lblCode.text = country.countryCode
                self.txtExpectedCreditAmount.imgFlag.image = country.flag
            }*/
        }
        if textField == txtExpectedDebitAmount.txtType{
            CountryCodePickerVC.presentCountroller(on: self, list: ManageDropDownOption.getDropDownValues(dropdown_filed: .resident_country_c))
            CountryCodePickerVC.shared.didSelectCountry = { [self] (countryName, countryCode, selectIndex) in
                print(countryName)
                self.txtExpectedDebitAmount.lblCode.text = countryCode
                self.txtExpectedDebitAmount.imgFlag.image = UIImage(named: "\(countryCode)")
            }
            /*CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                guard let self = self else { return }
                self.txtExpectedDebitAmount.lblCode.text = country.countryCode
                self.txtExpectedDebitAmount.imgFlag.image = country.flag
            }*/
        }
    }
    func editingChanged(textField: UITextField) {
        validateErrorMsg(textField: textField)
    }
    
    func shouldChangeCharactersIn(textField: UITextField, txt: String) {
        
    }
   
    
    //Validation
    func validateErrorMsg(textField: UITextField){
        
        //--Employe Detail
        if txtSalaryIncome_IncomeDetailEmployed.txtType == textField{
            txtSalaryIncome_IncomeDetailEmployed.lblError.isHidden = AppHelper.isNull(txtSalaryIncome_IncomeDetailEmployed.txtType.text!) == false ? true : false
        }
        if txtSourceofFunds_IncomeDetailEmployed.txtType == textField{
            txtSourceofFunds_IncomeDetailEmployed.lblError.isHidden = AppHelper.isNull(txtSourceofFunds_IncomeDetailEmployed.txtType.text!) == false ? true : false
        }
        
        //--Employe Income Detail 2
        if txtSourceofFund_IncomeDetail2.txtType == textField{
            txtSourceofFund_IncomeDetail2.lblError.isHidden = AppHelper.isNull(txtSourceofFund_IncomeDetail2.txtType.text!) == false ? true : false
        }
        if txtRelationshipwithCust_IncomeDetail2.txtType == textField{
            txtRelationshipwithCust_IncomeDetail2.lblError.isHidden = AppHelper.isNull(txtRelationshipwithCust_IncomeDetail2.txtType.text!) == false ? true : false
        }
        if txtOccuooFundProvider_IncomeDetail2.txtType == textField{
            txtOccuooFundProvider_IncomeDetail2.lblError.isHidden = AppHelper.isNull(txtOccuooFundProvider_IncomeDetail2.txtType.text!) == false ? true : false
        }
        if txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType == textField{
            txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.lblError.isHidden = AppHelper.isNull(txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType.text!) == false ? true : false
        }
        
        //--
        if txtOtherIncomeSource.txtType == textField{
            txtOtherIncomeSource.lblError.isHidden = AppHelper.isNull(txtOtherIncomeSource.txtType.text!) == false ? true : false
        }
        let have_other_source_of_income_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .have_other_source_of_income_c, index: selectOther_Income_SourceIndex)
        if have_other_source_of_income_c == "Yes"{
            if txtSpecifyOtherIncomeSource.txtType == textField{
                txtSpecifyOtherIncomeSource.lblError.isHidden = AppHelper.isNull(txtSpecifyOtherIncomeSource.txtType.text!) == false ? true : false
            }
        }
        
        //--Monthly Transactions
        if txtExpectedNoofMonthlyCreditTrans.txtType == textField{
            txtExpectedNoofMonthlyCreditTrans.lblError.isHidden = AppHelper.isNull(txtExpectedNoofMonthlyCreditTrans.txtType.text!) == false ? true : false
        }
        if txtExpectedCreditAmount.txtType == textField{
            txtExpectedCreditAmount.lblError.isHidden = AppHelper.isNull(txtExpectedCreditAmount.txtType.text!) == false ? true : false
        }
        if txtExpectedNoofMonthlyDebitTrans.txtType == textField{
            txtExpectedNoofMonthlyDebitTrans.lblError.isHidden = AppHelper.isNull(txtExpectedNoofMonthlyDebitTrans.txtType.text!) == false ? true : false
        }
        if txtExpectedDebitAmount.txtType == textField{
            txtExpectedDebitAmount.lblError.isHidden = AppHelper.isNull(txtExpectedDebitAmount.txtType.text!) == false ? true : false
        }
        
        //Show Business Detail
        if txtNameofBusiness.txtType == textField{
            txtNameofBusiness.lblError.isHidden = AppHelper.isNull(txtNameofBusiness.txtType.text!) == false ? true : false
        }
        if txtPercentageofOwnship.txtType == textField{
            txtPercentageofOwnship.lblError.isHidden = AppHelper.isNull(txtPercentageofOwnship.txtType.text!) == false ? true : false
        }
        if txtMonthlyIncome.txtType == textField{
            txtMonthlyIncome.lblError.isHidden = AppHelper.isNull(txtMonthlyIncome.txtType.text!) == false ? true : false
        }
        
    }
    func validateEnput() -> Bool{
        var returnValue = true
        //--
        let employment_status_c = resultGetApplicationDataResult?.employment_status_c as? String ?? ""
        if employment_status_c == "1"{
            //Employed
            //--Employe Detail
            if AppHelper.isNull(txtSalaryIncome_IncomeDetailEmployed.txtType.text!){
                txtSalaryIncome_IncomeDetailEmployed.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtSourceofFunds_IncomeDetailEmployed.txtType.text!){
                txtSourceofFunds_IncomeDetailEmployed.lblError.isHidden = false
                returnValue = false
            }
            
        }else if employment_status_c == "6_6" || employment_status_c == "4" || employment_status_c == "6_7"{
            //Investor, "Self-Employed", Business man
            
            //Show Business Detail
            if AppHelper.isNull(txtNameofBusiness.txtType.text!){
                txtNameofBusiness.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtPercentageofOwnship.txtType.text!){
                txtPercentageofOwnship.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtMonthlyIncome.txtType.text!){
                txtMonthlyIncome.lblError.isHidden = false
                returnValue = false
            }
            
        }else{
            //Housewife, Student, Minor, or Un-Employed
            //--Employe Income Detail 2
            if AppHelper.isNull(txtSourceofFund_IncomeDetail2.txtType.text!){
                txtSourceofFund_IncomeDetail2.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtRelationshipwithCust_IncomeDetail2.txtType.text!){
                txtRelationshipwithCust_IncomeDetail2.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtOccuooFundProvider_IncomeDetail2.txtType.text!){
                txtOccuooFundProvider_IncomeDetail2.lblError.isHidden = false
                returnValue = false
            }
            if AppHelper.isNull(txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType.text!){
                txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.lblError.isHidden = false
                returnValue = false
            }
        }
    
        
        //--
        if AppHelper.isNull(txtOtherIncomeSource.txtType.text!){
            txtOtherIncomeSource.lblError.isHidden = false
            returnValue = false
        }
        let have_other_source_of_income_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .have_other_source_of_income_c, index: selectOther_Income_SourceIndex)
        if have_other_source_of_income_c == "Yes"{
            if AppHelper.isNull(txtSpecifyOtherIncomeSource.txtType.text!){
                txtSpecifyOtherIncomeSource.lblError.isHidden = false
                returnValue = false
            }
        }
        
        //--Monthly Transactions
        if AppHelper.isNull(txtExpectedNoofMonthlyCreditTrans.txtType.text!){
            txtExpectedNoofMonthlyCreditTrans.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtExpectedCreditAmount.txtType.text!){
            txtExpectedCreditAmount.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtExpectedNoofMonthlyDebitTrans.txtType.text!){
            txtExpectedNoofMonthlyDebitTrans.lblError.isHidden = false
            returnValue = false
        }
        if AppHelper.isNull(txtExpectedDebitAmount.txtType.text!){
            txtExpectedDebitAmount.lblError.isHidden = false
            returnValue = false
        }
        
        
        return returnValue
    }
    
}

//MARK: - Api Call
extension FinancialInfoVC{
    
    func setFormData(result: GetApplicationDataResult){
        resultGetApplicationDataResult = result
        //--Employed
        if let salary_income_c = result.salary_income_c as? Float{
            txtSalaryIncome_IncomeDetailEmployed.txtType.text = "\(salary_income_c)"
        }
        
        let sources_of_fund_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .sources_of_fund_c, backendvalue: result.sources_of_fund_c as? String ?? "")
        txtSourceofFunds_IncomeDetailEmployed.txtType.text = sources_of_fund_c.0
        selectSourceofFunds_IncomeDetailEmployedIndex = sources_of_fund_c.1
        otherTextSourceofFund_IncomeDetailEmployed = result.other_sources_of_funds_c as? String ?? ""
        
        //--
        let name_of_fund_provider_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .name_of_fund_provider_c, backendvalue: result.name_of_fund_provider_c as? String ?? "")
        txtSourceofFund_IncomeDetail2.txtType.text = name_of_fund_provider_c.0
        selectSourceofFunds_IncomeDetail2 = name_of_fund_provider_c.1
        let relation_with_funds_provider_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .relation_with_funds_provider_c, backendvalue: result.relation_with_funds_provider_c as? String ?? "")
        txtRelationshipwithCust_IncomeDetail2.txtType.text = relation_with_funds_provider_c.0
        selectRelationshipwithCustomerIndex = relation_with_funds_provider_c.1
        let occupation_of_fund_provider_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .occupation_of_fund_provider_c, backendvalue: result.occupation_of_fund_provider_c as? String ?? "")
        txtOccuooFundProvider_IncomeDetail2.txtType.text = occupation_of_fund_provider_c.0
        selectOccupation_of_funds_providerIndex = occupation_of_fund_provider_c.1
        
        txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType.text = "\(result.monthly_income_range_c as? String ?? "")"
        
        //--
        let have_other_source_of_income_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .have_other_source_of_income_c, backendvalue: result.have_other_source_of_income_c as? String ?? "")
        txtOtherIncomeSource.txtType.text = have_other_source_of_income_c.0
        selectOther_Income_SourceIndex = have_other_source_of_income_c.1
        txtSpecifyOtherIncomeSource.txtType.text = result.specify_source_of_income_c as? String ?? ""
        if selectOther_Income_SourceIndex == 0{
            txtSpecifyOtherIncomeSource.isHidden = false
        }else{
            txtSpecifyOtherIncomeSource.isHidden = true
        }
        
        //--
        let expected_no_of_credit_trans_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .expected_no_of_credit_trans_c, backendvalue: result.expected_no_of_credit_trans_c as? String ?? "")
        txtExpectedNoofMonthlyCreditTrans.txtType.text = expected_no_of_credit_trans_c.0
        selectMonthly_credit_transactionsIndex = expected_no_of_credit_trans_c.1
        txtExpectedCreditAmount.txtType.text = result.expected_credit_amount_omr_c as? String ?? ""
        
        let expected_no_of_debit_trans_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .expected_no_of_debit_trans_c, backendvalue: result.expected_no_of_debit_trans_c as? String ?? "")
        txtExpectedNoofMonthlyDebitTrans.txtType.text = expected_no_of_debit_trans_c.0
        selectMonthly_debit_transactionsIndex = expected_no_of_debit_trans_c.1
        txtExpectedDebitAmount.txtType.text = result.expected_debit_amount_omr_c as? String ?? ""
        
        let usual_mode_of_transactions_c = (result.usual_mode_of_transactions_c as? String ?? "").components(separatedBy: ",")
        usual_mode_of_transactions_c.forEach { selectIndex in
            selectUsualModeofTransactionArr.append(selectIndex)
        }
        tblUsualModeOfTransaction.reloadData()
        
        txtOtherusualModetransaction.txtType.text = result.other_mode_of_transaction_c as? String ?? ""
        if selectUsualModeofTransactionArr.contains("8"){
            showOtherModeofTransaction(clearText: false)
        }else{
            hideOtherModeofTransaction(clearText: false)
        }
        
        txtNameofBusiness.txtType.text = result.name_of_business_c as? String ?? ""
        let percentage_of_ownership_c = ManageDropDownOption.getDropDownBackendValueToLabelAndIndex(dropdown_filed: .percentage_of_ownership_c, backendvalue: result.percentage_of_ownership_c as? String ?? "")
        txtPercentageofOwnship.txtType.text = percentage_of_ownership_c.0
        selectPercentage_of_ownershipIndex = percentage_of_ownership_c.1
        txtMonthlyIncome.txtType.text = result.monthly_income_c as? String ?? ""
        
        //--
        getDocumentsList()
    }
    
    func getDocumentsList(){
        //LoadingView.shared.openLodingAlert(view: self.view)
        apiCall_getDocumentsList (showProgress: false){ [self] docResult in
            //LoadingView.shared.dismissLoadingView()
            docResult.documents.forEach { getDocumentsListDocuments in
                if getDocumentsListDocuments.document_type == docType.employment_letter.getValue() &&
                    getDocumentsListDocuments.card_type == viewType.getValue(.other)(){
                    let document_link = getDocumentsListDocuments.document_link
                    if let url = URL(string: document_link){
                        isSelectUploadDoc_IncomeDetailEmployed = true
                        imgUploadDoc_IncomeDetailEmployed.setImage(url: url)
                        icUploadDocDone_IncomeDetailEmployed.image = .IMGDoneGreen
                        selectTakePhotoHolding()
                    }
                }
            }
        }
    }
    
    func apiCall_UploadDoc_IncomeDetailEmployed()  {
        //--
        let docBase64 = imgUploadDoc_IncomeDetailEmployed.image?.convertImageToBase64String()
        if docBase64?.count == 0{
            apiCall_updateApplication()
            return
        }
        let dicParam:[String:AnyObject] = ["operation":"documentValidation" as AnyObject,
                                           "data":["crmid":Login_LocalDB.getApplicationInfo().crmid,
                                                   "doc_type":docType.employment_letter.getValue(),
                                                   "view_type":viewType.other.getValue(),
                                                   "step":STEPS_FRONT_END_NAME.getValue(.financialInfoScreen)(),
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
        let sources_of_fund_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .sources_of_fund_c, index: selectSourceofFunds_IncomeDetailEmployedIndex)
        
        //--
        let name_of_fund_provider_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .name_of_fund_provider_c, index: selectSourceofFunds_IncomeDetail2)
        let relation_with_funds_provider_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .relation_with_funds_provider_c, index: selectRelationshipwithCustomerIndex)
        let occupation_of_fund_provider_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .occupation_of_fund_provider_c, index: selectOccupation_of_funds_providerIndex)
        
        //--
        let have_other_source_of_income_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .have_other_source_of_income_c, index: selectOther_Income_SourceIndex)
        let expected_no_of_credit_trans_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .expected_no_of_credit_trans_c, index: selectMonthly_credit_transactionsIndex)
        let expected_no_of_debit_trans_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .expected_no_of_debit_trans_c, index: selectMonthly_debit_transactionsIndex)
        let percentage_of_ownership_c = ManageDropDownOption.getDropDownBackendValue(dropdown_filed: .percentage_of_ownership_c, index: selectPercentage_of_ownershipIndex)
        
   
        
        //--
        let dicParam:[String:AnyObject] = ["operation": "updateApplication" as AnyObject,
                                           "data": ["crmid": Login_LocalDB.getApplicationInfo().crmid,
                                                    "step": STEPS_FRONT_END_NAME.getValue(.financialInfoScreen)(),
                                                    "device_info": deviceInfo,
                                                    "crm_data": ["citizenship_c": citizenshipType.rawValue,
                                                                 //--Employe
                                                                 "salary_income_c": txtSalaryIncome_IncomeDetailEmployed.txtType.text!,
                                                                 "sources_of_fund_c": sources_of_fund_c,
                                                                 "other_sources_of_funds_c": otherTextSourceofFund_IncomeDetailEmployed,
                                                                 //--Investor, Business man
                                                                 "name_of_fund_provider_c":name_of_fund_provider_c,
                                                                 "relation_with_funds_provider_c":relation_with_funds_provider_c,
                                                                 "occupation_of_fund_provider_c":occupation_of_fund_provider_c,
                                                                 "monthly_income_range_c":txtMonthlyIncomeRangeofFundProvider_IncomeDetail2.txtType.text!,
                                                                 //--
                                                                 "name_of_business_c":txtNameofBusiness.txtType.text!,
                                                                 "percentage_of_ownership_c":percentage_of_ownership_c,
                                                                 "monthly_income_c":txtMonthlyIncome.txtType.text!,
                                                                 //--
                                                                 "have_other_source_of_income_c": have_other_source_of_income_c,
                                                                 "specify_source_of_income_c": txtSpecifyOtherIncomeSource.txtType.text!,
                                                                 "expected_no_of_credit_trans_c": expected_no_of_credit_trans_c,
                                                                 "expected_credit_amount_omr_c": txtExpectedCreditAmount.txtType.text!,
                                                                 "expected_no_of_debit_trans_c": expected_no_of_debit_trans_c,
                                                                 "expected_debit_amount_omr_c": txtExpectedDebitAmount.txtType.text!,
                                                                 "usual_mode_of_transactions_c": selectUsualModeofTransactionArr.joined(separator: ","),
                                                                 "other_mode_of_transaction_c": txtOtherusualModetransaction.txtType.text!
                                                                 ]
                                                   ] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: a_mibs, dicsParams: dicParam, headers: ["Authorization":"Bearer \(Login_LocalDB.getLoginUserModel().mobileApiData?.access_token ?? "")"], showProgress: true, completion: { [self] (response) in
            print(response as Any)
            let oTPGenerationModel = OTPGenerationModel(JSON: response as! [String : Any])!
            if oTPGenerationModel.Response?.Code == "200"{
                if oTPGenerationModel.Response?.Body?.status == "Success"{
                    //--
                    let vc = RegularityDeclVC(nibName: "RegularityDeclVC", bundle: nil)
                    //vc.selectedEmploymentStatus = selectEmployementStatusIndex
                    vc.citizenshipType = citizenshipType
                    self.navigationController?.pushViewController(vc, animated: false)
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


extension FinancialInfoVC: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate{
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
