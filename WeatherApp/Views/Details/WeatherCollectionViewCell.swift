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
    
    public func configure(with hourlyWeather: HourlyWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(hourlyWeather.dateTime))
        timeLabel.text = Utils.getFormattedTime(with: date)
        weatherIcon.image = UIImage(systemName: hourlyWeather.icon)
        temperatureLabel.text = hourlyWeather.temperature
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
}
