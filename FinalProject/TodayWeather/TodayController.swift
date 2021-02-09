//
//  TodayController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/3/21.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
//import CollectionViewPagingLayout
import UPCarouselFlowLayout

class TodayController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    private var locationManager : CLLocationManager!
    private let serivce = Service()
    private var todayData: [dayData] = []
    private var collectionView :  UICollectionView!
    private var loader = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color:UIColor(named: "AccentColor") ?? .yellow, padding: 0)
    private let layout = UPCarouselFlowLayout()
//    private let layout = CollectionViewPagingLayout()
//    private let layout = UICollectionViewLayout()
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
        setupLoader()
        setupCollectionView()
        loadStart()
//        getDataFromAPI2(city: "Kutaisi", isCurLoc: false)
//        getDataFromAPI2(city: "Tbilisi", isCurLoc: false)
//        getDataFromAPI2(city: "Batumi", isCurLoc: false)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        collectionView.frame = self.view.frame

        //layout.sectio
        layout.itemSize = CGSize(width: collectionView.bounds.width * 0.7, height: collectionView.bounds.height * 0.6)
        collectionView.collectionViewLayout = layout
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
    
    func setupCollectionView() {
        
        
        // layout
        //let layout = CollectionViewPagingLayout()

        //layout.sectio
        collectionView  =  UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.bounds.width * 0.7, height: collectionView.bounds.height * 0.6)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //
        
        collectionView.register( UINib(nibName: "CardView", bundle: nil), forCellWithReuseIdentifier: "CardView")
        //        collectionView.isPagingEnabled = true // enabling paging effect
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
//        collectionView.
//        collectionView.isScrollEnabled = true
        
    }
    
    func setupLoader() {
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 40),
            loader.heightAnchor.constraint(equalToConstant: 40),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        self.loader.startAnimating()
        self.loader.isHidden = true
    }
    
    func loadStart(){
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.loader.isHidden = false
        }
        
    }
    
    func loadEnd(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.loader.isHidden = true
            self.collectionView.isHidden = false
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardView
//        if indexPath.section%2 == 1 {
//            curCell.mainView.backgroundColor = .green
//        }
//        if indexPath.row%2 == 1 {
//            curCell.mainView.backgroundColor = .green
//        }
        
        return curCell
    }
}
