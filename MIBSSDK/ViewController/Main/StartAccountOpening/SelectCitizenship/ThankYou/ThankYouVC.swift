//
//  ThankYouVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 19/02/22.
//

import UIKit

class ThankYouVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
    
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - @IBAction
    @IBAction func btn1(_ sender: Any) {
        AppHelper.loginSuccess()
    }
    @IBAction func btn2(_ sender: Any) {
        AppHelper.loginSuccess()
    }
    
    @IBAction func btnGoToDashboard(_ sender: Any) {
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

