//
//  TodayController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/3/21.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class TodayController: UIViewController, CLLocationManagerDelegate {
    
    private var locationManager : CLLocationManager!
    private let serivce = Service()
    private var todayData: [dayData] = []
    // coordinates
    private var latitude = "0"
    private var longitude = "0"
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "bg-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "bg-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        // gradient
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        //
        getLocationPermison()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func setupNavBar(){
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.title = "Today"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(refersh))
    }
    
    func getLocationPermison(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    
    @objc func refersh() {
        print("refresh Today")
        todayData.removeAll()
//        loadStart()
        getDataFromAPI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.latitude = String((manager.location?.coordinate.latitude)!)
        self.longitude = String((manager.location?.coordinate.longitude)!)
        print(self.latitude, self.latitude)
        getDataFromAPI()
                              
        
    }
    
    func getDataFromAPI(){
        serivce.getTodayDatabyCoord(lat: self.latitude, lon: self.longitude){ result in
            switch result{
            case .success(let apiData):
                print(apiData)
                self.todayData.removeAll()
                
//                for forecast in apiData {
//                    let day = self.formatter.weekdaySymbols[forecast.getDayIndex()]
//
//                    if self.forecastData.isEmpty || self.forecastData[self.forecastData.count-1].dayName != day {
//                        self.forecastData.append(dayForecast(dayName: day, cells: [cellData]()))
//                    }
//
//                    self.forecastData[self.forecastData.count-1].cells.append(
//                        cellData(
//                            icon: forecast.weather[0].icon,
//                            time: forecast.getTime(),
//                            temp: String(round(forecast.main.temp - 273.15)) + "˚C",
//                            weather: forecast.weather[0].description)
//                    )
//                }
                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                self.loadEnd()
            case .failure(let error):
                print(error)
            }
        }
    }
}
