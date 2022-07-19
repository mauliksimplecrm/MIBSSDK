//
//  MobileBankingVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 21/02/22.
//

import UIKit

class MobileBankingVC: UIViewController {

    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtLoginPWD: UIFloatingTextField!
    @IBOutlet weak var txtConfirmLoginPWD: UIFloatingTextField!
    @IBOutlet weak var txtTransactionPWD: UIFloatingTextField!
    @IBOutlet weak var txtConfirmTransactionPWD: UIFloatingTextField!
    
    @IBOutlet weak var lblTearmAndCondition: UILabel!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var lblConfirm: UILabel!
    
    //--
    @IBOutlet weak var viewStepFooter: UIView!
    @IBOutlet weak var progressStepFooter: UIProgressView!
    @IBOutlet weak var lblViewStepFooter: UILabel!
    @IBOutlet weak var lblNextStepFooter: UILabel!
    @IBOutlet weak var viewNextStepFooter: UIView!
    
    
    //MARK: - Veriable
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
        progressStepFooter.setProgress(1.0, animated: true)
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitle.text = Localize(key: "Mobile banking details")
        lblDetail.text = Localize(key: "Mobile banking details 1")
        
        lblConfirm.text = Localize(key: "CONFIRM")
        lblViewStepFooter.text = Localize(key: "VIEW STEPS")
        lblNextStepFooter.text = Localize(key: "NEXT")
        
        //--
        if Managelanguage.getLanguageCode() == "ar"
        {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            lblTearmAndCondition.semanticContentAttribute = .forceRightToLeft
        }else{
            lblTitle.semanticContentAttribute = .forceLeftToRight
            lblDetail.semanticContentAttribute = .forceLeftToRight
            lblTearmAndCondition.semanticContentAttribute = .forceLeftToRight
        }
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
            //AppHelper.disableNextBTN(view_: viewConfirm)
        }
       
        //--
        if addonServices == .both{
            viewStepFooter.isHidden = false
        }else{
            viewStepFooter.isHidden = true
        }
        //--
        lblTearmAndCondition.attributedText = Localize(key: "By clicking Submit, you agree to our Terms & Conditions").underlineWords(words: ["Terms & Conditions"], color: .DARKGREENTINT)

    }
    func setupTextField(){
        txtLoginPWD.setICON(hidden: true)
        txtLoginPWD.setTitlePlaceholder(text_: Localize(key: "Login Password"), placeholder_: Localize(key: "Enter password"), isUserInteraction: true)
        txtLoginPWD.txtType.isSecureTextEntry = true
        txtConfirmLoginPWD.setICON(hidden: true)
        txtConfirmLoginPWD.setTitlePlaceholder(text_: Localize(key: "Confirm Login Password"), placeholder_: Localize(key: "Enter password"), isUserInteraction: true)
        txtConfirmLoginPWD.txtType.isSecureTextEntry = true
        txtTransactionPWD.setICON(hidden: true)
        txtTransactionPWD.setTitlePlaceholder(text_: Localize(key: "Transaction Password"), placeholder_: Localize(key: "Enter password"), isUserInteraction: true)
        txtTransactionPWD.txtType.isSecureTextEntry = true
        txtConfirmTransactionPWD.setICON(hidden: true)
        txtConfirmTransactionPWD.setTitlePlaceholder(text_: Localize(key: "Confirm Transaction Password"), placeholder_: Localize(key: "Enter password"), isUserInteraction: true)
        txtConfirmTransactionPWD.txtType.isSecureTextEntry = true
    }
    
    //MARK: - @IBAction
    @IBAction func btnTearmAndCondition(_ sender: Any) {
    }
    @IBAction func btnConfirm(_ sender: Any) {
        
        //--
        let vc = MobileBankingSubmittedVC(nibName: "MobileBankingSubmittedVC", bundle: nil)
        vc.addonServices = addonServices
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewStep(_ sender: Any) {
        //--
        let vc = StepIndicatorVC(nibName: "StepIndicatorVC", bundle: nil)
        vc.selectIndex = 1
        vc.totalStep = 2
        vc.progress = 1.0
        vc.arrListOfDropDown = ["Debit Card details", "Mobile Banking details"]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnNextStepFooter(_ sender: Any) {
        //--
        let vc = MobileBankingSubmittedVC(nibName: "MobileBankingSubmittedVC", bundle: nil)
        vc.addonServices = addonServices
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

