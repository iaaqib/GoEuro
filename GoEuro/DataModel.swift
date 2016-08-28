//
//  DataModel.swift
//  GoEuro
//
//  Created by Aaqib Hussain on 25/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

import UIKit

@objc class DataModel: NSObject {
    static var userDefaults = NSUserDefaults.standardUserDefaults()
    var arrival : String?
    var departureTime : String?
    var id : Int?
    var numberOfStops : Int?
    var prices : String?
    var providerLogo : String?
    
    
    init(data: NSArray , index : Int){
        self.arrival = data[index]["arrival_time"] as? String
        self.departureTime = data[index]["departure_time"] as? String
        self.id = data[index]["id"] as? Int
        self.numberOfStops = data[index]["number_of_stops"] as? Int
        let priceInEuros = data[index]["price_in_euros"] as? Double
        print(priceInEuros)
        if let price = priceInEuros{
            let price = Double(round(100*price)/100)
            self.prices = String(price)
        }
        else{
        let priceInEuros = data[index]["price_in_euros"] as? String
            self.prices = String(round(100*Double(priceInEuros!)!)/100)
        
        }
        let logoUrl = data[index]["provider_logo"] as? String
        self.providerLogo = logoUrl?.stringByReplacingOccurrencesOfString("{size}", withString: "63")
        
        
    }
    
}
