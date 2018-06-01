//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate, CurrentWeatherTableHeaderViewDelegate {

    var locationManager:CLLocationManager!
    var currentLocHeaderView: CurrentWeatherTableHeaderView!
    var headerView: WeatherTableHeaderView!
    var currentLocWeather: Weather?
    var list = [Weather]()
    var selectedIndexPath = IndexPath()
    var alert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.isScrollEnabled = (tableView.contentSize.height <= tableView.frame.height)
        currentLocHeaderView = CurrentWeatherTableHeaderView.loadNib()
        currentLocHeaderView.delegate = self
        headerView = WeatherTableHeaderView.loadNib()
    }

    func getWeatherForMajorCities() {
        Service().performGetWeatherListRequest { (response, error) in
            if let response = response {
                self.list = response
                self.tableView.reloadData()
                self.dismiss(animated: false, completion: nil)
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
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        let coords = ["lat":String(userLocation.coordinate.latitude), "lon":String(userLocation.coordinate.longitude)]
        Service().performGetWeatherByCoordsRequest(coords: coords) { (response, error) in
            if let response = response {
                self.currentLocWeather = response
                self.getWeatherForMajorCities()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
    
    // MARK: - CurrentWeatherTableHeaderViewDelegate
    func refreshList() {
        displayAlert()
        locationManager.requestLocation()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeatherDetailViewControllerSegue" {
            if let vc = segue.destination as? WeatherDetailViewController {
                if selectedIndexPath.section == 0 && currentLocWeather != nil {
                    vc.weather = currentLocWeather
                } else {
                    vc.weather = list[selectedIndexPath.row]
                }
                
            }
        }
    }

}

extension WeatherTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentLocWeather != nil ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && currentLocWeather != nil {
            return 1
        } else {
            return list.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        if indexPath.section == 0 && currentLocWeather != nil {
            cell.configure(data: currentLocWeather!)
        } else {
            cell.configure(data: list[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && currentLocWeather != nil {
            return currentLocHeaderView
        } else {
            return headerView
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "WeatherDetailViewControllerSegue", sender: indexPath)
    }
}
