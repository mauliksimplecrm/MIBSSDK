//
//  SelectTimeVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 26/01/22.
//

import UIKit

protocol didSelectTimeSlot_Protocol {
    func didSelectTimeSlot(timeSlot: String, index: Int)
}

class SelectTimeVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblSelectTimeSlot: UILabel!
    
    //MARK: Veriable
    var delegate_didSelectTimeSlot_Protocol: didSelectTimeSlot_Protocol?
    let arrTimeList = ManageDropDownOption.getDropDownValue(dropdown_filed: .contact_time_preference_c)
    var selectTimeSlotIndex = -1
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        localization()
        
    }
    func registerCell(){
        tblList.register(UINib(nibName: "TimeSlotTblCell", bundle: nil), forCellReuseIdentifier: "TimeSlotTblCell")
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblSelectTimeSlot.text = Localize(key: "Select Time slot")
        
    }
    
    
    //MARK: @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   

}

extension SelectTimeVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTblCell", for: indexPath) as! TimeSlotTblCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = ""
        cell.lblTimeSlot.text = arrTimeList[indexPath.row]
        
        

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timeSlot = arrTimeList[indexPath.row]
        
        //--
        delegate_didSelectTimeSlot_Protocol?.didSelectTimeSlot(timeSlot: timeSlot, index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
}

extension SelectTimeVC: didSelectTimeSlot_Protocol{
    func didSelectTimeSlot(timeSlot: String, index: Int){
        
    }
}
