//
//  FailedLivenessCheckVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 27/01/22.
//

import UIKit

class FailedLivenessCheckVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValidation: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblScheduleVideoCall_title: UILabel!
    @IBOutlet weak var lblDetail_ScheduelVideoCall: UILabel!
    @IBOutlet weak var lblGotodashboard: UILabel!
    
    
    
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
        lblTitle.attributedText = Localize(key: "Facial Match or other details verification failed").attributedStringWithColor(["verification"], color: .DARKGREENTINT)
        lblDetail.text = Localize(key: "Please schedule a video call with one of our agents")
        
        lblValidation.text = Localize(key: "You have failed 3 attempts for liveness check")
        lblScheduleVideoCall_title.text = Localize(key: "Schedule Video Call")
        lblDetail_ScheduelVideoCall.text = Localize(key: "Schedule Video Call Detail")
        
        lblGotodashboard.text = Localize(key: "GO TO DASHBOARD")
        
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
    @IBAction func btnScheduleVideoCall(_ sender: Any) {
        //--
        let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
        vc.isComeFromLivenessCheck = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnGotoDashboard(_ sender: Any) {
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


