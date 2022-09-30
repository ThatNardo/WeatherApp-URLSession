//
//  WeatherViewController.swift
//  WeatherApp - URLSession
//
//  Created by Buğra Özuğurlu on 30.09.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var degreeLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLocation()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherLocation()
        
       
      
        
    }
    
    struct Weather:Decodable {
        
        let name:String
        let region:String
        let country:String
        let lat:Float
        let lon:Float
        let localtime:Int
        let icon:String
        let text:String
        
    }
   
    
    //Location
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            weatherLocation()
            
        }
    }
    
    
    func weatherLocation() {
        
        guard let currentLocation = currentLocation else {return}
        
        let long = currentLocation.coordinate.longitude
        let lati = currentLocation.coordinate.latitude
        
        let url = "http://api.weatherapi.com/v1/current.json?key=cbaa0bdc08984ca697f120207223009&q=Nevsehir&aqi=no"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard error != nil else{
            
                return print(error?.localizedDescription)
            }
                
            
            if let data = data {
                
                do{
                    let jRes = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as?
                    Dictionary<String, Any>
                    
                    DispatchQueue.main.async {
                        
                        if let current = jRes?["current"] as? [String:Any] {
                            
                            if let temp_c = current["temp_c"] as? Double {
                                self.degreeLabel.text = String(temp_c)
                                
                                
                            }
                            
                        }
                       
                       
                        
                        
                    }
                    
                    
                }catch{
                    
                }
                
                
            }
            
            
            
        }.resume()
    }
    
}
