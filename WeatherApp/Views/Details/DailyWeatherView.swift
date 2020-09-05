//
//  DailyWeatherView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class DailyWeatherView: UIView {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if let view = UINib(nibName: "DailyWeatherView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            setupUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupUI() {
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
    }
    
    func setupView(with dayData: DailyWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(dayData.dateTime))
        dayLabel.text = Utils.getWeekDay(with: date)
        maxTempLabel.text = dayData.temperature.max
        minTempLabel.text = dayData.temperature.min
        weatherIcon.image = UIImage(systemName: dayData.icon)
        weatherIcon.tintColor = dayData.icon.starts(with: "sun") ? .sunColor : .cloudColor
    }
    
}
