import Foundation
import Alamofire
import SwiftyJSON

class WeatherDetail: WeatherLocation {
    
    struct HourlyForecast {
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
    }
    
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var hourlyForecastArray = [HourlyForecast]()
    var dailyForecastArray = [DailyForecast]()

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
                
                //start looping for daily data
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                let days = min(7, dailyDataArray.count - 1)
                for (index, day) in dailyDataArray.enumerated() {
                    if (index) >= days {
                        break
                    }
                    let dayJson = day.1
                    let maxTemp = dayJson["temperatureHigh"].doubleValue
                    let minTemp = dayJson["temperatureLow"].doubleValue
                    let dateValue = dayJson["time"].doubleValue
                    let icon = dayJson["icon"].stringValue
                    let dailySummary = dayJson["summary"].stringValue
                    
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                    self.dailyForecastArray.append(newDailyForecast)
                }
                
                let hourlyDataArray = json["hourly"]["data"]
                self.hourlyForecastArray = []
                
                let hours = min(24, hourlyDataArray.count - 1)
                
                for (index, hour) in hourlyDataArray.enumerated() {
                    if (index) >= hours {
                        break
                    }
                    
                    let hourJson = hour.1
                    let hourlyTime = hourJson["time"].doubleValue
                    let hourlyTemperature = hourJson["temperature"].doubleValue
                    let hourlyPrecipProb = hourJson["precipProbability"].doubleValue
                    let hourlyIcon = hourJson["icon"].stringValue
                    
                    let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon)
                    self.hourlyForecastArray.append(newHourlyForecast)
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

