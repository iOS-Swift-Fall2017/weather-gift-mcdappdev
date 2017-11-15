//
//  DetailVC.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 10/11/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd, y"
    return dateFormatter
}()

class DetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationDetail: WeatherDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        locationDetail = WeatherDetail(name: locationsArray[currentPage].name, coordinates: locationsArray[currentPage].coordinates)
        
        locationDetail.getWeather {
            self.updateUserInterface()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentPage == 0 {
            getLocation()
        }
    }
    
    private func updateUserInterface() {
        let location = locationDetail
        locationLabel.text = location!.name
        
        dateLabel.text = location!.currentTime.format(timeZone: location!.timeZone, dateFormatter: dateFormatter)
        temperatureLabel.text = location!.currentTemp
        summaryLabel.text = location!.currentSummary
        currentImage.image = UIImage(named: location!.currentIcon)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            print("Something went wrong getting the UIApplicationOpenSettingsURLString")
            return
        }
        let settingsActions = UIAlertAction(title: "Settings", style: .default) { value in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsActions)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .restricted:
            showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        dateLabel.text = currentCoordinates
        
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if placemarks != nil {
                let placemark = placemarks?.last
                place = (placemark?.name)!
            } else {
                print(error!)
                place = "Unknown Weather Location"
            }
            
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoordinates
            self.locationDetail = WeatherDetail(name: place, coordinates: currentCoordinates)
            self.locationDetail.getWeather {
                self.updateUserInterface()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDataSource
extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDetail.dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell") as? DayWeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let location = locationDetail
        let dailyForcast = location!.dailyForecastArray[indexPath.row]
        
        cell.update(with: dailyForcast, timeZone: location!.timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - UICollectionViewDataSource and Delegate
extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationDetail.hourlyForecastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        let hourlyForecast = locationDetail.hourlyForecastArray[indexPath.row]
        
        hourlyCell.update(with: hourlyForecast, timeZone: locationDetail.timeZone)
        
        return hourlyCell
    }
}
