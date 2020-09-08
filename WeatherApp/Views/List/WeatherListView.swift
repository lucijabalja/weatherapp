//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import PureLayout

class WeatherListView: UIView {
    
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = false
        
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
}
