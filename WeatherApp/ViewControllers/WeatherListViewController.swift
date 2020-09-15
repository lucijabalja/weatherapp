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
import PureLayout

class WeatherListViewController: UIViewController {
    
    private let weatherListView = WeatherListView()
    private let errorView = ErrorView()
    private var weatherViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var spinner = SpinnerViewController()

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
        bindSpinnerIndicator()
        bindTableView()
        setupRefreshControl()
        setupConstraints()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    private func setupTableView() {
        weatherListView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        weatherListView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func bindTableView() {
        weatherViewModel
            .currentWeatherList
            .bind(to: weatherListView.tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { [weak self] (row, currentWeather, cell) in
                guard let self = self else { return }
                
                self.refreshControl.endRefreshing()
                cell.setup(currentWeather)
        }
        .disposed(by: disposeBag)
        
        weatherListView.tableView.rx.modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.modelSelected.onNext(currentWeather)
            }).disposed(by: disposeBag)
    }
    
    private func bindSpinnerIndicator() {
        weatherViewModel
            .showLoading
            .asObservable()
            .bind(to: spinner.spinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}

// MARK:- Refresh Control setup

extension WeatherListViewController {
    
    private func setupRefreshControl() {
        weatherListView.tableView.refreshControl = refreshControl
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: weatherViewModel.refreshData)
            .disposed(by: disposeBag)
    }
    
}

// MARK:- TableViewDelegate setup

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK:- Setup UI

extension WeatherListViewController {
    
    private func setupUI() {
        weatherListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherListView)
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }

    private func setupConstraints() {
        view.addSubview(weatherListView)
        weatherListView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
}
