
//
//  SourceofFundsVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 03/02/22.
//

import UIKit

protocol didSelectSourceofFunds_protocol {
    func didSelectSourceofFunds(text: String, otherEnterText: String, index: Int)
}
class SourceofFundsVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var viewbgStep1_top: NSLayoutConstraint!
    @IBOutlet weak var lblSourceofFundsStep1: UILabel!
    @IBOutlet weak var tblSourceofFundsStep1: UITableView!
    
    @IBOutlet weak var viewbgStep2: UIView!
    @IBOutlet weak var lblSourceofFundsStep2: UILabel!
    @IBOutlet weak var lblOtherStep2: UILabel!
    @IBOutlet weak var lblOtherDetailsStep2: UILabel!
    @IBOutlet weak var txtPleaseSpecifyStep2: UIFloatingTextField!
    @IBOutlet weak var viewbgBtnSubmitStep2: UIView!
    @IBOutlet weak var lblSubmitStep2: UILabel!
    
    @IBOutlet weak var viewbgStep3: UIView!
    @IBOutlet weak var viewbgStep3_height: NSLayoutConstraint!
    @IBOutlet weak var lblOtherDetailsStep3: UILabel!
    @IBOutlet weak var txtPlaseSpecifyStep3: UIFloatingTextField! //209
    @IBOutlet weak var viewbgBtnSubmitStep3: UIView!
    @IBOutlet weak var lblSubmitStep3: UILabel!
    
    
    //MARK: Veriable
    var arrListOfDropDown:[String] = []
    var selectIndex = 0
    var pleaseSpecifyText = ""
    var pleaseSpecifyTextPlaceHolder = ""
    var stepTitle = ""
    var delegate_didSelectSourceofFunds_protocol: didSelectSourceofFunds_protocol?
    var otherTextSourceofFund = ""
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()

        //--
        lblSourceofFundsStep1.text = stepTitle
        lblSourceofFundsStep2.text = stepTitle
        
        //--
        txtPleaseSpecifyStep2.setICON(hidden: true)
        txtPleaseSpecifyStep2.setTitlePlaceholder(text_: pleaseSpecifyText, placeholder_: pleaseSpecifyTextPlaceHolder, isUserInteraction: true)
        txtPlaseSpecifyStep3.setICON(hidden: true)
        txtPlaseSpecifyStep3.setTitlePlaceholder(text_: pleaseSpecifyText, placeholder_: pleaseSpecifyTextPlaceHolder, isUserInteraction: true)
        
        txtPleaseSpecifyStep2.txtType.text = otherTextSourceofFund
        txtPlaseSpecifyStep3.txtType.text = otherTextSourceofFund
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        //--
        lblSubmitStep2.text = Localize(key: "SUBMIT")
        lblSubmitStep3.text = Localize(key: "SUBMIT")
    
    }
    func registerCell(){
        tblSourceofFundsStep1.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }

    func showStep3()
    {
        viewbgStep1_top.constant = 0
        viewbgStep3.isHidden = false
        viewbgStep3_height.constant = 209
    }
    func hideStep3(){
        viewbgStep3.isHidden = true
        viewbgStep3_height.constant = 0
    }

    //MARK: @IBAction
    @IBAction func btnCloseStep1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSubmitStep2(_ sender: Any) {
        //--
        delegate_didSelectSourceofFunds_protocol?.didSelectSourceofFunds(text: "", otherEnterText: txtPleaseSpecifyStep2.txtType.text!, index: selectIndex)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCloseStep2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnOther_Step2(_ sender: Any) {
        viewbgStep2.isHidden = true
        showStep3()
    }
    @IBAction func btnSubmitStep3(_ sender: Any) {
        //--
        delegate_didSelectSourceofFunds_protocol?.didSelectSourceofFunds(text: "", otherEnterText: txtPlaseSpecifyStep3.txtType.text!, index: selectIndex)
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension SourceofFundsVC: UITableViewDelegate, UITableViewDataSource
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
        tblSourceofFundsStep1.reloadData()
        
        //--
        if indexPath.row == arrListOfDropDown.count - 1{
            viewbgStep2.isHidden = false
            
        }else{
            
            //--
            delegate_didSelectSourceofFunds_protocol?.didSelectSourceofFunds(text: arrListOfDropDown[indexPath.row], otherEnterText: "", index: selectIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
