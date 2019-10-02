//
//  WeatherResults.swift
//  WeatherApp
//
//  Created by William Tomas on 01/10/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}


extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
