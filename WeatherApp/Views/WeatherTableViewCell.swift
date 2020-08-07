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
    private let weatherIcon = UIImageView()
    private let cityLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    var weather: CityWeather? {
        didSet {
            setLabelsText()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    private func setLabelsText() {
        guard let weatherData = weather else { return }
        
        weatherIcon.image = UIImage(systemName: weatherData.icon)
        cityLabel.text = weatherData.city
        currentTempLabel.text = "\(weatherData.parameters.currentTemperature)°"
        minTempLabel.text = "\(weatherData.parameters.minTemperature)°"
        maxTempLabel.text = "\(weatherData.parameters.maxTemperature)°/"
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBlue
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        
        weatherIcon.styleView()
        cityLabel.style(size: 30, textAlignment: .left)
        currentTempLabel.style(size: 40, textAlignment: .right)
        maxTempLabel.style(size: 15, textAlignment: .right)
        minTempLabel.style(size: 15, textAlignment: .left)
        
        cityLabel.numberOfLines = 0
        minTempLabel.textColor =  .systemGray4
        
        contentView.addSubview(containerView)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(cityLabel)
        containerView.addSubview(currentTempLabel)
        containerView.addSubview(minTempLabel)
        containerView.addSubview(maxTempLabel)
    }
    
    private func setupConstraints() {
        weatherIcon.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 15).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cityLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo:self.weatherIcon.trailingAnchor, constant: 20).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: -10).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor, constant: -10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -15).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        currentTempLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30).isActive = true
        currentTempLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        currentTempLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        maxTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: 5).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -5).isActive = true
        maxTempLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        minTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: 5).isActive = true
        minTempLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -5).isActive = true
        minTempLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        minTempLabel.leadingAnchor.constraint(equalTo: self.maxTempLabel.trailingAnchor, constant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
