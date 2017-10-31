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

class WeatherLocation {
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
    }
    
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    
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
                    self.currentTemp = "\(Int(temperature))°"
                }
                
                self.currentSummary = json["daily"]["summary"].stringValue
                self.currentIcon = json["currently"]["icon"].stringValue
                self.currentTime = json["currently"]["time"].doubleValue
                self.timeZone = json["timezone"].stringValue
                
                //start looping
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                for day in dailyDataArray {
                    let dayJson = day.1
                    let maxTemp = dayJson["temperatureHigh"].doubleValue
                    let minTemp = dayJson["temperatureLow"].doubleValue
                    let dateValue = dayJson["time"].doubleValue
                    let icon = dayJson["icon"].stringValue
                    let dailySummary = dayJson["summary"].stringValue
                    
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                    self.dailyForecastArray.append(newDailyForecast)
                }
            case .failure(let error):
                print(error)
            }
            
            completed()
        }
    }
}

//https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
