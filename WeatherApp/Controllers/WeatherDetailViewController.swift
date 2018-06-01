//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var weather: Weather!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    var alert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
    
        guard let name = weather.name,
            let weatherData = weather.weatherData, weatherData.count > 0,
            let icon = weatherData[0].icon,
            let main = weatherData[0].main,
            let temp = weather.mainData?.temp,
            let pressure = weather.mainData?.pressure,
            let humidity = weather.mainData?.humidity,
            let tempMin = weather.mainData?.tempMin,
            let tempMax = weather.mainData?.tempMax else {
                return
        }
        cityLabel.text = name
        imgView?.setImageFromURL(url: imageEndpoint + icon + ".png")
        tempLabel.text = String(temp) + "º"
        mainLabel.text = main.lowercased()
        pressureLabel.attributedText = pressureLabel.attributedText?.replacing(placeholder: "<value>", with: String(pressure))
        humidityLabel.attributedText = humidityLabel.attributedText?.replacing(placeholder: "<value>", with: String(humidity))
        minTempLabel.attributedText = minTempLabel.attributedText?.replacing(placeholder: "<value>", with: String(tempMin) + "º")
        maxTempLabel.attributedText = maxTempLabel.attributedText?.replacing(placeholder: "<value>", with: String(tempMax) + "º")
        
        if let speed = weather.windData?.speed {
            speedLabel.attributedText = speedLabel.attributedText?.replacing(placeholder: "<value>", with: String(speed))
        }
        
        if let degree = weather.windData?.degree {
            degreeLabel.attributedText = degreeLabel.attributedText?.replacing(placeholder: "<value>", with: String(degree))
        }
    }
    
    @IBAction func refreshBtnAction(_ sender: Any) {
        if let id = weather.id {
            displayAlert()
            Service().performGetWeatherByIDRequest(id: id) { (response, error) in
                if let response = response {
                    self.weather = response
                    self.loadData()
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    func displayAlert() {
        alert = UIAlertController(title: nil, message: "Refreshing...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
