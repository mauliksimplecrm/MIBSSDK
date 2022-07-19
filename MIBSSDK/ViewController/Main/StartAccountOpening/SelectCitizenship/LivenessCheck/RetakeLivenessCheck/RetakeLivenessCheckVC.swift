//
//  RetakeLivenessCheckVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 27/01/22.
//

import UIKit

class RetakeLivenessCheckVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValidationText: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblbtnRetake: UILabel!
    @IBOutlet weak var viewbgBtnRetake: UIView!
    
    //MARK: - Veriable
    var CountOfSmileDetectVerify = 1
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupBasic()
        localization()
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
    
        //--
        lblTitle.attributedText = Localize(key: "We can't proceed further Facial Match Failed").attributedStringWithColor(["can't proceed"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Go back to retake liveness test")
        lblbtnRetake.text = Localize(key: "RETAKE")
        
        
        //--
        lblValidationText.text = "You only have \(3 - CountOfSmileDetectVerify) attempt remaining"
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        headerView.nav = self.navigationController!
        headerView.lblHeaderTitle.text = Localize(key: "Liveness Check")
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupBasic(){
     
        
    }
    

    //MARK: @IBAction
    @IBAction func btnRetake(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}



