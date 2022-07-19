//
//  RequestSentLivenesscheckVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 27/01/22.
//

import UIKit

class RequestSentLivenesscheckVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblGotoDashboard: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        
    
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = true
        headerView.nav = self.navigationController!
        headerView.lblHeaderTitle.text = "Schedule Video Call"
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }


    //MARK: @IBAction
    @IBAction func btnGoToDashboard(_ sender: Any) {
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnContinue(_ sender: Any) {
        //--
        let vc = TermsConditionsVC(nibName: "TermsConditionsVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


