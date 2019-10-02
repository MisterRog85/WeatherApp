//
//  URL+Extension.swift
//  WeatherApp
//
//  Created by William Tomas on 02/10/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=6fb7b7f17601d49bf2417c7d09f5e114&units=metric")
    }
}
