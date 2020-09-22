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
    static let height = 150
    static let width = 70
    
    public func configure(with hourlyWeather: HourlyWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(hourlyWeather.dateTime))
        timeLabel.text = Utils.getFormattedTime(with: date)
        weatherIcon.image = UIImage(systemName: hourlyWeather.icon)
        temperatureLabel.text = hourlyWeather.temperature
        weatherIcon.tintColor = hourlyWeather.icon.starts(with: "sun") ? .sunColor : .cloudColor
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
}
