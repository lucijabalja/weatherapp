//
//  WeatherListViewController+Design.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension WeatherListViewController {
    
    // MARK:- Table view setup
    func setupTableView() {
        tableView.rowHeight = WeatherTableViewCell.height
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    func showSearchBar() {
        search(shouldShow: true)
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    //MARK:- Search bar setup
    
    func search(shouldShow: Bool) {
        searchBar.isHidden = !shouldShow
        searchBar.showsCancelButton = shouldShow
        navigationItem.leftBarButtonItem = shouldShow ? nil : searchBarButton
        navigationItem.rightBarButtonItem = shouldShow ? nil : editBarButton
    }
    
    //MARK:- UI Setup
    
    func setupUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = false
        
        spinner.frame = view.frame
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        view.addSubview(spinner)
        spinner.autoAlignAxis(toSuperviewAxis: .horizontal)
        spinner.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
