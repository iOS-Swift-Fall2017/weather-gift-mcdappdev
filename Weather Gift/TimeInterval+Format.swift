//
//  TimeInterval+Format.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 10/31/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

extension TimeInterval {
    func format(timeZone: String, dateFormatter: DateFormatter) -> String {
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        return dateFormatter.string(from: usableDate)
    }
}
