//
//  CountryCodePickerVC.swift
//  Maisarah
//
//  Created by Maulik Vora on 17/07/22.
//

import UIKit

class CountryCodePickerVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    
    
    var arrListOfDropDown:[Dropdown_Values] = []
    var arrListOfDropDownMain:[Dropdown_Values] = []
    static let shared = CountryCodePickerVC()
    var didSelectCountry: ((_ countryName:String, _ countryCode:String, _ selectIndex:Int) -> (Void))? = nil
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tblList.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        tblList.reloadData()
    }
    func registerCell(){
        tblList.register(UINib(nibName: "CountryCodePickerTblCell", bundle: nil), forCellReuseIdentifier: "CountryCodePickerTblCell")
    }

    class func presentCountroller(on viewController: UIViewController, list: [Dropdown_Values]){
        
        let vc = CountryCodePickerVC.shared
        vc.arrListOfDropDown = list
        vc.arrListOfDropDownMain = list
        let navigationController = UINavigationController(rootViewController: vc)
        viewController.present(navigationController, animated: true, completion: nil)
        //on.present(CountryCodePickerVC.shared, animated: true, completion: nil)
    }

    
    //MARK: - @IBAction
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}


extension CountryCodePickerVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfDropDown.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodePickerTblCell", for: indexPath) as! CountryCodePickerTblCell
        cell.selectionStyle = .none
        
        let dicData = arrListOfDropDown[indexPath.row]
        
        cell.lblTitle.text = dicData.label
        cell.lblDetail.text = "\(dicData.key as? String ?? "")"
        cell.imgFlag.image = UIImage(named: "\(dicData.key as? String ?? "")")
        
        /*
        //--
        if indexPath.row == selectIndex{
            cell.imgSelectIcon.isHidden = false
        }else{
            cell.imgSelectIcon.isHidden = true
        }*/
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = arrListOfDropDown[indexPath.row]
        
        if self.didSelectCountry != nil {
            self.searchBar.text = ""
            self.didSelectCountry!("\(dicData.label)","\(dicData.key as? String ?? "")",indexPath.row)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CountryCodePickerVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        arrListOfDropDown = searchText.isEmpty ? arrListOfDropDownMain : arrListOfDropDownMain.filter { $0.label.contains(searchText) }
        
        //return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        tblList.reloadData()
    }
}
