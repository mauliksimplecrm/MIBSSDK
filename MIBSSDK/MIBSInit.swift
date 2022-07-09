//
//  MIBSInit.swift
//  MIBSSDK
//
//  Created by Maulik Vora on 08/07/22.
//

import Foundation
import UIKit


public class MIBSInit {
    let hello = "Hello"
    public var uv:UIViewController!
    
    public init(uv:UIViewController) {
        self.uv = uv
    }

    public func hello(to whom: String) -> String {
        return "Hello \(whom)"
    }
    
    public func loadData(){
        let frameworkBundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
         //vc.newsObj = newsObj
        uv.navigationController?.pushViewController(vc,animated: true)
    }
}
