//
//  TermsConditionsVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 15/02/22.
//

import UIKit

class TermsConditionsVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var lblBottomDetail: UILabel!
    
    
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        setupBasic()

    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblTitle.text = Localize(key: "Terms & Conditions")
        lblDetail.text = Localize(key: "TermAndCond_Text")
        lblBottomDetail.attributedText = Localize(key: "My clicking Next, you agree to our Terms & Conditions").attributedStringWithColor(["Terms & Conditions"], color: .DARKGREENTINT)
        lblNext.text = Localize(key: "NEXT")
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
        //--
        
    }
    
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        //--
        let vc = AddSignatureVC(nibName: "AddSignatureVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

