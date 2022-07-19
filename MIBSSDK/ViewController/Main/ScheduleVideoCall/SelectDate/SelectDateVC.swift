//
//  SelectDateVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 26/01/22.
//

import UIKit
import FSCalendar

protocol didSelectDate_Protocol {
    func didSelectDate(selectDate: String)
}

class SelectDateVC: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var lblSelectDate_title: UILabel!
    @IBOutlet weak var viewSFCalender: FSCalendar!
    
    
    //MARK: Veriable
    var delegate_didSelectDate_Protocol: didSelectDate_Protocol?
    
    
    //MARK: Func
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
    
    }
    func localization(){
        Managelanguage.setUIAccordingLanguage()
        lblSelectDate_title.text = Localize(key: "Select Date")
        
        viewSFCalender.locale = Locale(identifier: Managelanguage.getLanguageCode())
        
    }

    
    //MARK: @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension SelectDateVC: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDate = AppHelper.dateToString(date: date, strFormate: "EEEE, dd/MM/yyyy")
        delegate_didSelectDate_Protocol?.didSelectDate(selectDate: selectDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        Date()
    }
    
}

extension SelectDateVC: didSelectDate_Protocol{
    func didSelectDate(selectDate: String){
        
    }
}
