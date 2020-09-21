//
//  WeatherDetailViewController+Design.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

// MARK:- UI Setup

extension WeatherDetailViewController {
    
    func setupUI() {
        cityLabel.text = weatherDetailViewModel.currentWeather.city
        dateLabel.text = weatherDetailViewModel.date
        weatherDescription.text = weatherDetailViewModel.currentWeather.condition.conditionDescription
        hourlyWeatherCollectionView.backgroundColor = .clear
    }
    
    func configureCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: WeatherCollectionViewCell.width, height: WeatherCollectionViewCell.height)
        layout.scrollDirection = .horizontal
        hourlyWeatherCollectionView.collectionViewLayout = layout
    }
    
    func setupSpinner() {
        spinner.frame = view.frame
        view.addSubview(spinner)
        spinner.autoAlignAxis(toSuperviewAxis: .horizontal)
        spinner.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    func registerHourlyWeatherCell() {
        hourlyWeatherCollectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    }
    
}
