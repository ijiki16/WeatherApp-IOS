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
        getDataFromAPI2(city: "Kutaisi", isCurLoc: false)
        getDataFromAPI2(city: "Tbilisi", isCurLoc: false)
        getDataFromAPI2(city: "Batumi", isCurLoc: false)
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
    
    func loadStart(){
//        self.tableView.isHidden = true
//        print("movida aq")
        let loader = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color:UIColor(named: "AccentColor") ?? .yellow, padding: 0)
        loader.translatesAutoresizingMaskIntoConstraints = false
//        loader.widthAnchor.constraint(equalToConstant: 40)
        self.view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 40),
            loader.heightAnchor.constraint(equalToConstant: 40),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            loader.stopAnimating()
            loader.isHidden = true
//            self.tableView.isHidden = false
        }

        //        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        //        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 30, height: 50))
//        DispatchQueue.main.async {
//            self.blur.frame = self.view.bounds
//            self.view.addSubview(self.blur)
//            loadingIndicator.hidesWhenStopped = true
//            loadingIndicator.startAnimating();
//            alert.view.addSubview(loadingIndicator)
//            self.present(loader, animated: true, completion: nil)
//        }
        
    }
    
    func loadEnd(){
        DispatchQueue.main.async {
            
//            self.blur.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
//            self.tableView.isHidden = false
        }
    }
    
    @objc func refersh() {
        print("refresh Today")
//        todayData.removeAll()
//        loadStart()
        getDataFromAPI1()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.latitude = String((manager.location?.coordinate.latitude)!)
        self.longitude = String((manager.location?.coordinate.longitude)!)
//        print(self.latitude, self.latitude)
        getDataFromAPI1()
                              
        
    }
    
    func getDataFromAPI1(){
        serivce.getTodayDatabyCoord(lat: self.latitude, lon: self.longitude){ result in
            switch result{
            case .success(let apiData):
//                print(apiData)
//                self.todayData.removeAll()
                
                let cityID = apiData.id
                
                for (index, data) in self.todayData.enumerated() {
                    if (String(cityID) == data.id) {
                        self.todayData.remove(at: index)
                    }
                }
                
                self.todayData.append(
                    dayData(
                        id : String(cityID),
                        cityName: apiData.name,
                        countryName: apiData.sys.country,
                        temp: String(round(apiData.main.temp - 273.15)) + "˚C",
                        weather: apiData.weather[0].description,
                        cloudiness: String(round(apiData.clouds.all)) + " %", //"75%",
                        humidity: String(round(apiData.main.humidity)) + " mm", //"93 mm",
                        windSpeed: String(round(apiData.wind.speed)) + " km/h", //"1.03 km/h",
                        windDirection: Direction(apiData.wind.deg).description, //"W"
                        curLocation: true
                    )
                )
                print(self.todayData)
                print("--------------------")
                DispatchQueue.main.async {
//                    self.tableView.reloadData()
                }
                self.loadEnd()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDataFromAPI2(city: String, isCurLoc : Bool){
        serivce.getTodayDatabyCity(cityName: city){ result in
            switch result{
            case .success(let apiData):
//                print(apiData)
//                self.todayData.removeAll()
                
                let cityID = apiData.id
                
                for (index, data) in self.todayData.enumerated() {
                    if (String(cityID) == data.id) {
                        self.todayData.remove(at: index)
                    }
                }
                
                self.todayData.append(
                    dayData(
                        id : String(cityID),
                        cityName: apiData.name,
                        countryName: apiData.sys.country,
                        temp: String(round(apiData.main.temp - 273.15)) + "˚C",
                        weather: apiData.weather[0].description,
                        cloudiness: String(round(apiData.clouds.all)) + " %", //"75%",
                        humidity: String(round(apiData.main.humidity)) + " mm", //"93 mm",
                        windSpeed: String(round(apiData.wind.speed)) + " km/h", //"1.03 km/h",
                        windDirection: Direction(apiData.wind.deg).description, //"W"
                        curLocation: isCurLoc
                    )
                )
                
                print(self.todayData)
                print("--------------------")
            case .failure(let error):
                print(error)
            }
        }
    }
}
