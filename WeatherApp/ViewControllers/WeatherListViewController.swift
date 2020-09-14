//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PureLayout

class WeatherListViewController: UIViewController {
    
    private let weatherListView = WeatherListView()
    private var weatherViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let spinner = SpinnerViewController()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfCurrentWeather>!
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSpinner()
        createTimer()
        setupRefreshControl()
        setupConstraints()
        setupTableView()
        createDataSource()
        bindTableView()
        bindErrorStream()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    private func createTimer() {
        timerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(600), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.weatherViewModel.getCurrentWeather()
            })
            .disposed(by: timerDisposeBag)
    }
    
    private func createDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrentWeather>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
                cell.setup(item)
                self.endLoading()
                self.refreshControl.endRefreshing()
                return cell
        })
    }
    
    private func bindTableView() {
        weatherViewModel.currentWeatherList
            .bind(to: weatherListView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        weatherListView.tableView.rx
            .modelSelected(CurrentWeather.self)
            .subscribe(onNext: { [weak self] (currentWeather) in
                guard let self = self else { return }
                self.weatherViewModel.pushToDetailView(with: currentWeather)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindErrorStream() {
        weatherViewModel.errorStream.subscribe(onNext: { (persistanceError) in
            print(persistanceError)
            DispatchQueue.main.async {
                self.endLoading()
                self.setAlertMessage(with: persistanceError)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK:- Table View setup

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    private func setupTableView() {
        weatherListView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        weatherListView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK:- Refresh Control setup

extension WeatherListViewController {
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            weatherListView.tableView.refreshControl = refreshControl
        } else {
            weatherListView.tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        weatherViewModel.getCurrentWeather()
    }
    
}

// MARK:- Setup UI

extension WeatherListViewController {
    
    private func setAlertMessage(with error: PersistanceError) {
        let alert = UIAlertController(title: ErrorMessage.noInternetConnection,
                                      message: ErrorMessage.turnInternetConnection, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        weatherListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherListView)
    }
    
    private func setupSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func endLoading() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    private func setupConstraints() {
        view.addSubview(weatherListView)
        weatherListView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
}
