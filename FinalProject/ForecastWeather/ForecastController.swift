//
//  ForecastController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/2/21.
//

import UIKit
import CoreLocation

class ForecastController: UIViewController, CLLocationManagerDelegate {
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "bg-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "bg-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    var locationManager : CLLocationManager!
    
    let tableView = UITableView()
//    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        // gradient
        gradientLayer.frame = view.bounds
        self.view.layer.addSublayer(gradientLayer)
        // Table View
        getLocationPermison()
        setupTableView()
        
        
    }
    
    func getLocationPermison(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        //
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: view.topAnchor/*, constant: 100 */).isActive = true
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor/*, constant: -100 */).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //
        tableView.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func setupNavBar(){
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.title = "Forecast"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(refersh))
    }
    
    @objc func refersh() {
        print("refresh Forecast")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cordinate = manager.location?.coordinate
//        let locString = placemarks.count ? [placemarks.firstObject, locality] : "Not Found"
//        print("Lat =  \(String(describing: cordinate?.latitude)), Log = \(String(describing: cordinate?.longitude))")
        let baseurl = "https://api.openweathermap.org/data/2.5/forecast"
        let latitude = String(cordinate?.latitude ?? 0)
        let longitude = String(cordinate?.longitude ?? 0)
        let url = URL(string: baseurl + "?lat=" + latitude + "&lon=" + longitude + "&appid=5f8a54152982833dbda141cb4eb7d051")!
        
        print(url)
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, SesionError) in
            if let data = data{
                let decoder = JSONDecoder()
                do {
                    let reuslt = try decoder.decode(ForcastData.self, from: data)
                    for row in reuslt.list {
                        print(row.dt_txt) //date
                        print(row.weather[0].main)
//                        var date = Date(timeIntervalSince1970: (Double(row.dt)))
//                        print("date - \(date)")
                        print(row.main.temp) //temp
                        break
                    }
//                    print(reuslt)
                }catch{
                    print(error)
                }
            }
//            print(data, response, SesionError)
        }
        task.resume()
    }
}

