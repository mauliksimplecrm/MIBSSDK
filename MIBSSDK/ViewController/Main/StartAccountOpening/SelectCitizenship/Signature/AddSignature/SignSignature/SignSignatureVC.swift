//
//  SignSignatureVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 15/02/22.
//

import UIKit

protocol didSignSignature_protocol {
    func didSignSignature_protocol(img: UIImage)
}
class SignSignatureVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var lblUploadNewSignature: UILabel!
    @IBOutlet weak var viewSignature: YPDrawSignatureView!
    @IBOutlet weak var lblInfo: UILabel!
    
    
    //MARK: - Veriable
    var delegate_didSignSignature_protocol: didSignSignature_protocol?
    
    //MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        
        //--
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        //--
        viewSignature.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //--
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
 
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
        lblInfo.text = Localize(key: "Sign with your finger here.")
        lblUploadNewSignature.text = Localize(key: "UPLOAD NEW SIGNATURE")
        
    }

    //MARK: - @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUploadNewSignature(_ sender: Any) {
        if let signatureImage = self.viewSignature.getSignature(scale: 10) {
            //--
            delegate_didSignSignature_protocol?.didSignSignature_protocol(img: signatureImage)
            
            //--
            self.viewSignature.clear()
            
            //--
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension SignSignatureVC: YPSignatureDelegate{
    func didStart(_ view : YPDrawSignatureView) {
        print("Started Drawing")
        lblInfo.isHidden = true
    }
    func didFinish(_ view : YPDrawSignatureView) {
        print("Finished Drawing")
    }
}
