//
//  HeaderView.swift
//  Melo
//
//  Created by Maulik Vora on 07/02/21.
//

import UIKit

/*
@objc public protocol HeaderView_Protocol : NSObjectProtocol{
    @objc optional func btnBack()
    @objc optional func btnScheduleVideoCall()
}
*/

class HeaderView: UIView {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var viewbg_back: UIView!
 
    @IBOutlet weak var btnScheduleaCall: UIButton!
    @IBOutlet weak var viewbgScheduleCall: UIView!
    
    
    
    //MARK: - Veriable
    let nibName = "HeaderView"
    var contentView: UIView?
    var nav = UINavigationController()
    //weak var delegate_HeaderView : HeaderView_Protocol? = nil
    
    var didTappedBack: ((UIButton) -> (Void))? = nil
    
    
    //MARK:- func
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
    
    
    
    //MARK:- IBAction
    @IBAction func btnBack(_ sender: UIButton) {
        //self.delegate_HeaderView?.btnBack?()
        //--
        //nav.popViewController(animated: true)
        
        if self.didTappedBack != nil {
            self.didTappedBack!(sender)
        }
    }

    @IBAction func btnScheduleAcall(_ sender: Any) {
        //self.delegate_HeaderView?.btnScheduleVideoCall?()
        //--
        let vc = ScheduleVideoCallVC(nibName: "ScheduleVideoCallVC", bundle: nil)
        nav.pushViewController(vc, animated: true)
    }
    
    
    
    
}
