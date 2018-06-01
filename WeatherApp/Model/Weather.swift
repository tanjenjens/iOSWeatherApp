//
//  Weather.swift
//  WeatherApp
//
//  Created by Jeniean Las Pobres on 01/06/2018.
//  Copyright © 2018 Jeniean Las Pobres. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: Mappable {
    var weatherList: [Weather]?
    required init?(map: Map){}
    func mapping(map: Map) {
        weatherList <- map["list"]
    }
}

class Weather: Mappable {

    var name: String?
    var id: Int?
    var weatherData: [WeatherData]?
    var mainData: MainData?
    var windData: WindData?

    required init?(map: Map){}
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        weatherData <- map["weather"]
        mainData <- map["main"]
        windData <- map["wind"]
    }
}

class WeatherData: Mappable {

    var main: String?
    var description: String?
    var icon: String?

    required init?(map: Map){}
    
    func mapping(map: Map) {
        main <- map["main"]
        description <- map["description"]
        icon <- map["icon"]
    }
}

class MainData: Mappable {

    var name: String?
    var temp: Double?
    var pressure: Int?
    var humidity: Int?
    var tempMin: Double?
    var tempMax: Double?

    required init?(map: Map){}
    
    func mapping(map: Map) {
        name <- map["name"]
        temp <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
        tempMin <- map["temp_min"]
        tempMax <- map["temp_max"]
    }
}

class WindData: Mappable {

    var speed: Double?
    var degree: Double?

    required init?(map: Map){}
    
    func mapping(map: Map) {
        speed <- map["speed"]
        degree <- map["deg"]
    }
}
