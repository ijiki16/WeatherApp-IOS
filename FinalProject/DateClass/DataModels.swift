//
//  Weather.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/7/21.
//

import Foundation

// API data models

struct ForcastData : Codable{ 
    let cod: String
    let message: Int
    let cnt: Int
    let list: [rowData]
    
}

struct rowData : Codable {
    let dt: Double
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
}
struct Weather : Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// new Data models

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
