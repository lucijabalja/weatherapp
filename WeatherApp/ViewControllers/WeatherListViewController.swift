//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import PureLayout

class WeatherListViewController: UIViewController {
    
    private var searchBar = UISearchBar()
    private var weatherViewModel: WeatherListViewModel!
    private var disposeBag = DisposeBag()
    private var loadingDisposeBag = DisposeBag()
    private var refreshDisposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var spinner = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
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
        setupConstraints()
        setupRefreshControl()
        setupTableView()
        
        createDataSource()
        createTimer()
        
        bindSpinnerIndicator()
        bindTableView()
        bindSearchBar()
        weatherViewModel.refreshData.onNext(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    private func createTimer() {
        timerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(600), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.weatherViewModel.refreshData.onNext(())
            })
            .disposed(by: timerDisposeBag)
    }
    
    private func createDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrentWeather>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
                cell.setup(item)
                self.endRefreshing()
                return cell
        })
    }
    
    private func bindTableView() {
        disposeBag = DisposeBag()
        
        weatherViewModel.currentWeatherList
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.modelSelected.onNext(currentWeather)
            }).disposed(by: disposeBag)
        
        tableView
            .rx
            .itemDeleted
            .subscribe { (indexPath) in
                print(indexPath)
        }
    .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] (_)  in
                guard let self = self else { return }
                
                self.search(shouldShow: false)
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .searchButtonClicked
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                
                if let city = self.searchBar.text {
                    self.weatherViewModel.searchText.accept(city)
                }
                self.weatherViewModel.refreshData.onNext(())
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
            })
            .disposed(by: disposeBag)
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
    
    private func bindSpinnerIndicator() {
        weatherViewModel
            .showLoading
            .asObservable()
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: loadingDisposeBag)
    }
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
}

// MARK:- Refresh Control setup

extension WeatherListViewController {
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        
        refreshControl
            .rx
            .controlEvent(.allEvents)
            .bind(to: weatherViewModel.refreshData)
            .disposed(by: refreshDisposeBag)
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
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
}

// MARK:- Setup UI

extension WeatherListViewController {
    
    private func setupUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = false
        
        spinner.frame = view.frame
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        view.addSubview(spinner)
        spinner.autoAlignAxis(toSuperviewAxis: .horizontal)
        spinner.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
}
