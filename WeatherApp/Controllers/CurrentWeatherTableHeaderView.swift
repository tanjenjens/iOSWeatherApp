//
//  CurrentWeatherTableHeaderView.swift.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit

@objc protocol CurrentWeatherTableHeaderViewDelegate {
    func refreshList()
}

class CurrentWeatherTableHeaderView: UIView {

    var delegate: CurrentWeatherTableHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func refreshBtnAction(_ sender: Any) {
        delegate?.refreshList()
    }

}
