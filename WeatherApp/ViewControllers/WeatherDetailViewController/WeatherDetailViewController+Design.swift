//
//  WeatherDetailViewController+Design.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift

// MARK:- UI Setup

extension WeatherDetailViewController {
    
    func setupUI() {
        cityLabel.text = weatherDetailViewModel.currentWeather.city
        currentTempLabel.text = weatherDetailViewModel.currentWeather.parameters.now
        weatherDescription.text = weatherDetailViewModel.currentWeather.condition.conditionDescription
        hourlyWeatherCollectionView.backgroundColor = .clear
        
        weatherDetailViewModel
            .currentWeatherDetails
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { currentDetails in
                self.sunriseLabel.text = Utils.formatTime(with: Date(timeIntervalSince1970: TimeInterval(currentDetails.sunrise)))
                self.sunsetLabel.text = Utils.formatTime(with: Date(timeIntervalSince1970: TimeInterval(currentDetails.sunset)))
                self.humidityLabel.text = Utils.formatHumidity(currentDetails.humidity)
                self.pressureLabel.text = Utils.formatPressure(currentDetails.pressure)
                self.feelsLikeLabel.text = Utils.formatTemperature(currentDetails.feelsLike)
                self.visibilityLabel.text = Utils.formatVisibility(currentDetails.visibility)
            })
            .disposed(by: disposeBag)
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
