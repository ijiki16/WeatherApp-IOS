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
    private let formatter = DateFormatter()
    private var forecastData: [dayForecast] = []
    private var tableView = UITableView()
    private var blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    // coordinates
    private var latitude = "0"
    private var longitude = "0"
    
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
        tableView = UITableView(frame: view.bounds, style: .grouped)
        self.view.layer.addSublayer(gradientLayer)
        //
        getLocationPermison()
        setupTableView()
        loadStart()
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
        tableView.register(UINib(nibName: "ForecastTableHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ForecastTableHeader")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func loadStart(){
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 30, height: 50))
        DispatchQueue.main.async {
//            self.blur.frame = self.view.bounds
            self.tableView.isHidden = true
            self.view.addSubview(self.blur)
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadEnd(){
        DispatchQueue.main.async {
            
//            self.blur.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
            self.tableView.isHidden = false
        }
    }
    
    @objc func refersh() {
//        print("refresh Forecast")
        forecastData.removeAll()
        loadStart()
        getDataFromAPI()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.latitude = String((manager.location?.coordinate.latitude)!)
        self.longitude = String((manager.location?.coordinate.longitude)!)
        getDataFromAPI()
                              
        
    }
    
    func getDataFromAPI(){
        serivce.getFocastData(lat: self.latitude, lon: self.longitude){ result in
            switch result{
            case .success(let apiData):
                
                self.forecastData.removeAll()
                
                for forecast in apiData {
                    let day = self.formatter.weekdaySymbols[forecast.getDayIndex()]
                    
                    if self.forecastData.isEmpty || self.forecastData[self.forecastData.count-1].dayName != day {
                        self.forecastData.append(dayForecast(dayName: day, cells: [cellData]()))
                    }
                    
                    self.forecastData[self.forecastData.count-1].cells.append(
                        cellData(
                            icon: forecast.weather[0].icon,
                            time: forecast.getTime(),
                            temp: String(round(forecast.main.temp - 273.15)) + "˚C",
                            weather: forecast.weather[0].description)
                    )
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.loadEnd()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.forecastData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ForecastTableHeader") as! ForecastTableHeader
        //        header.backgroundColor = .red
        //        header.backgroundView?.backgroundColor = .clear
        //        header.mainView.backgroundColor = .clear
        //        header.day.backgroundColor = .clear
        
        header.day.text = self.forecastData[section].dayName
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastData[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableCell", for: indexPath)
        if let forcastrow = cell as? ForecastTableCell{
            
            let curCell = self.forecastData[indexPath.section].cells[indexPath.row]
            // set data
            forcastrow.temp.text = curCell.temp
            forcastrow.weather.text = curCell.weather
            forcastrow.clock.text = curCell.time
            let urlString = "https://openweathermap.org/img/wn/"+curCell.icon+"@2x.png"
            forcastrow.icon.sd_setImage(with: URL(string: urlString), completed: nil)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

