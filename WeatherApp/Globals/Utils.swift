//
//  Utils.swift
//  WeatherApp
//
//  Created by Lucija Balja on 06/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class Utils {
    
    static func resolveWeatherIcon(_ weatherID: Int) -> String {
        switch weatherID {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }
    
    static func formatDate(with date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    static func formatTime(with date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func resolveWeekDay(with date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    static func formatTemperature(_ temperature: Double) -> String {
        "\(Int(round(temperature)))°"
    }
    
    static func formatHumidity(_ humidity: Int64) -> String {
        "\(humidity) %"
    }
    
    static func formatPressure(_ pressure: Int64) -> String {
        "\(pressure) hPa "
    }
    
    static func formatVisibility(_ visibility: Int64) -> String {
        "\(visibility/1000) km"
    }
    
}
