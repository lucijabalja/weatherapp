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
    let humidityLabel = UILabel()
    let pressureLabel = UILabel()
    
    var weatherData: WeatherData! {
        didSet {
            weatherIcon.image = UIImage(systemName: weatherData.icon)
            cityLabel.text = weatherData.city
            weatherDescription.text = weatherData.description
            currentTempLabel.text = "\(weatherData.parameters.currentTemperature)°"
            minTempLabel.text = "\(weatherData.parameters.minTemperature)°"
            maxTempLabel.text = "\(weatherData.parameters.maxTemperature)°"
            humidityLabel.text = "\(weatherData.parameters.humidity)"
            pressureLabel.text = "\(weatherData.parameters.pressure)"
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        
        weatherIcon.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        weatherIcon.layer.cornerRadius = 35
        weatherIcon.clipsToBounds = true
        weatherIcon.tintColor = .white
        
        cityLabel.font = UIFont.boldSystemFont(ofSize: 40)
        cityLabel.textColor = .white
        cityLabel.numberOfLines = 0
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .center
        
        weatherDescription.font = UIFont.boldSystemFont(ofSize: 20)
        weatherDescription.textColor = .white
        weatherDescription.numberOfLines = 0
        weatherDescription.adjustsFontSizeToFitWidth = true
        weatherDescription.translatesAutoresizingMaskIntoConstraints = false
        weatherDescription.textAlignment = .center
        
        currentTempLabel.font = UIFont.boldSystemFont(ofSize: 60)
        currentTempLabel.textColor =  .white
        currentTempLabel.clipsToBounds = true
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        minTempLabel.font = UIFont.boldSystemFont(ofSize: 25)
        minTempLabel.textColor =  .white
        minTempLabel.clipsToBounds = true
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        maxTempLabel.font = UIFont.boldSystemFont(ofSize: 35)
        maxTempLabel.textColor =  .white
        maxTempLabel.clipsToBounds = true
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
       addSubview(weatherIcon)
       addSubview(cityLabel)
       addSubview(weatherDescription)
       addSubview(currentTempLabel)
       addSubview(minTempLabel)
       addSubview(maxTempLabel)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
