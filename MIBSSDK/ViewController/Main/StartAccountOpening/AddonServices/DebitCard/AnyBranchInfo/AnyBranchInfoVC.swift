//
//  AnyBranchInfoVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 21/02/22.
//

import UIKit

protocol SubmitAnyBranchInfo_protocol {
    func onSuccess()
}

class AnyBranchInfoVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var viewHeader1: UIView!
    @IBOutlet weak var lblTitleHeader1: UILabel!
    @IBOutlet weak var lblDetailHeader1: UILabel!
    @IBOutlet weak var viewHeader2: UIView!
    @IBOutlet weak var viewHeader2Height: NSLayoutConstraint! //256
    @IBOutlet weak var lblTitleHeader2: UILabel!
    @IBOutlet weak var tblListHeader2: UITableView!
    
    //Branch Details
    @IBOutlet weak var viewBranchDetail: UIView!
    @IBOutlet weak var viewBranchSectionHeight: NSLayoutConstraint! //10
    @IBOutlet weak var lblBranchDetail: UILabel!
    @IBOutlet weak var txtBranch: UIFloatingTextField!
    @IBOutlet weak var txtDate: UIFloatingTextField!
    @IBOutlet weak var txtTime: UIFloatingTextField!
    
    //Kiosk Detail
    @IBOutlet weak var viewKioskDetails: UIView!
    @IBOutlet weak var viewKioskSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var lblKioskDetails: UILabel!
    @IBOutlet weak var txtKioskLocation: UIFloatingTextField!
    
    //Delivery Detail
    @IBOutlet weak var lblDeliveryDetails: UILabel!
    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var viewDeliveryHeight: NSLayoutConstraint! //644
    @IBOutlet weak var viewDeliverySectionHeight: NSLayoutConstraint!
    @IBOutlet weak var txtAddress: UIFloatingTextField!
    @IBOutlet weak var txtStreetName: UIFloatingTextField!
    @IBOutlet weak var txtFlatVillaNo: UIFloatingTextField!
    @IBOutlet weak var txtCity: UIFloatingTextField!
    @IBOutlet weak var txtState: UIFloatingTextField!
    @IBOutlet weak var txtZipCode: UIFloatingTextField!
    
    @IBOutlet weak var lblTearmCondition: UILabel!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var lblSubmit: UILabel!
    
    
    
    
    //MARK: - Veriable
    var arrListOfDropDown:[Any] = []
    var selectIndex = 0
    var delegate_SubmitAnyBranchInfo_protocol: SubmitAnyBranchInfo_protocol?
    var viewType = ""
    var header1Detail = ""
    var addonServices = AddonServices.debitcard
    var selectKioskLocationIndex = 0
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
        setupBasic()
        setupTextField()
        setUIStep1(viewType: viewType)
        tblListHeader2.reloadData()
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitleHeader1.text = Localize(key: "How will you receive the card?")
        lblTitleHeader2.text = Localize(key: "How will you receive the card?")
        
        lblBranchDetail.text = Localize(key: "Branch Details")
        lblKioskDetails.text = Localize(key: "Kiosk Details")
        lblDeliveryDetails.text = Localize(key: "Delivery Details")
        
        
        lblSubmit.text = Localize(key: "SUBMIT")
    }
    func registerCell(){
        tblListHeader2.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }
    func setupBasic(){
        if applyValidation{
            AppHelper.disableNextBTN(view_: viewSubmit)
        }
       
        
        //--
        lblDetailHeader1.text = header1Detail
        lblTearmCondition.attributedText = Localize(key: "By clicking Submit, you agree to our Terms & Conditions").underlineWords(words: ["Terms & Conditions"], color: .DARKGREENTINT)
            //attributedStringWithColor(["Personal"], color: UIColor(named: "DARKGREENTINT")!)
    }
    func setupTextField(){
        
        //Branch
        txtBranch.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtBranch.setTitlePlaceholder(text_: Localize(key: "Select branch you would like to collect"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtBranch.txtType.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingDidBegin)
        
        txtDate.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtDate.setTitlePlaceholder(text_: Localize(key: "Date"), placeholder_: Localize(key: "Select Date"), isUserInteraction: true)
        txtDate.txtType.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingDidBegin)
        
        txtTime.setICON(hidden: true)
        txtTime.setTitlePlaceholder(text_: Localize(key: "Time"), placeholder_: Localize(key: "Enter time"), isUserInteraction: true)
        
        //Kiosk
        txtKioskLocation.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtKioskLocation.setTitlePlaceholder(text_: Localize(key: "Select Kiosk Location"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        txtKioskLocation.txtType.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingDidBegin)
        
        //Delivery
        txtAddress.setICON(hidden: true)
        txtAddress.setTitlePlaceholder(text_: Localize(key: "Address"), placeholder_: Localize(key: "Enter address"), isUserInteraction: true)
        
        txtStreetName.setICON(hidden: true)
        txtStreetName.setTitlePlaceholder(text_: Localize(key: "Street Name"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        
        txtFlatVillaNo.setICON(hidden: true)
        txtFlatVillaNo.setTitlePlaceholder(text_: Localize(key: "Flat/Villa name"), placeholder_: Localize(key: "Enter no."), isUserInteraction: true)
        
        txtCity.setICON(hidden: true)
        txtCity.setTitlePlaceholder(text_: Localize(key: "City"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        
        txtState.setICON(hidden: true)
        txtState.setTitlePlaceholder(text_: Localize(key: "State"), placeholder_: Localize(key: "Enter name"), isUserInteraction: true)
        
        txtZipCode.setICON(hidden: true)
        txtZipCode.setTitlePlaceholder(text_: Localize(key: "Zip Code"), placeholder_: Localize(key: "Enter code"), isUserInteraction: true)
        
        
    }
    func setUIStep1(viewType: String){
        viewHeader1.isHidden = false
        viewHeader2.isHidden = true
        viewHeader2Height.constant = 117
        if viewType == "branch"{
            viewBranchSectionHeight.constant = 0
            viewBranchDetail.isHidden = false
            viewKioskDetails.isHidden = true
            viewDeliveryHeight.constant = 356
            viewDelivery.isHidden = true
        }else if viewType == "kiosk"{
            viewKioskSectionHeight.constant = 0
            viewBranchDetail.isHidden = true
            viewKioskDetails.isHidden = false
            viewDeliveryHeight.constant = 164
            viewDelivery.isHidden = true
        }else if viewType == "delivery"{
            viewDeliverySectionHeight.constant = 0
            viewBranchDetail.isHidden = true
            viewKioskDetails.isHidden = true
            viewDeliveryHeight.constant = 644
            viewDelivery.isHidden = false
        }
    }
    func setUIStep2(viewType: String){
        viewHeader1.isHidden = true
        viewHeader2.isHidden = false
        viewHeader2Height.constant = CGFloat(117 + (arrListOfDropDown.count * 49))
        if viewType == "branch"{
            viewBranchSectionHeight.constant = 10
        }else if viewType == "kiosk"{
            viewKioskSectionHeight.constant = 10
        }else if viewType == "delivery"{
            viewDeliverySectionHeight.constant = 10
        }
    }

    //MARK: - @IBAction
    @IBAction func btnCloseHeader1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDetailHeader1(_ sender: Any) {
        setUIStep2(viewType: viewType)
    }
    @IBAction func btnTearmCondition(_ sender: Any) {
    }
    @IBAction func btnSubmit(_ sender: Any) {        
        self.dismiss(animated: true, completion: nil)
        delegate_SubmitAnyBranchInfo_protocol?.onSuccess()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        textField.endEditing(true)
        if textField == txtBranch.txtType{
         
        }
        if textField == txtDate.txtType{
         
        }
        
        if textField == txtKioskLocation.txtType{
            /*//--
            let list = ManageDropDownOption.getDropDownValue(dropdown_filed: DropDownOptionsEnum.getValue(.)())
            self.openDropDownPicker(headerTitle: "Kiosk Location",
                                    dropDownType: "kiosk_location",
                                    arrList: list,
                                    selectedIndex: selectKioskLocationIndex)*/
        }
    }
}
extension AnyBranchInfoVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        if droDownType == "kiosk_location"{
            txtKioskLocation.txtType.text = title
            selectKioskLocationIndex = index
        }
    }
}
extension AnyBranchInfoVC: UITableViewDelegate, UITableViewDataSource
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
        
        cell.lblTitle.text = (arrListOfDropDown[indexPath.row] as! String)
        
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
        tblListHeader2.reloadData()
        
    }
}
