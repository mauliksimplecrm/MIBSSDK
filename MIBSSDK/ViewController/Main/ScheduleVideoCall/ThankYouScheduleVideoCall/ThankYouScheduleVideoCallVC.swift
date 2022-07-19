//
//  ThankYouScheduleVideoCallVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 26/01/22.
//

import UIKit

class ThankYouScheduleVideoCallVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblContinueApplication: UILabel!
    
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setupHeader()
        
        
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblTitle.text = Localize(key: "Thank you!")
        lblDetail.text = Localize(key: "Thank you detail1")
        
        lblContinueApplication.text = Localize(key: "CONTINUE APPLICATION")
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        headerView.nav = self.navigationController!
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: @IBAction
    @IBAction func btnContinueApplication(_ sender: Any) {
        
    }
    
   
}
