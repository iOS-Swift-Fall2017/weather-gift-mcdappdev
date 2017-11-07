//
//  HourlyWeatherCollectionViewCell.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 11/7/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ha"
    return dateFormatter
}()

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var hourlyPrecipProb: UILabel!
    @IBOutlet private weak var raindropImage: UIImageView!
    @IBOutlet private weak var hourlyIcon: UIImageView!
    @IBOutlet private weak var hourlyTime: UILabel!
    @IBOutlet private weak var hourlyTemp: UILabel!
    
    func update(with hourlyForecast: WeatherDetail.HourlyForecast, timeZone: String) {
        hourlyTemp.text = String(format: "%2.f", hourlyForecast.hourlyTemperature) + "°"
        hourlyIcon.image = UIImage(named: "small-" + hourlyForecast.hourlyIcon)
        let precipProb = hourlyForecast.hourlyPrecipProb * 100
        let isHidden = precipProb < 30
        hourlyPrecipProb.isHidden = isHidden
        raindropImage.isHidden = isHidden
        hourlyPrecipProb.text = String(format: "%2.f", precipProb) + "%"
        let dateString = hourlyForecast.hourlyTime.format(timeZone: timeZone, dateFormatter: dateFormatter)
        hourlyTime.text = dateString
    }
}
