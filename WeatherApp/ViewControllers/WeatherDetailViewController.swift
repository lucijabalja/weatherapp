//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet var dailyWeatherViews: [DailyWeatherView]!
    
    private var weatherDetailViewModel: WeatherDetailViewModel!
    weak var coordinator: Coordinator?
    
    init(with cityWeather: CityWeather, coordinator: Coordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        
        weatherDetailViewModel = coordinator.createWeatherDetailViewModel(with: cityWeather)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDailyWeatherData()
        setupHourlyWeatherData()
        setupUI()
        configureCollectionLayout()
    }
    
    private func setupCollectionView() {
        hourlyWeatherCollectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        hourlyWeatherCollectionView.delegate = self
        hourlyWeatherCollectionView.dataSource = self
    }
    
    private func configureCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 150)
        layout.scrollDirection = .horizontal
        hourlyWeatherCollectionView.collectionViewLayout = layout
    }
    
    private func setupHourlyWeatherData() {
        weatherDetailViewModel.getHourlyWeather(completion: { (apiResponseMessage) in
            switch apiResponseMessage {
                    case .SUCCESSFUL: self.updateCollectionView()
                    case .FAILED: print("Error happened!")
            }
        })
    }
    
    private func setupDailyWeatherData() {
        weatherDetailViewModel.getDailyWeather { (apiResponseMessage) in
            switch apiResponseMessage {
                case .SUCCESSFUL: self.updateHourlyStackView()
                case .FAILED: print("Error happened!")
            }
        }
    }
    
    private func setupUI() {
        cityLabel.text = weatherDetailViewModel.cityWeather.city
        dateLabel.text = weatherDetailViewModel.date
        timeLabel.text = weatherDetailViewModel.time
        hourlyWeatherCollectionView.backgroundColor = .systemBlue
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.hourlyWeatherCollectionView.reloadData()
        }
    }
    
    private func updateHourlyStackView() {
        for (index, dailyViews) in self.dailyWeatherViews.enumerated() {
            guard weatherDetailViewModel.checkDailyForecastCount(with: index) else { return }
            
            let dayData = self.weatherDetailViewModel.dailyWeather[index]
            let date = Date(timeIntervalSince1970: TimeInterval(dayData.dateTime))
            let icon = Utils.resolveWeatherIcon(dayData.weatherDescription[0].conditionID)
            
            DispatchQueue.main.async {
                dailyViews.dayLabel.text = Utils.getWeekDay(with: date)
                dailyViews.maxTempLabel.text = "\(dayData.temperature.max)°"
                dailyViews.minTempLabel.text = "\(dayData.temperature.min)°"
                dailyViews.weatherIcon.image = UIImage(systemName: icon)
            }
        }
    }
    
}

extension WeatherDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension WeatherDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherDetailViewModel.hourlyWeather?.hourlyForecast.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        
        if let hourlyWeather = weatherDetailViewModel.hourlyWeather?.hourlyForecast[indexPath.row] {
            cell.configure(with: hourlyWeather)
        }
        
        return cell
    }
    
}

extension WeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 150)
    }
    
}
