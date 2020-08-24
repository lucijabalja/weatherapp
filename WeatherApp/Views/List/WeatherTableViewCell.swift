//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let temperatureView = UIView()
    private let weatherIcon = UIImageView()
    private let cityLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()

    static let identifier = "weatherCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(_ weather: CityWeather) {
        weatherIcon.image = UIImage(systemName: weather.icon)
        cityLabel.text = weather.city
        currentTempLabel.text = "\(weather.parameters.currentTemperature)°"
        minTempLabel.text = "\(weather.parameters.minTemperature)°"
        maxTempLabel.text = "\(weather.parameters.maxTemperature)° /"
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBlue
        contentView.clipsToBounds = true
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
          
        containerView.layer.cornerRadius = 6.0
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherIcon.styleView()
        cityLabel.style(size: 30, textAlignment: .left)
        currentTempLabel.style(size: 40, textAlignment: .right)
        maxTempLabel.style(size: 15, textAlignment: .right)
        minTempLabel.style(size: 15, textAlignment: .left)
        
        cityLabel.numberOfLines = 0
        minTempLabel.textColor =  .systemGray4
        temperatureView.translatesAutoresizingMaskIntoConstraints = false
        temperatureView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        contentView.addSubview(temperatureView)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(cityLabel)
        temperatureView.addSubview(currentTempLabel)
        temperatureView.addSubview(minTempLabel)
        temperatureView.addSubview(maxTempLabel)
    }
    
    private func setupConstraints() {
        let iconDimension: CGFloat = 50
        let edgeMargin: CGFloat = 15
        let tempDistance: CGFloat = 5
        let labelsDistance: CGFloat = 20
        let cityLabelsWidth: CGFloat = 150

        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        
        weatherIcon.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: edgeMargin).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: iconDimension).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: iconDimension).isActive = true
        
        cityLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo:self.weatherIcon.trailingAnchor, constant: labelsDistance).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: cityLabelsWidth).isActive = true
        
        temperatureView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        temperatureView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        temperatureView.leadingAnchor.constraint(equalTo: self.cityLabel.trailingAnchor, constant: labelsDistance).isActive = true
        temperatureView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -edgeMargin).isActive = true

        currentTempLabel.topAnchor.constraint(equalTo: self.temperatureView.topAnchor, constant: labelsDistance).isActive = true
        currentTempLabel.leadingAnchor.constraint(equalTo:self.temperatureView.leadingAnchor).isActive = true
        currentTempLabel.trailingAnchor.constraint(equalTo:self.temperatureView.trailingAnchor).isActive = true
        
        maxTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: tempDistance).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo:self.temperatureView.bottomAnchor, constant: -tempDistance).isActive = true
        
        minTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: tempDistance).isActive = true
        minTempLabel.bottomAnchor.constraint(equalTo:self.temperatureView.bottomAnchor, constant: -tempDistance).isActive = true
        minTempLabel.trailingAnchor.constraint(equalTo:self.temperatureView.trailingAnchor).isActive = true
        minTempLabel.leadingAnchor.constraint(equalTo: self.maxTempLabel.trailingAnchor, constant: tempDistance).isActive = true
    }
    
}
