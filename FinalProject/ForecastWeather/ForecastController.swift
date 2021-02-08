//
//  ForecastController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/2/21.
//

import UIKit
import CoreLocation
import SDWebImage

class ForecastController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var locationManager : CLLocationManager!
    private let serivce = Service()
    private var forecastData = [rowData]()
    private let tableView = UITableView()
    let gradientLayer: CAGradientLayer = {
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
//        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //
        tableView.register(UINib(nibName: "ForecastTableCell", bundle: nil), forCellReuseIdentifier: "ForecastTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableCell", for: indexPath)
        if let forcastrow = cell as? ForecastTableCell{
            
            let curentRow = self.forecastData[indexPath.row]
//            print(indexPath)
//            print(curentRow)
            // temp
            let temperature = round(curentRow.main.temp - 273.15)
            forcastrow.temp.text = String(temperature) + "˚C"
            // weather
            forcastrow.weather.text = curentRow.weather[0].main
            // date
            let date = curentRow.dt_txt
            let index = date.firstIndex(of: " ")!
            let index1 = date.index(index, offsetBy: 1)
            let index2 = date.index(index, offsetBy: 5)
            let firstSentence = date[index1...index2]
            forcastrow.clock.text = String(firstSentence)
            // icon
            let iconId = curentRow.weather[0].icon
            let urlString = "https://openweathermap.org/img/wn/"+iconId+"@2x.png"
            forcastrow.icon.sd_setImage(with: URL(string: urlString), completed: nil)

            
        }
        cell.backgroundColor = UIColor.clear
        return cell
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
        serivce.getFocastData(lat: String((manager.location?.coordinate.latitude)!), lon: String((manager.location?.coordinate.longitude)!)){ result in
            switch result{
            case .success(let data):
                self.forecastData.removeAll()
                self.forecastData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

