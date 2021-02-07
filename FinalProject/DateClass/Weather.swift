//
//  Weather.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/7/21.
//

import Foundation

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

struct Temp : Codable{
    let temp: Double
}
struct Weather : Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
