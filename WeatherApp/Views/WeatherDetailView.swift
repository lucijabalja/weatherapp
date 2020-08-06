//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherDetailView: UIView {
    let weatherIcon = UIImageView()
    let cityLabel = UILabel()
    let weatherDescription = UILabel()
    let currentTempLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityTitle = UILabel()
    let humidityLabel = UILabel()
    var weatherData: WeatherData! {
        didSet {
            setLabelsText()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    func setLabelsText() {
        weatherIcon.image = UIImage(systemName: weatherData.icon)
        cityLabel.text = weatherData.city
        weatherDescription.text = weatherData.description
        currentTempLabel.text = "\(weatherData.parameters.currentTemperature)°"
        minTempLabel.text = "\(weatherData.parameters.minTemperature)°"
        maxTempLabel.text = "\(weatherData.parameters.maxTemperature)°"
        humidityTitle.text = "HUMIDITY"
        humidityLabel.text = "\(weatherData.parameters.humidity)%"
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        
        UISetup.setImageView(weatherIcon)
        UISetup.setLabel(cityLabel, size: 40)
        UISetup.setLabel(weatherDescription)
        UISetup.setLabel(currentTempLabel, size: 60)
        UISetup.setLabel(minTempLabel, size: 25)
        UISetup.setLabel(maxTempLabel, size: 35)
        UISetup.setLabel(humidityTitle)
        UISetup.setLabel(humidityLabel, size: 25)
        
        cityLabel.numberOfLines = 0
        weatherDescription.numberOfLines = 0
        
        addSubview(weatherIcon)
        addSubview(cityLabel)
        addSubview(weatherDescription)
        addSubview(currentTempLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(humidityTitle)
        addSubview(humidityLabel)
    }
    
    func setupConstraints() {
        weatherIcon.topAnchor.constraint(equalTo:self.topAnchor, constant: 30).isActive = true
        weatherIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        cityLabel.topAnchor.constraint(equalTo:weatherIcon.bottomAnchor, constant:20).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        weatherDescription.topAnchor.constraint(equalTo:cityLabel.bottomAnchor, constant:10).isActive = true
        weatherDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        currentTempLabel.topAnchor.constraint(equalTo:weatherDescription.bottomAnchor, constant:20).isActive = true
        currentTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        maxTempLabel.topAnchor.constraint(equalTo:currentTempLabel.bottomAnchor, constant: 20).isActive = true
        maxTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -45).isActive = true
        maxTempLabel.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        minTempLabel.topAnchor.constraint(equalTo:currentTempLabel.bottomAnchor, constant: 23).isActive = true
        minTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 45).isActive = true
        minTempLabel.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        humidityTitle.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: 20).isActive = true
        humidityTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        humidityTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        humidityLabel.topAnchor.constraint(equalTo: humidityTitle.bottomAnchor, constant: 5).isActive = true
        humidityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        humidityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
