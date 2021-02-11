//
//  TodayController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/3/21.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import SDWebImage
//import CollectionViewPagingLayout
import UPCarouselFlowLayout

class TodayController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    private var locationManager : CLLocationManager!
    private let serivce = Service()
    public var todayData: [dayData] = []
    private var collectionView :  UICollectionView!
    private var loader = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color:UIColor(named: "AccentColor") ?? .yellow, padding: 0)
    private var addButton = UIButton(frame: .zero)
    private var addCard = addCityCardView()
    private var blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let layout = UPCarouselFlowLayout()
    
    //    private let layout = CollectionViewPagingLayout()
    //    private let layout = UICollectionViewLayout()
    // coordinates
    private var latitude = "0"
    private var longitude = "0"
    
    private let gradientLayerBG: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "bg-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "bg-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    private let gradientLayerBlue: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "blue-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "blue-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    private let gradientLayerGreen: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "green-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "green-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    private let gradientLayerOchre: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "ochre-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "ochre-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        // gradient
        gradientLayerBG.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayerBG)
        //
        getLocationPermison()
        setupLoader()
        setupCollectionView()
        setupButton()
        setupAddCard()
        loadStart()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.removeAddCityCard))
        self.blur.addGestureRecognizer(gesture)
        //        getDataFromAPI2(city: "Kutaisi", isCurLoc: false)
        //        getDataFromAPI2(city: "Tbilisi", isCurLoc: false)
        //        getDataFromAPI2(city: "Batumi", isCurLoc: false)
        
    }
    
    @objc func removeAddCityCard(sender : UITapGestureRecognizer) {
        // Do what you want
        addCard.isHidden = true
        self.addCard.button.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addCard.textInput.text = ""
        blurEnd()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayerBG.frame = view.bounds
        collectionView.frame = self.view.frame
        
        //layout.sectio
        layout.itemSize = CGSize(width: collectionView.bounds.width * 0.7, height: collectionView.bounds.height * 0.6)
        //        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        self.blur.frame = self.view.bounds
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
        collectionView  =  UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        layout.scrollDirection = .horizontal
        //        layout.itemSize = CGSize(width: collectionView.bounds.width * 0.7, height: collectionView.bounds.height * 0.6)
        //        layout.minimumLineSpacing = collectionView.bounds.width * 0.3
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: collectionView.bounds.width * 0.15, bottom: 0, right: collectionView.bounds.width * 0.15)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.register( UINib(nibName: "CardView", bundle: nil), forCellWithReuseIdentifier: "CardView")
        //t
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        collectionView.addGestureRecognizer(longPress)
        //        collectionView.isScrollEnabled = true
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        let alertActionCell = UIAlertController(title: "Delete this city?", message: "Choose an action", preferredStyle: .alert)
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            for (index, data) in self.todayData.enumerated() {

                if (data.isMainData) {
                    self.todayData.remove(at: index)
                }
            }
            self.collectionView.reloadData()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        })
        
        alertActionCell.addAction(deleteAction)
        alertActionCell.addAction(cancelAction)
        
        
        self.present(alertActionCell, animated: true, completion: nil)
        
        
    }
    
    
    func setupButton(){
        
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 25
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        addButton.isHidden = true
    }
    
    @objc func buttonAction(sender: UIButton!) {
        //        print("Button tapped")
        self.addCard.button.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addCard.textInput.text = ""
        addCard.isHidden = !addCard.isHidden
        blurStart()
    }
    
    
    func setupAddCard(){
        
        self.addCard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addCard)
        
        NSLayoutConstraint.activate([
            addCard.widthAnchor.constraint(equalToConstant: 320),
            addCard.heightAnchor.constraint(equalToConstant: 220),
            addCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addCard.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        //        addCard.mainView.backgroundColor = .clear
        gradientLayerGreen.frame = addCard.mainView.bounds
        gradientLayerGreen.cornerRadius = 30
        addCard.mainView.layer.insertSublayer(gradientLayerGreen, at: 0)
        addCard.mainView.backgroundColor = UIColor(named: "green-gradient-start")
        
        addCard.button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        addCard.isHidden = true
    }
    
    @objc func addCity(sender: UIButton!) {
        //        print("Button add City")
        self.addCard.button.setImage(UIImage(systemName: "globe"), for: .normal)
        let text = self.addCard.textInput.text
        //        print(text)
        getDataFromAPI2(city: text ?? "", isCurLoc: false)
        
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
            self.addButton.isHidden = true
            self.loader.isHidden = false
            self.addCard.isHidden = true
        }
        
    }
    
    func loadEnd(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.loader.isHidden = true
            self.collectionView.isHidden = false
            self.addButton.isHidden = false
        }
    }
    
    func blurStart() {
        DispatchQueue.main.async {
            self.blur.frame = self.view.bounds
            self.view.addSubview(self.blur)
            self.view.bringSubviewToFront(self.addCard)
        }
    }
    
    func blurEnd(){
        DispatchQueue.main.async {
            self.blur.removeFromSuperview()
        }
    }
    
    @objc func refersh() {
        print("refresh Today")
        //        todayData.removeAll()
        loadStart()
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
                    
                    var curDt = data
                    curDt.isMainData = false
                    self.todayData.remove(at: index)
                    if (String(cityID) != data.id || !data.curLocation) {
                        self.todayData.append(curDt)
                    }
                    
                }
                
                self.todayData.append(
                    dayData(
                        id : String(cityID),
                        cityName: apiData.name,
                        countryName: apiData.sys.country,
                        temp: String(round(apiData.main.temp - 273.15)) + "˚C",
                        weather: apiData.weather[0].description,
                        icon: apiData.weather[0].icon,
                        cloudiness: String(Int(round(apiData.clouds.all))) + "%", //"75%",
                        humidity: String(Int(round(apiData.main.humidity))) + " mm", //"93 mm",
                        windSpeed: String(apiData.wind.speed) + " km/h", //"1.03 km/h",
                        windDirection: Direction(apiData.wind.deg).description, //"W"
                        curLocation: true,
                        isMainData: true,
                        latitude : String(apiData.coord.lat),
                        longitude : String(apiData.coord.lon)
                    )
                )
                
                //                print(self.todayData)
                //                print("--------------------")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
                    var curDt = data
                    curDt.isMainData = false
                    self.todayData.remove(at: index)
                    if (String(cityID) != data.id) {
                        self.todayData.append(curDt)
                    }
                }
                
                self.todayData.append(
                    dayData(
                        id : String(cityID),
                        cityName: apiData.name,
                        countryName: apiData.sys.country,
                        temp: String(round(apiData.main.temp - 273.15)) + "˚C",
                        weather: apiData.weather[0].description,
                        icon: apiData.weather[0].icon,
                        cloudiness: String(Int(round(apiData.clouds.all))) + "%", //"75%",
                        humidity: String(Int(round(apiData.main.humidity))) + " mm", //"93 mm",
                        windSpeed: String(apiData.wind.speed) + " km/h", //"1.03 km/h",
                        windDirection: Direction(apiData.wind.deg).description, //"W"
                        curLocation: isCurLoc,
                        isMainData: true,
                        latitude : String(apiData.coord.lat),
                        longitude : String(apiData.coord.lon)
                    )
                )
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.blurEnd()
                    self.addCard.isHidden = true
                }
                
                
                //                print(self.todayData)
                //                print("--------------------")
                self.loadEnd()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.addCard.button.setImage(UIImage(systemName: "plus"), for: .normal)
                    self.addCard.shake()
                }
                print(error)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let curCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardView
        //        print(indexPath.row)
        
        let curDt = todayData[indexPath.row]
        // icon
        let urlString = "https://openweathermap.org/img/wn/"+curDt.icon+"@2x.png"
        curCell.icon.sd_setImage(with: URL(string: urlString), completed: nil)
        // place
        let current = Locale(identifier: "en_US")
        let namePlace = current.localizedString(forRegionCode:  curDt.countryName) ??  curDt.countryName
        curCell.place.text = curDt.cityName + " , " + namePlace
        // weather
        curCell.wether.text = curDt.temp + " | " + curDt.weather
        //
        curCell.cloudiness.dataType.text = "Cloudiness"
        curCell.cloudiness.dataValue.text = curDt.cloudiness
        curCell.cloudiness.icon.image = UIImage(named: "raining")
        //
        curCell.humidity.dataType.text = "Humidity"
        curCell.humidity.dataValue.text = curDt.humidity
        curCell.humidity.icon.image = UIImage(named: "drop")
        //
        curCell.windSpeed.dataType.text = "Wind Speed"
        curCell.windSpeed.dataValue.text = curDt.windSpeed
        curCell.windSpeed.icon.image = UIImage(named: "wind")
        //
        curCell.windDirection.dataType.text = "Wind Direction"
        curCell.windDirection.dataValue.text = curDt.windDirection
        curCell.windDirection.icon.image = UIImage(named: "compass")
        //        if indexPath.section%2 == 1 {
        //            curCell.mainView.backgroundColor = .green
        //        }
        //        if indexPath.row%2 == 1 {
        //            curCell.mainView.backgroundColor = .green
        //        }
        
        return curCell
    }
}
