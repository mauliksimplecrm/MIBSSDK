//
//  CustomDorpDownVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 29/01/22.
//

import UIKit

protocol didSelectCustomDropDown_Protocol {
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String)
}

class CustomDorpDownVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: Veriable
    var arrListOfDropDown:[String] = []
    var selectIndex = 0
    var delegate_didSelectCustomDropDown_Protocol: didSelectCustomDropDown_Protocol?
    var dropDownType = ""
    var headerTitle = ""
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        lblHeaderTitle.text = headerTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    func registerCell(){
        tblList.register(UINib(nibName: "CustomDropDownTblCell", bundle: nil), forCellReuseIdentifier: "CustomDropDownTblCell")
    }

    

    //MARK: @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension CustomDorpDownVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfDropDown.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDropDownTblCell", for: indexPath) as! CustomDropDownTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrListOfDropDown[indexPath.row]
        
        if indexPath.row == selectIndex{
            cell.imgSelectIcon.isHidden = false
        }else{
            cell.imgSelectIcon.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        tblList.reloadData()
        
        //--
        self.dismiss(animated: true, completion: nil)
        delegate_didSelectCustomDropDown_Protocol?.didSelectdidSelectCustomDropDown(title: arrListOfDropDown[indexPath.row], index: selectIndex, droDownType: dropDownType)
        
    }
}

extension CustomDorpDownVC: didSelectCustomDropDown_Protocol{
    func didSelectdidSelectCustomDropDown(title: String, index: Int, droDownType: String){
        
    }
}
