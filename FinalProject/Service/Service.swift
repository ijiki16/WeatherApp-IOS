//
//  Service.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/7/21.
//

import Foundation

class Service {
    
    private let apiKey = "5f8a54152982833dbda141cb4eb7d051"
    private var components = URLComponents()
    
    init(){
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
    }
    
    func getFocastData(lat: String = "0", lon: String = "0",  completion: @escaping (Result<[rowData], Error >) -> ()){
        
        let parameters = [
            "appid" : apiKey,
            "lat" : lat,
            "lon" : lon,
        ]
        
        components.queryItems = parameters.map{ key, value in return URLQueryItem(name: key, value: value) }
         
        if let url = components.url{
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, SesionError) in
                
                if let error = SesionError{
                    completion(.failure(error))
                    return
                }
                
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let reuslt = try decoder.decode(ForcastData.self, from: data)
                        completion(.success(reuslt.list))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }else{
            completion(.failure(ServiceError.invalidPatameters))
        }
    }
    
    
    enum ServiceError: Error{
        case noData
        case invalidPatameters
    }
}
