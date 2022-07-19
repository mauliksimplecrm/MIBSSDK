//
//  Image.swift
//  Maisarah
//
//  Created by Maulik Vora on 29/01/22.
//

import Foundation
import UIKit

extension UIImage
{
    static let IMGDoneGreen = UIImage(named: "ic_fill_correct_green")!
    static let IMGDropDownGreen = UIImage(named: "ic_dropdown_green")!
    static let IMGValidationRed = UIImage(named: "ic_fill_validation")!
    
    static let IMGCheckGreen = UIImage(named: "ic_check_green")!
    static let IMGUnCheckGray = UIImage(named: "ic_uncheck_gray")!
    
    static let IMGRadioFill = UIImage(named: "ic_radio_fill")!
    static let IMGRadioUnFill = UIImage(named: "ic_radio_unfill")!
}

extension UIImage{
    func convertImageToBase64String (compressionQuality: CGFloat = 0.7) -> String {
        if let imageData = self.jpegData(compressionQuality: compressionQuality) {
            let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
            return "data:image/jpeg;base64,\(imgString)"
        }else{
            return ""
        }
    }
}
