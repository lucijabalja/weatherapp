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
    
    init(with weatherDetailViewModel: WeatherDetailViewModel ) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherDetailViewModel = weatherDetailViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupWeeklyWeatherData()
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
    
    private func setupWeeklyWeatherData() {
        weatherDetailViewModel.getWeeklyWeather(completion: { (result) in
            switch result {
                case .success(_):
                    self.updateCollectionView()
                    self.updateDailyStackView()
                case .failure(let error): print(error)
            }
        })
    }
    
    private func setupUI() {
        view.setupGradientBackground()
        cityLabel.text = weatherDetailViewModel.currentWeather.city
        dateLabel.text = weatherDetailViewModel.date
        timeLabel.text = weatherDetailViewModel.time
        hourlyWeatherCollectionView.backgroundColor = .clear
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.hourlyWeatherCollectionView.reloadData()
        }
    }
    
    private func updateDailyStackView() {
        for (index, dailyViews) in self.dailyWeatherViews.enumerated() {
            guard let dayData = weatherDetailViewModel.weeklyWeather.dailyWeatherList[safeIndex: index] else { return }
                        
            DispatchQueue.main.async {
                dailyViews.setupView(with: dayData)
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
        weatherDetailViewModel.weeklyWeather.hourlyWeatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        
        if let hourlyWeather = weatherDetailViewModel.weeklyWeather.hourlyWeatherList[safeIndex: indexPath.row] {
            cell.configure(with: hourlyWeather)
        }
        
        return cell
    }
    
}
