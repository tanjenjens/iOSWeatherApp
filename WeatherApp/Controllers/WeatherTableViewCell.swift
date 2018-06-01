//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(data:Weather) {
        
        guard let name = data.name,
            let weatherData = data.weatherData, weatherData.count > 0,
            let icon = weatherData[0].icon,
            let temp = data.mainData?.temp else {
                return
        }
        cityLabel.text = name
        descriptionLabel.text = weatherData[0].description
        imgView?.setImageFromURL(url: imageEndpoint + icon + ".png")
        tempLabel.text = String(temp) + "º"
        
    }
    
}
