//
//  ApplicationStatusVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 12/07/22.
//

import UIKit

class ApplicationStatusVC: UIViewController {

    //MARK: @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var lblApplicationNumber_title: UILabel!
    @IBOutlet weak var lblApplicationNumber_value: UILabel!
    
    @IBOutlet weak var lblAppStatus_title: UILabel!
    @IBOutlet weak var lblAppStatus_value: UILabel!
    
    @IBOutlet weak var lblAppSubmitted_title: UILabel!
    @IBOutlet weak var lblAppSubmitted_value: UILabel!
    
    @IBOutlet weak var lblGoToDashboard: UILabel!
    @IBOutlet weak var lblContinueApplication: UILabel!
    @IBOutlet weak var viewbgApplicationSubmitted: UIView!
    @IBOutlet weak var viewbgContinueApp: UIView!
    
    //MARK: - Veriable
    var validateOTPApplications:ValidateOTPApplications?
    
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setApplicationData()
        
    }
    func setupHeader(){
        headerView.viewbgScheduleCall.isHidden = false
        headerView.nav = self.navigationController!
        headerView.btnScheduleaCall.setTitle(Localize(key: "Schedule a Call"), for: .normal)
        headerView.didTappedBack = { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setApplicationData(){
        lblApplicationNumber_value.text = validateOTPApplications?.application_id ?? ""
        lblAppStatus_value.text = validateOTPApplications?.status_display ?? ""
        
        if validateOTPApplications?.status == ApplicationStatus.application_submitted.rawValue{
            apiCall_getApplicationData { result in
                self.lblAppSubmitted_value.text = result.application_submitted_date_c as? String ?? ""
                self.viewbgApplicationSubmitted.isHidden = false
                
            }
            
        }else{
            viewbgApplicationSubmitted.isHidden = true
            
        }
        
        if validateOTPApplications?.status == ApplicationStatus.InProgress.rawValue{
            viewbgContinueApp.isHidden = false
        }else{
            viewbgContinueApp.isHidden = true
        }
        
    }


    //MARK: - @IBAction
    @IBAction func btnGoToDashboard(_ sender: Any) {
        //--
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnContinueApplication(_ sender: Any) {
        self.findLastApplicationStep()
    }
    

}


