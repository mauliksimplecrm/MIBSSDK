//
//  UIFloatingTextField.swift
//  Maisarah
//
//  Created by Maulik Vora on 29/01/22.
//

import Foundation
import UIKit

protocol UIFloatingTextField_Protocol {
    func btnOpenCountryCodePicker(textField: UITextField)
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool
    func editingChanged(textField: UITextField)
    func textFieldDidBeginEditing(textField: UITextField)
}

class UIFloatingTextField: UIView {
    
    //MARK:  IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var imgIconStatus: UIImageView!
    @IBOutlet weak var imgIconStatus_leading: NSLayoutConstraint!
    @IBOutlet weak var imgiconStatus_Width: NSLayoutConstraint!
    @IBOutlet weak var viewbgBottomLine: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnOpenDropDown: UIButton!
    
    
    
    var didTappedDropDown: ((UIButton) -> (Void))? = nil
    
    //MARK: Veriable
    let nibName = "UIFloatingTextField"
    var contentView: UIView?
    var delegate_UIFloatingTextField_Protocol:UIFloatingTextField_Protocol?
    var resignFirstResponder = false
    
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
    func setbtnDropDownUserInteraction(isUserInteraction: Bool){
        btnOpenDropDown.isUserInteractionEnabled = isUserInteraction
    }
    func setTitlePlaceholder(text_: String, placeholder_: String, isUserInteraction: Bool){
        lblTitle.text = text_
        txtType.placeholder = placeholder_
        txtType.isUserInteractionEnabled = isUserInteraction
        txtType.setRightPaddingPoints(50)
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
    func setICON(img_: UIImage? = nil, hidden: Bool){
        if hidden{
            imgIconStatus.isHidden = hidden
            imgIconStatus_leading.constant = 0
            imgiconStatus_Width.constant = 0
        }else{
            imgIconStatus.image = img_
        }
    }
    
    func hiddenTextField(txtView: UIFloatingTextField, layoutConTop: NSLayoutConstraint, layoutConHeight: NSLayoutConstraint){
        txtView.isHidden = true
        layoutConTop.constant = 0
        layoutConHeight.constant = 0
    }
    func showTextField(txtView: UIFloatingTextField, layoutConTop: NSLayoutConstraint, layoutConHeight: NSLayoutConstraint){
        txtView.isHidden = false
        layoutConTop.constant = 10
        layoutConHeight.constant = 81
    }
    
    func setSelectedDropDownUI(){
        lblTitle.textColor = .GREEN
        viewbgBottomLine.backgroundColor = .GREEN
    }
    
    //MARK: - @IBAction
    @IBAction func editingChanged(_ sender: Any) {
        delegate_UIFloatingTextField_Protocol?.editingChanged(textField: txtType)
        
    }
 
    @IBAction func btnOpenDropDown(_ sender: UIButton) {
        if self.didTappedDropDown != nil {
            self.didTappedDropDown!(sender)
        }
    }
    
  
}

extension UIFloatingTextField: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            delegate_UIFloatingTextField_Protocol?.shouldChangeCharactersIn(textField: textField, txt: updatedText)
        }else{
            delegate_UIFloatingTextField_Protocol?.shouldChangeCharactersIn(textField: textField, txt: "")
        }
        return true
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return textFieldShouldBeginEditing
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if resignFirstResponder{
            //textField.resignFirstResponder()
        }
        lblTitle.textColor = .GREEN
        viewbgBottomLine.backgroundColor = .GREEN
        delegate_UIFloatingTextField_Protocol?.textFieldDidBeginEditing(textField: txtType)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        lblTitle.textColor = .MIDGREY
        viewbgBottomLine.backgroundColor = .LIGHTGREY
    }
}

extension UIFloatingTextField: UIFloatingTextField_Protocol
{
    func shouldChangeCharactersIn(textField: UITextField, txt: String) -> Bool {
        return true
    }
    
    func btnOpenCountryCodePicker(textField: UITextField){
        
    }
    func editingChanged(textField: UITextField){
        
    }
    func shouldChangeCharactersIn(textField: UITextField, txt: String){
        
    }
    func textFieldDidBeginEditing(textField: UITextField){
        
    }
}
