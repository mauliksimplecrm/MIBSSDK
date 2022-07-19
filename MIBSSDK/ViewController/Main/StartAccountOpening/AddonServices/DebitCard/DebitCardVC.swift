//
//  DebitCardVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 19/02/22.
//

import UIKit

class DebitCardVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtReceiveCard: UIFloatingTextField!
    @IBOutlet weak var lblGenerateVirtualCall_info: UILabel!
    @IBOutlet weak var lblTearmAndCondition: UILabel!
    @IBOutlet weak var viewbgNext: UIView!
    @IBOutlet weak var lblNext: UILabel!
    
    //--
    @IBOutlet weak var viewStepFooter: UIView!
    @IBOutlet weak var progressStepFooter: UIProgressView!
    @IBOutlet weak var lblViewStepFooter: UILabel!
    @IBOutlet weak var lblNextStepFooter: UILabel!
    @IBOutlet weak var viewNextStepFooter: UIView!
    
    
    
    
    //MARK: - Veriable
    var selectReceiveCardIndex = -1
    var arrListReciveCard = ["Collecting from any branch", "Printing from Kiosk", "Only Digital Card", "Delivery to me"]
    var addonServices = AddonServices.debitcard
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        setupBasic()
        setupTextField()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        progressStepFooter.setProgress(0.5, animated: true)
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitle.text = Localize(key: "Debit Card details")
        lblDetail.text = Localize(key: "Debit Card detail")
        lblGenerateVirtualCall_info.text = Localize(key: "We will generate a virtual card for you to use immediately")
        lblTearmAndCondition.attributedText = Localize(key: "By clicking Submit, you agree to our Terms & Conditions").underlineWords(words: ["Terms & Conditions"], color: UIColor(named: "DARKGREENTINT")!)

        lblViewStepFooter.text = Localize(key: "VIEW STEPS")
        lblNext.text = Localize(key: "NEXT")
        lblNextStepFooter.text = Localize(key: "NEXT")
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
        //AppHelper.disableNextBTN(view_: viewbgNext)
        //AppHelper.disableNextBTN(view_: viewNextStepFooter)
        
        //--
        if addonServices == .both{
            viewStepFooter.isHidden = false
        }else{
            viewStepFooter.isHidden = true
        }
        //--
            //attributedStringWithColor(["Personal"], color: UIColor(named: "DARKGREENTINT")!)
    }
    func setupTextField(){
        txtReceiveCard.setICON(img_: .IMGDropDownGreen, hidden: false)
        txtReceiveCard.setTitlePlaceholder(text_: Localize(key: "How will you receive the card?"), placeholder_: Localize(key: "Select"), isUserInteraction: true)
        //txtReceiveCard.txtType.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingDidBegin)
        
    }


    //MARK: @IBAction
    @IBAction func btnInfoGenerateVirtualCard(_ sender: Any) {
        
    }
    @IBAction func btnNext(_ sender: Any) {
        //--
        let vc = MobileBankingVC(nibName: "MobileBankingVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func btnTearmCondition(_ sender: Any) {
    
    }
    @IBAction func btnViewStep(_ sender: Any) {
        //--
        let vc = StepIndicatorVC(nibName: "StepIndicatorVC", bundle: nil)
        vc.selectIndex = 0
        vc.totalStep = 2
        vc.progress = 0.5
        vc.arrListOfDropDown = ["Debit Card details", "Mobile Banking details"]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnNextStepFooter(_ sender: Any) {
        
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.endEditing(true)
        if textField == txtReceiveCard.txtType{
            //--
            let vc = CustomDorpDownVC(nibName: "CustomDorpDownVC", bundle: nil)
            vc.delegate_didSelectCustomDropDown_Protocol = self
            vc.headerTitle = Localize(key: "How will you receive the card?")
            vc.dropDownType = "receiveCard"
            vc.arrListOfDropDown = arrListReciveCard
            vc.selectIndex = selectReceiveCardIndex
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}

extension DebitCardVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String) {
        if droDownType == "receiveCard"{
            txtReceiveCard.txtType.text = title
            selectReceiveCardIndex = index
            
            //--
            let vc = AnyBranchInfoVC(nibName: "AnyBranchInfoVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.addonServices = addonServices
            vc.delegate_SubmitAnyBranchInfo_protocol = self
            vc.arrListOfDropDown = arrListReciveCard
            vc.header1Detail = title
            vc.selectIndex = selectReceiveCardIndex
            
            //--
            if selectReceiveCardIndex == 0{
                //--
                vc.viewType = "branch"
                self.present(vc, animated: true, completion: nil)
            }else if selectReceiveCardIndex == 1{
                //--
                vc.viewType = "kiosk"
                self.present(vc, animated: true, completion: nil)
            }else if selectReceiveCardIndex == 2{
                //--
                
            }else if selectReceiveCardIndex == 3{
                //--
                vc.viewType = "delivery"
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
}

extension DebitCardVC: SubmitAnyBranchInfo_protocol{
    func onSuccess(){
        //--
        let vc = VirtualDebitCardVC(nibName: "VirtualDebitCardVC", bundle: nil)
        vc.addonServices = addonServices
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
