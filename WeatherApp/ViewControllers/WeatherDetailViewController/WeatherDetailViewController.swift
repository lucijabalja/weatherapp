//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import PureLayout

final class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet var dailyWeatherViews: [DailyWeatherView]!
    
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var hourlyWeatherDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfHourlyWeather>!
    
    var weatherDetailViewModel: WeatherDetailViewModel!
    var spinner = UIActivityIndicatorView(style: .large)
    
    init(with weatherDetailViewModel: WeatherDetailViewModel ) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherDetailViewModel = weatherDetailViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSpinner()
        configureCollectionLayout()
        registerHourlyWeatherCell()
        
        createDataSource()
        setupWeeklyWeatherData()
        bindRefreshControl()
        bindCollectionView()
        bindSpinnerIndicator()
        
        weatherDetailViewModel.refreshData.onNext(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupWeeklyWeatherData() {
        weatherDetailViewModel.dailyWeather
            .subscribe(
                onNext: { [weak self] (_) in
                    guard let self = self else { return }
                    
                    self.updateDailyStackView()
                })
            .disposed(by: disposeBag)
    }
    
    private func updateDailyStackView() {
        for (index, dailyViews) in self.dailyWeatherViews.enumerated() {
            guard let dayData = weatherDetailViewModel.dailyWeather.value[safeIndex: index] else { return }
            
            DispatchQueue.main.async {
                dailyViews.setupView(with: dayData)
            }
        }
    }
    
    private func createDataSource() {
        hourlyWeatherDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfHourlyWeather>(
            configureCell: { _, tableView, indexPath, item in
                let cell = self.hourlyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
                cell.configure(with: item)
                return cell
            })
    }
    
}

//MARK:- Bindings

extension WeatherDetailViewController {
    
    private func bindCollectionView() {
        weatherDetailViewModel.hourlyWeather
            .bind(to: hourlyWeatherCollectionView.rx.items(dataSource: hourlyWeatherDataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindSpinnerIndicator() {
        weatherDetailViewModel
            .showLoading
            .asObservable()
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl() {
        scrollView.refreshControl = refreshControl
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: weatherDetailViewModel.refreshData)
            .disposed(by: disposeBag)
    }
    
}
