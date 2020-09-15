//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import PureLayout

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet var dailyWeatherViews: [DailyWeatherView]!
    
    private var weatherDetailViewModel: WeatherDetailViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var activityIndicator = SpinnerViewController()

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
        setupRefreshControl()
        setupWeeklyWeatherData()
        setupUI()
        configureCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setupGradientBackground()
    }
    
    private func setupWeeklyWeatherData() {
        weatherDetailViewModel.weeklyWeather.subscribe(
            onNext: { [weak self] (_) in
                guard let self = self else { return }
                
                self.updateCollectionView()
                self.updateDailyStackView()
            }).disposed(by: disposeBag)
    }
    
    private func updateDailyStackView() {
        for (index, dailyViews) in self.dailyWeatherViews.enumerated() {
            guard let dayData = weatherDetailViewModel.weeklyWeather.value.dailyWeatherList[safeIndex: index] else { return }
            
            DispatchQueue.main.async {
                dailyViews.setupView(with: dayData)
            }
        }
    }
}

// MARK:- CollectionView setup

extension WeatherDetailViewController: UICollectionViewDelegate {
    
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
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.hourlyWeatherCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension WeatherDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherDetailViewModel.weeklyWeather.value.hourlyWeatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        
        if let hourlyWeather = weatherDetailViewModel.weeklyWeather.value.hourlyWeatherList[safeIndex: indexPath.row] {
            cell.configure(with: hourlyWeather)
        }
        
        return cell
    }
    
}

// MARK:- Refresh Control setup

extension WeatherDetailViewController {
    
     private func setupRefreshControl() {
          scrollView.refreshControl = refreshControl
          
          refreshControl
              .rx
              .controlEvent(.valueChanged)
              .bind(to: weatherDetailViewModel.refreshData)
              .disposed(by: disposeBag)
      }
    
}

// MARK:- UI Setup

extension WeatherDetailViewController {
    
    private func setupSpinner() {
        addChild(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParent: self)
    }
    
    private func setupUI() {
        cityLabel.text = weatherDetailViewModel.currentWeather.city
        dateLabel.text = weatherDetailViewModel.date
        weatherDescription.text = weatherDetailViewModel.currentWeather.condition.conditionDescription
        hourlyWeatherCollectionView.backgroundColor = .clear
    }
    
}
