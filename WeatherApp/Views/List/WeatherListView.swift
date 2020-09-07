//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherListView: UIView {
    
    //var searchBar = UISearchBar()
    let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        
//        searchBar.backgroundImage = UIImage()
//        searchBar.barStyle = .black
//        searchBar.barTintColor = .clear
//        searchBar.searchTextField.backgroundColor = .black
//        searchBar.tintColor = .white
//        searchBar.searchTextField.textColor = .white
//        searchBar.searchTextField.tintColor = .white
//        searchBar.placeholder = "Enter city"
//        
        tableView.backgroundColor = .systemBlue
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
     //   addSubview(searchBar)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
//        searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        searchBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true

        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
}
