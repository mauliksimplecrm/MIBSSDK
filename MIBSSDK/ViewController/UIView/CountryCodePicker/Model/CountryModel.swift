//
//  CountryModel.swift
//  Maisarah
//
//  Created by Maulik Vora on 17/07/22.
//

import Foundation
import ObjectMapper

class CountryData: Mappable {
    
    var name: String = ""
    var countryCode: String = ""

    init() {
    }

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        
    }
    
}
