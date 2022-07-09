//
//  MIBSInit.swift
//  MIBSSDK
//
//  Created by Maulik Vora on 08/07/22.
//

import Foundation
import UIKit


@objc public class MIBSInit: NSObject {
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
        let storyboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
         //vc.newsObj = newsObj
        uv.navigationController?.pushViewController(vc,animated: true)
    }
}
