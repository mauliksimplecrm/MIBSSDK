//
//  MIBSInit.swift
//  MIBSSDK
//
//  Created by Maulik Vora on 08/07/22.
//

import Foundation
import UIKit
//var appDelegate = UIApplication()

public class MIBSInit: NSObject {
    let hello = "Hello"
    @objc public var uv:UIViewController!
    
    @objc public init(uv:UIViewController) {
        self.uv = uv
    }
    
    @objc public func hello(to whom: String) -> String {
        return "Hello \(whom)"
    }
    
    @objc public func loadData(){
        let frameworkBundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "MIBSInitSB", bundle: frameworkBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        uv.navigationController!.pushViewController(vc, animated: true)
        
        
        /*let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
         let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
         //appDelegate.keyWindow = UIWindow(frame: UIScreen.main.bounds)
         UIApplication().keyWindow?.rootViewController = initialViewControlleripad
         UIApplication().keyWindow?.makeKeyAndVisible()*/
        //        let vcs = FirstVC()
        //        vcs.loadSecondVC()
        
    }
}
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
