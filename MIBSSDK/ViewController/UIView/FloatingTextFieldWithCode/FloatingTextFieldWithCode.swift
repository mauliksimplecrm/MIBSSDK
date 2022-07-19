//
//  FloatingTextFieldWithCode.swift
//  Maisarah
//
//  Created by Maulik Vora on 03/02/22.
//

import Foundation
import UIKit


class FloatingTextFieldWithCode: UIView {
    
    //MARK:  IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnSelectCode: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var viewbgBottomLine: UIView!
    @IBOutlet weak var lblError: UILabel!
    
    
    
    //MARK: Veriable
    let nibName = "FloatingTextFieldWithCode"
    var contentView: UIView?
    var delegate_UIFloatingTextField_Protocol:UIFloatingTextField_Protocol?
    var didChangeCharacter: ((UITextField) -> (Bool))? = nil
    
    
    //MARK: func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    //MARK: Func
    func setTitlePlaceholder(text_: String, placeholder_: String, isUserInteraction: Bool){
        lblTitle.text = text_
        txtType.placeholder = placeholder_
        txtType.isUserInteractionEnabled = isUserInteraction
        
        if Managelanguage.getLanguageCode() == "ar"
        {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            txtType.semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            lblTitle.semanticContentAttribute = .forceLeftToRight
            txtType.semanticContentAttribute = .forceLeftToRight
        }
    }
    

    //MARK: @IBAction
    @IBAction func btnSelectCode(_ sender: Any) {
        delegate_UIFloatingTextField_Protocol?.btnOpenCountryCodePicker(textField: txtType)
    }
    @IBAction func editingChanged(_ sender: Any) {
        delegate_UIFloatingTextField_Protocol?.editingChanged(textField: txtType)
    }
    
}
extension FloatingTextFieldWithCode: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let returnValue = delegate_UIFloatingTextField_Protocol?.shouldChangeCharactersIn(textField: textField, txt: updatedText) ?? true
            return returnValue
        }else{
            let returnValue = delegate_UIFloatingTextField_Protocol?.shouldChangeCharactersIn(textField: textField, txt: "") ?? true
            return returnValue
        }
     
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblTitle.textColor = .GREEN
        viewbgBottomLine.backgroundColor = .GREEN
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        lblTitle.textColor = .MIDGREY
        viewbgBottomLine.backgroundColor = .LIGHTGREY
    }
}


