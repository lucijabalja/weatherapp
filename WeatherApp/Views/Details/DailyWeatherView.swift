//
//  DailyWeatherView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class DailyWeatherView: UIView {

    private let dayLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let maxTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        dayLabel.style()
        weatherIcon.styleView()
        maxTemperatureLabel.style(size: 15.0)
        minTemperatureLabel.style(size: 14)
        
        dayLabel.text = "monoday"
        dayLabel.tintColor =  .black
        addSubview(dayLabel)
        addSubview(weatherIcon)
        addSubview(maxTemperatureLabel)
        addSubview(minTemperatureLabel)
    }
    
    private func setupConstraints() {
        let iconDimension: CGFloat = 50.0
        
        dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
//        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
//        dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //dayLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        weatherIcon.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo:self.dayLabel.trailingAnchor, constant: 20).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: iconDimension).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: iconDimension).isActive = true
        
        maxTemperatureLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        maxTemperatureLabel.leadingAnchor.constraint(equalTo:self.weatherIcon.trailingAnchor, constant: 20).isActive = true
       // maxTemperatureLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        minTemperatureLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        minTemperatureLabel.leadingAnchor.constraint(equalTo:self.maxTemperatureLabel.trailingAnchor, constant: 3).isActive = true
        minTemperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }
    
}
