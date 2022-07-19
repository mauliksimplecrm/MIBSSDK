//
//  LoadingView.swift
//  Maisarah
//
//  Created by Maulik Vora on 10/03/22.
//

import UIKit
import Foundation
import Popover

/*protocol LoadingView_Protocol {
    func btnCancelLoding()
}*/
class LoadingView: UIView {
    //MARK: - @IBOutlet
    @IBOutlet var viewbg_loading: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle_loading: UILabel!
    @IBOutlet weak var lblDetail_loading: UILabel!
    @IBOutlet weak var imgLoading: UIImageView!
    
    
    //MARK: - Veriable
    let nibName = "LoadingView"
    var contentView: UIView?
    //var delegate_LoadingView_Protocol:LoadingView_Protocol?
    
    let popover = Popover()
   
    static let shared = LoadingView.instanceFromNib()
    
    //MARK: - Func
    class func instanceFromNib() -> LoadingView {
            let myClassNib = UINib(nibName: "LoadingView", bundle: nil)
            return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! LoadingView
        }
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        guard let view = loadViewFromNib() else { return }
//        view.frame = self.bounds
//        self.addSubview(view)
//        contentView = view
//
//
//    }
//
//    func loadViewFromNib() -> UIView? {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }

    func openLodingAlert(view: UIView){
        //--
        let loadingView = LoadingView.instanceFromNib()
        loadingView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let aView = UIView()
        aView.frame = loadingView.frame
        aView.addSubview(loadingView)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(loadingView, inView: view)
        loadingView.viewbg_loading.rotate()
        //loadingView.delegate_LoadingView_Protocol = self
        loadingView.btnCancel.isHidden = true
    }
    func dismissLoadingView()
    {
        popover.dismiss()
    }
    
    //MARK: - @IBAction
    @IBAction func btnCancel_loading(_ sender: Any) {
        popover.dismiss()
        //delegate_LoadingView_Protocol?.btnCancelLoding()
    }
    
}
