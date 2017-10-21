//
//  WeatherLocation.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 10/21/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
    init(name: String, coordinates: String, currentTemp: String = "--") {
        self.name = name
        self.coordinates = coordinates
    }
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    let roundedTemp = String(format: "%", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("could not get temperature")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
