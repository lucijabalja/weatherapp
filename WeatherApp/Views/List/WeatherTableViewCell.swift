//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import PureLayout

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
    
    func setup(_ weather: CurrentWeather) {
        let params = weather.parameters
        weatherIcon.image = UIImage(systemName: weather.condition.icon)
        weatherIcon.tintColor = weather.condition.icon.starts(with: "sun") ? .sunColor : .cloudColor
        cityLabel.text = weather.city
        currentTempLabel.text = params.now
        minTempLabel.text = params.min
        maxTempLabel.text = params.max
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let caLayer = CALayer()
        caLayer.cornerRadius = 10
        caLayer.backgroundColor = UIColor.black.cgColor
        caLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 5, dy: 10)
        layer.mask = caLayer
    }
    
    private func setupUI() {
        backgroundColor = .cellBackgroundColor
        contentView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        
        weatherIcon.applyDefaultStyleView()
        cityLabel.style(fontSize: 30, textAlignment: .left)
        currentTempLabel.style(fontSize: 40, textAlignment: .right)
        maxTempLabel.style(fontSize: 15, textAlignment: .right)
        minTempLabel.style(fontSize: 15, textAlignment: .left)
        
        cityLabel.numberOfLines = 0
        minTempLabel.textColor = .mainLabelColor
        temperatureView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        let iconDimension: CGFloat = 50
        let iconOffset: CGFloat = 30
        let edgeMargin: CGFloat = 15
        let tempDistance: CGFloat = 5
        let labelsDistance: CGFloat = 20
        let cityLabelsWidth: CGFloat = 150
        
        contentView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        
        contentView.addSubview(weatherIcon)
        weatherIcon.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: iconOffset)
        weatherIcon.autoPinEdge(.bottom, to: .bottom, of: self.contentView, withOffset: -iconOffset)
        weatherIcon.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: labelsDistance)
        weatherIcon.autoAlignAxis(.horizontal, toSameAxisOf: self.contentView)
        weatherIcon.autoSetDimensions(to: CGSize(width: iconDimension, height: iconDimension))

        contentView.addSubview(cityLabel)
        cityLabel.autoPinEdge(.top, to: .top, of: self.contentView)
        cityLabel.autoPinEdge(.left, to: .right, of: self.weatherIcon, withOffset: labelsDistance)
        cityLabel.autoSetDimension(.width, toSize: cityLabelsWidth)
        cityLabel.autoAlignAxis(.horizontal, toSameAxisOf: self.contentView)

        contentView.addSubview(temperatureView)
        temperatureView.autoPinEdge(.top, to: .top, of: self.contentView)
        temperatureView.autoPinEdge(.bottom, to: .bottom, of: self.contentView)
        temperatureView.autoPinEdge(.left, to: .right, of: self.cityLabel, withOffset: labelsDistance)
        temperatureView.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -edgeMargin)
        
        temperatureView.addSubview(currentTempLabel)
        currentTempLabel.autoPinEdge(.top, to: .top, of: self.temperatureView, withOffset: 10)
        currentTempLabel.autoPinEdge(.left, to: .left, of: self.temperatureView)
        currentTempLabel.autoPinEdge(.right, to: .right, of: self.temperatureView)
        
        temperatureView.addSubview(maxTempLabel)
        maxTempLabel.autoPinEdge(.top, to: .bottom, of: self.currentTempLabel, withOffset: tempDistance)
        maxTempLabel.autoPinEdge(.bottom, to: .bottom, of: self.temperatureView, withOffset: -labelsDistance)

        temperatureView.addSubview(minTempLabel)
        minTempLabel.autoPinEdge(.top, to: .bottom, of: self.currentTempLabel, withOffset: tempDistance)
        minTempLabel.autoPinEdge(.bottom, to: .bottom, of: self.temperatureView, withOffset: -labelsDistance)
        minTempLabel.autoPinEdge(.left, to: .right, of: self.maxTempLabel, withOffset: tempDistance)
        minTempLabel.autoPinEdge(.right, to: .right, of: self.temperatureView, withOffset: -tempDistance)
    }
    
}
