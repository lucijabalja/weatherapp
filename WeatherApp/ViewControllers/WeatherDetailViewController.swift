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
    private var spinner = UIActivityIndicatorView(style: .large)
    private var hourlyWeatherDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfHourlyWeather>!
    
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
        setupCollectionView()
        setupRefreshControl()

        createDataSource()
        setupWeeklyWeatherData()
        bindCollectionView()
        bindSpinnerIndicator()
        
        weatherDetailViewModel.refreshData.onNext(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    private func setupWeeklyWeatherData() {
        weatherDetailViewModel.dailyWeather.subscribe(
            onNext: { [weak self] (_) in
                guard let self = self else { return }
                
                self.updateDailyStackView()
        }).disposed(by: disposeBag)
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
                self.refreshControl.endRefreshing()
                return cell
        })
    }
    
    
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
}

// MARK:- CollectionView setup

extension WeatherDetailViewController: UICollectionViewDelegate {
    
    private func setupCollectionView() {
        hourlyWeatherCollectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        hourlyWeatherCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
    
    private func setupUI() {
        cityLabel.text = weatherDetailViewModel.currentWeather.city
        dateLabel.text = weatherDetailViewModel.date
        weatherDescription.text = weatherDetailViewModel.currentWeather.condition.conditionDescription
        hourlyWeatherCollectionView.backgroundColor = .clear
    }
    
    private func configureCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 150)
        layout.scrollDirection = .horizontal
        hourlyWeatherCollectionView.collectionViewLayout = layout
    }
    
    private func setupSpinner() {
        spinner.frame = view.frame
        view.addSubview(spinner)
        spinner.autoAlignAxis(toSuperviewAxis: .horizontal)
        spinner.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
}
