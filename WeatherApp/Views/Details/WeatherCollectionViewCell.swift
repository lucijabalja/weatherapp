//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Lucija Balja on 12/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    static let identifier = "WeatherCollectionViewCell"
    
    public func configure(with hourlyWeather: HourlyForecast) {
        let date = Date(timeIntervalSince1970: TimeInterval(hourlyWeather.dateTime))
        let icon = Utils.resolveWeatherIcon((hourlyWeather.weatherDescription[0].conditionID))
        
        timeLabel.text = Utils.getFormattedTime(with: date)
        weatherIcon.image = UIImage(systemName: icon)
        temperatureLabel.text = "\(hourlyWeather.weatherParameteres.currentTemperature)°"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
