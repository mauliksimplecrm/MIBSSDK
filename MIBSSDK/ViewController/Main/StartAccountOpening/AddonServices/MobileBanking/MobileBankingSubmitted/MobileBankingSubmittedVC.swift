//
//  MobileBankingSubmittedVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 22/02/22.
//

import UIKit

class MobileBankingSubmittedVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var viewGotoLogin: UIView!
    @IBOutlet weak var lblGotoLogin: UILabel!
    
    
    //MARK: - Veriable
    var addonServices = AddonServices.debitcard
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        setupBasic()
        
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
    
        lblTitle.text = Localize(key: "Mobile Banking details submitted")
        lblDetail.text = Localize(key: "Your details have been submitted. You can now login with the your account details.")
        lblGotoLogin.text = Localize(key: "GO TO LOGIN PAGE")
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
        
       
    }

    //MARK: - @IBAction
    @IBAction func btnGotoLogin(_ sender: Any) {
        AppHelper.loginSuccess()
    }
  
}

