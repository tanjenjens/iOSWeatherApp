//
//  WeatherTableHeaderView.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit

@objc protocol WeatherTableHeaderViewDelegate {
    func refreshMajorCities()
}

class WeatherTableHeaderView: UIView {

    var delegate: WeatherTableHeaderViewDelegate?
    @IBOutlet weak var refreshBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func refreshBtnAction(_ sender: Any) {
        delegate?.refreshMajorCities()
    }
}
