//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 31/05/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CurrentWeatherTableHeaderViewDelegate, WeatherTableHeaderViewDelegate {

    var locationManager:CLLocationManager!
    var currentLocation: CLLocation!
    var didUpdateLocationPermission = false
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
        tableView.isHidden = true
        
        currentLocHeaderView = CurrentWeatherTableHeaderView.loadNib()
        currentLocHeaderView.delegate = self
        headerView = WeatherTableHeaderView.loadNib()
        headerView.delegate = self
    }
    
    func getWeatherForCurrentLocation() {
        let coords = ["lat":String(currentLocation.coordinate.latitude), "lon":String(currentLocation.coordinate.longitude)]
        Service().performGetWeatherByCoordsRequest(coords: coords) { (response, error) in
            if let response = response {
                self.currentLocWeather = response
                self.getWeatherForMajorCities()
            }
        }
    }

    func getWeatherForMajorCities() {
        Service().performGetWeatherListRequest { (response, error) in
            if let response = response {
                self.list = response
                self.tableView.reloadData()
                self.tableView.isHidden = false
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
    
    // MARK: - CurrentWeatherTableHeaderViewDelegate
    func refreshList() {
        displayAlert()
        locationManager.requestLocation()
    }
    
    // MARK: - WeatherTableHeaderViewDelegate
    func refreshMajorCities() {
        getWeatherForMajorCities()
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

extension WeatherTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        getWeatherForCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location \(error.localizedDescription)")
        if let errorCode = (error as NSError).code as Int?, errorCode == 1 {
            if let withAccess = UserDefaults.standard.object(forKey: "location_access_allowed") as? Bool, withAccess == false {
                if currentLocation == nil && !didUpdateLocationPermission {
                    getWeatherForMajorCities()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            UserDefaults.standard.setValue(false, forKey: "location_access_allowed")
            if currentLocation == nil {
                didUpdateLocationPermission = true
                getWeatherForMajorCities()
            }
        } else {
            UserDefaults.standard.setValue(true, forKey: "location_access_allowed")
            if currentLocation == nil {
                locationManager.requestLocation()
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
            headerView.refreshBtn.isHidden = currentLocation == nil ? false : true
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
