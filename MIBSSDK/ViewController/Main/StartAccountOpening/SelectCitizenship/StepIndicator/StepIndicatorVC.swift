//
//  StepIndicatorVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 31/01/22.
//

import UIKit


class StepIndicatorVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewProgress: UIProgressView!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: Veriable
    var arrListOfDropDown:[String] = []
    var selectIndex = 0
    var totalStep = 0
    var progress = 0.0
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        registerCell()
   
        
        viewProgress.progress = Float(progress)
        lblTitle.text = "\(selectIndex+1) \(Localize(key: "of")) \(totalStep) \(Localize(key: "steps"))"
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        
    }
    func registerCell(){
        tblList.register(UINib(nibName: "StepIndicatorTblCell", bundle: nil), forCellReuseIdentifier: "StepIndicatorTblCell")
    }
    

    //MARK: @IBAction
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}

extension StepIndicatorVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfDropDown.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepIndicatorTblCell", for: indexPath) as! StepIndicatorTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrListOfDropDown[indexPath.row]
        
        if indexPath.row <= selectIndex{
            cell.lblNumber.textColor = .WHITE
            cell.lblNumber.backgroundColor = .GREEN
            cell.lblTitle.textColor = .DARKGREY
        }else{
            cell.lblNumber.textColor = .GREEN
            cell.lblNumber.backgroundColor = .WHITE
            cell.lblTitle.textColor = .MIDGREY
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
