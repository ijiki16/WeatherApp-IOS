//
//  Weather.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/7/21.
//

import Foundation

// API data models

struct TodayData : Codable {
    let id : Int
    let name : String
    let weather : [Weather]
    let wind : Wind
    let main : Temp
    let coord : Coordinates
    let clouds : Clouds
    let sys : Sys
}

struct Coordinates : Codable {
    let lon : Double
    let lat : Double
}

struct Wind : Codable{
    let speed: Double
    let deg: Double
}

struct Sys : Codable{
    let type : Int
    let id : Int
    let country : String
}

struct Clouds : Codable {
    let all : Double
}
// ForecastData

struct ForecastData : Codable{ 
    let cod: String
    let message: Int
    let cnt: Int
    let list: [rowData]
    
}

struct rowData : Codable {
    let dt : Double
    let main : Temp
    let weather : [Weather]
    let dt_txt : String
}

extension rowData {
    
    func getDayIndex() -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from: self.dt_txt)!
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekday, from: time) - 1
    }
    
    func getTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from: self.dt_txt)!
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
}

struct Temp : Codable{
    let temp: Double
    let humidity: Double
}
struct Weather : Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// new Data models for forcast

struct dayForecast{
    var dayName: String
    var cells: [cellData]
}

struct cellData {
    var icon: String
    var time: String
    var temp: String
    var weather: String
}

// new Data models for today

struct dayData {
    var id : String
    var cityName: String
    var countryName: String
    var temp: String
    var weather: String
    var icon :  String
    var cloudiness: String
    var humidity: String
    var windSpeed: String
    var windDirection: String
    // isCurrentLocationData
    var curLocation: Bool
}


enum Direction: String {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}

extension Direction: CustomStringConvertible  {
    static let all: [Direction] = [.n, .nne, .ne, .ene, .e, .ese, .se, .sse, .s, .ssw, .sw, .wsw, .w, .wnw, .nw, .nnw]
    init(_ direction: Double) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.all[index]
    }
    var description: String {
        return rawValue.uppercased()
    }
}
