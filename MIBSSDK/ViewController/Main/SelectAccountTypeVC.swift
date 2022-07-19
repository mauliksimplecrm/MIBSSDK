//
//  SelectAccountTypeVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 21/01/22.
//

import UIKit
import Popover

class SelectAccountTypeVC: UIViewController {
    // MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet var viewbg_intro_alert: UIView!
    @IBOutlet weak var img_intro_alert: UIImageView!
    @IBOutlet weak var lblTitle_intro_alert: UILabel!
    @IBOutlet weak var lblDetail_intro_alert: UILabel!
    @IBOutlet weak var btnGotit_intro_alert: UIButton!
    
    @IBOutlet weak var lblSavingAccount_title: UILabel!
    @IBOutlet weak var lblSavingAccount_detail: UILabel!
    @IBOutlet weak var lblCurrentAccount_title: UILabel!
    @IBOutlet weak var lblCurrentAccount_detail: UILabel!
    @IBOutlet weak var lblPrizeAccount_title: UILabel!
    @IBOutlet weak var lblPrizeAccount_detail: UILabel!
    
    
    
    // MARK: Veriable
    var popover = Popover()
    var accountType = AccountType.saving
    var validateOTPStep = ""
    
    // MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupHeader()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        localization()
        self.navigationController?.navigationBar.isHidden = true
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
        lblTitle.attributedText = Localize(key: "Select Account Type").attributedStringWithColor(["Account Type"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Select Account Type detail")
    }
    func openIntroAlert(){
        //--
        viewbg_intro_alert.frame.size = CGSize(width: self.view.frame.width-20, height: viewbg_intro_alert.frame.height)
        let aView = UIView()
        aView.frame = viewbg_intro_alert.frame
        aView.addSubview(viewbg_intro_alert)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblSavingAccount_title.text = Localize(key: "Saving Account")
        lblSavingAccount_detail.text = Localize(key: "Saving Account Detail")
        lblCurrentAccount_title.text = Localize(key: "Current Account")
        lblCurrentAccount_detail.text = Localize(key: "Current Account Detail")
        lblPrizeAccount_title.text = Localize(key: "Prize Account")
        lblPrizeAccount_detail.text = Localize(key: "Prize Account Detail")
        
        btnGotit_intro_alert.setTitle(Localize(key: "GOT IT"), for: .normal)
    }

    // MARK: @IBAction
    @IBAction func btnSavingAccount(_ sender: Any) {
        lblTitle_intro_alert.text = Localize(key: "Saving Account")
        lblDetail_intro_alert.text = Localize(key: "Saving Account Detail 2")
        img_intro_alert.image = UIImage(named: "ic_saving_account")
        accountType = .saving
        
        openIntroAlert()
    }
    @IBAction func btnCurrentAccount(_ sender: Any) {
        lblTitle_intro_alert.text = Localize(key: "Current Account")
        lblDetail_intro_alert.text = Localize(key: "Current Account Detail 2")
        img_intro_alert.image = UIImage(named: "ic_current_account")
        accountType = .current
        
        openIntroAlert()
    }
    @IBAction func btnPrizeAccount(_ sender: Any) {
        lblTitle_intro_alert.text = Localize(key: "Prize Account")
        lblDetail_intro_alert.text = Localize(key: "Prize Account Detail 2")
        img_intro_alert.image = UIImage(named: "ic_prize_account")
        accountType = .prize
     
        openIntroAlert()
    }
    
    @IBAction func btnGotit_intro_alert(_ sender: Any) {
        popover.dismiss()
       
        //--
        let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
        vc.serviceType = .StartAccountOpening
        vc.validateOTPStep = validateOTPStep
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        //--
        if accountType == .saving {
            //--
            let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
            vc.serviceType = .StartAccountOpening
            self.navigationController?.pushViewController(vc, animated: true)
            
            /*
            //--Temp
            let vc = SelectCitizenshipVC(nibName: "SelectCitizenshipVC", bundle: nil)
            //vc.citizenshipType = CitizenshipType.omani
            self.navigationController?.pushViewController(vc, animated: false)
             */
        }else if accountType == .current{
            //--
            let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
            vc.serviceType = .StartAccountOpening
            self.navigationController?.pushViewController(vc, animated: true)
        }else if accountType == .prize{
            //--
            let vc = EnterMobileEmailVC(nibName: "EnterMobileEmailVC", bundle: nil)
            vc.serviceType = .StartAccountOpening
            self.navigationController?.pushViewController(vc, animated: true)
        }
         */
    }
    

}

