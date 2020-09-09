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
    private var searchBar = UISearchBar()
    private var weatherListViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let spinner = SpinnerViewController()
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherListViewModel = weatherViewModel
        bindTableView()
        bindSearchBar()
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    private func setupTableView() {
        weatherView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func bindTableView() {
        weatherListViewModel.currentWeatherList.bind(to: weatherView.tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { [weak self] (row, currentWeather, cell) in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            self.endLoading()
            cell.setup(currentWeather)
        }.disposed(by: disposeBag)
        
        weatherView.tableView.rx.modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherListViewModel.pushToDetailView(with: currentWeather)
            }).disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] (_)  in
            guard let self = self else { return }
            
            self.search(shouldShow: false)
            self.searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            
            if let city = self.searchBar.text {
                print(city)
                self.weatherListViewModel.getCurrentWeather(for: city)
            }
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
        }).disposed(by: disposeBag)
    }
    
}

// MARK:- UI Setup

extension WeatherListViewController {
    
    @objc func showSearchBar() {
        search(shouldShow: true)
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func search(shouldShow: Bool) {
        searchBar.isHidden = !shouldShow
        searchBar.showsCancelButton = shouldShow
        navigationItem.rightBarButtonItem = shouldShow ? nil : UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    private func setupUI() {
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
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
        weatherListViewModel.getCurrentWeather()
    }
    
}
