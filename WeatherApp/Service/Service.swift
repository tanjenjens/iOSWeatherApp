//
//  Service.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 01/06/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class Service {

    public func responseObject<WeatherResponse: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: WeatherResponse? = nil, completionHandler: (DataResponse<WeatherResponse>) -> ()) {}

    func performGetWeatherListRequest(completionHandler: @escaping ([Weather]?, Error?) -> ()) {
        do {
            let path = try endpointList.asURL()
            Alamofire.request(path, method: .get, parameters: nil)
            .responseObject { (response: DataResponse<WeatherResponse>) in
                switch response.result {
                    case .success(let data):
                        var weatherList: [Weather]?
                        if let list = data.weatherList, list.count > 0 {
                            weatherList = list
                            completionHandler(weatherList, nil)
                        } else {
                            completionHandler(nil, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error)
                }
            }
        } catch {
                print("Error with request: \(error)")
        }
    }
    
    func performGetWeatherByIDRequest(id:Int, completionHandler: @escaping (Weather?, Error?) -> ()) {
        do {
            let path = try endpointByID.asURL()
            Alamofire.request(path, method: .get, parameters: ["id":id])
            .responseObject { (response: DataResponse<Weather>) in
                switch response.result {
                    case .success(let data):
                        if let weather = data.weatherData, weather.count > 0 {
                            completionHandler(data, nil)
                        } else {
                            completionHandler(nil, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error)
                }
            }
        } catch {
                print("Error with request: \(error)")
        }
    }
    
    func performGetWeatherByCoordsRequest(coords:[String:String], completionHandler: @escaping (Weather?, Error?) -> ()) {
        do {
            let path = try endpointByCoords.asURL()
            Alamofire.request(path, method: .get, parameters: coords)
            .responseObject { (response: DataResponse<Weather>) in
                switch response.result {
                    case .success(let data):
                        if let weather = data.weatherData, weather.count > 0 {
                            completionHandler(data, nil)
                        } else {
                            completionHandler(nil, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error)
                }
            }
        } catch {
                print("Error with request: \(error)")
        }
    }

}
