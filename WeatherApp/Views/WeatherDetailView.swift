//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherDetailView: UIView {
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let cityLabel = UILabel()
    private let weatherDescription = UILabel()
    private let currentTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    private let humidityTitle = UILabel()
    private let humidityLabel = UILabel()
    
    //should not be here
    var weatherData: CityWeather? {
        didSet {
            setLabelsText()
            setDateTime()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabelsText() {
        guard let weatherData = weatherData else { return }
        
        weatherIcon.image = UIImage(systemName: weatherData.icon)
        cityLabel.text = weatherData.city
        weatherDescription.text = weatherData.description
        currentTempLabel.text = "\(weatherData.parameters.currentTemperature)°C"
        minTempLabel.text = "\(weatherData.parameters.minTemperature)° min "
        maxTempLabel.text = "max \(weatherData.parameters.maxTemperature)°"
        humidityTitle.text = "HUMIDITY"
        humidityLabel.text = "\(weatherData.parameters.humidity)%"
    }
    
    private func setDateTime() {
        let formatter = DateFormatter()
        let currentDate = Date()
        formatter.dateStyle = .full
        dateLabel.text = formatter.string(from: currentDate)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: currentDate)
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
             
        dateLabel.style()
        timeLabel.style(size: 30)
        weatherIcon.styleView()
        cityLabel.style(size: 40)
        weatherDescription.style()
        currentTempLabel.style(size: 60)
        maxTempLabel.style(size: 30)
        minTempLabel.style(size: 28)
        humidityTitle.style()
        humidityLabel.style(size: 25)
        
        cityLabel.numberOfLines = 0
        weatherDescription.numberOfLines = 0
        minTempLabel.textColor = .systemGray4
        
        addSubview(dateLabel)
        addSubview(timeLabel)
        addSubview(weatherIcon)
        addSubview(cityLabel)
        addSubview(weatherDescription)
        addSubview(currentTempLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(humidityTitle)
        addSubview(humidityLabel)
    }
    
    private func setupConstraints() {
        let topMargin: CGFloat = 10
        let labelMargin: CGFloat = 20
        let labelsHeight: CGFloat = 50
        let centerDistance: CGFloat = 80
        let iconDimension: CGFloat = 150
        
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: topMargin).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: topMargin).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        cityLabel.topAnchor.constraint(equalTo:timeLabel.bottomAnchor, constant: labelMargin).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        weatherIcon.topAnchor.constraint(equalTo:cityLabel.bottomAnchor, constant: labelMargin).isActive = true
        weatherIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: iconDimension).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: iconDimension).isActive = true
        
        weatherDescription.topAnchor.constraint(equalTo:weatherIcon.bottomAnchor, constant: topMargin).isActive = true
        weatherDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        currentTempLabel.topAnchor.constraint(equalTo:weatherDescription.bottomAnchor, constant: labelMargin).isActive = true
        currentTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        maxTempLabel.topAnchor.constraint(equalTo:currentTempLabel.bottomAnchor, constant: labelMargin).isActive = true
        maxTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -centerDistance).isActive = true
        maxTempLabel.heightAnchor.constraint(equalToConstant: labelsHeight).isActive = true
        
        minTempLabel.topAnchor.constraint(equalTo:currentTempLabel.bottomAnchor, constant: labelMargin).isActive = true
        minTempLabel.heightAnchor.constraint(equalToConstant: labelsHeight).isActive = true
        minTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: centerDistance).isActive = true
        
        humidityTitle.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: labelMargin).isActive = true
        humidityTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        humidityLabel.topAnchor.constraint(equalTo: humidityTitle.bottomAnchor, constant: topMargin).isActive = true
        humidityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
