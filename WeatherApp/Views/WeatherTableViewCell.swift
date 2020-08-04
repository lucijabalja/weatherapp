//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    let weatherIcon = UIImageView()
    let cityLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    
    var weather: WeatherData? {
        didSet {
            guard let weatherData = weather else { return }
            weatherIcon.image = UIImage(systemName: weatherData.weatherIcon)
            cityLabel.text = weatherData.city
            minTempLabel.text = String(weatherData.weather.minTemperature) + "°"
            maxTempLabel.text = String(weatherData.weather.maxTemperature) + "°"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        contentView.backgroundColor = .systemBlue
        selectionStyle = .none
        
        weatherIcon.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        weatherIcon.layer.cornerRadius = 35
        weatherIcon.clipsToBounds = true
        weatherIcon.tintColor = .white
        
        cityLabel.font = UIFont.boldSystemFont(ofSize: 30)
        cityLabel.textColor = .white
        cityLabel.numberOfLines = 0
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        minTempLabel.font = UIFont.boldSystemFont(ofSize: 20)
        minTempLabel.textColor =  .systemGray4
        minTempLabel.clipsToBounds = true
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        maxTempLabel.font = UIFont.boldSystemFont(ofSize: 25)
        maxTempLabel.textColor =  .white
        maxTempLabel.clipsToBounds = true
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(weatherIcon)
        self.contentView.addSubview(cityLabel)
        self.contentView.addSubview(minTempLabel)
        self.contentView.addSubview(maxTempLabel)
    }
    
    func setupConstraints() {
        weatherIcon.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant:50).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant:50).isActive = true
    
        cityLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo:self.weatherIcon.trailingAnchor, constant:20).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant:60).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        minTempLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor, constant: 2).isActive = true
        minTempLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -10).isActive = true
        
        maxTempLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        maxTempLabel.trailingAnchor.constraint(equalTo:self.minTempLabel.leadingAnchor, constant: -8).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
