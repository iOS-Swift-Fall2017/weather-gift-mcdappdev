//
//  DayWeatherTableViewCell.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 10/31/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

class DayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayCellMax: UILabel!
    @IBOutlet weak var dayCellMin: UILabel!
    @IBOutlet weak var dayCellSummary: UITextView!
    @IBOutlet weak var dayCellWeekday: UILabel!
    @IBOutlet weak var dayCellIcon: UIImageView!

    func update(with dailyForecast: WeatherLocation.DailyForecast, timeZone: String) {
        dayCellIcon.image = UIImage(named: dailyForecast.dailyIcon)
        dayCellSummary.text = dailyForecast.dailySummary
        dayCellMax.text = String(format: "%2.f", dailyForecast.dailyMaxTemp) + "°"
        dayCellMin.text = String(format: "%2.f", dailyForecast.dailyMinTemp) + "°"
        dayCellWeekday.text = dailyForecast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
    }
}
