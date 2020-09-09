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

class WeatherListViewController: UIViewController {
    
    private let weatherView = WeatherListView()
    private let errorView = ErrorView()
    private var weatherViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let spinner = SpinnerViewController()
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherViewModel = weatherViewModel
        bindTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRefreshControl()
        setupConstraints()
        setupTableView()
    }
    
    private func setupTableView() {
        weatherView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func bindTableView() {
        weatherViewModel.currentWeatherList.bind(to: weatherView.tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { [weak self] (row, currentWeather, cell) in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            self.endLoading()
            cell.setup(currentWeather)
        }.disposed(by: disposeBag)
        
        weatherView.tableView.rx.modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.pushToDetailView(with: currentWeather)
            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherView)
        
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
        weatherView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        weatherView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        weatherView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weatherView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}

// MARK:- Refresh Control setup

extension WeatherListViewController {
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            weatherView.tableView.refreshControl = refreshControl
        } else {
            weatherView.tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        weatherViewModel.getCurrentWeather()
    }
    
}
