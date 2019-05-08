//
//  CoreLocationViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/29/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CoreLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    public static var shared = CoreLocationViewController()
    var locationManager : CLLocationManager!
    
    
    @IBAction func mapControlDidChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
            break
        case 1:
            mapView.mapType = .satellite
            break
        case 2:
            mapView.mapType = .hybrid
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        self.mapView.showsUserLocation = true
        startLocationServices()
        
    
        // Do any additional setup after loading the view.
    }
    
    func startLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .denied, .restricted:
                    print("Denied")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services not enabled")
        }
    }
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            locationManager.stopUpdatingLocation()
            let errorMsg = "Location service permission denied for this app"
            
            let alert = UIAlertController(title: "Location Error", message: errorMsg, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) {
                (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings Opened")
                    })
                }
            }
            alert.addAction(settingsAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 100.0
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            let lastLocation : CLLocation = last
            zoomToRegion(lat: lastLocation.coordinate.latitude, long: lastLocation.coordinate.longitude)
            storeLocation(lastLocation: lastLocation) {(placeMark) in
                CaptionsModel.shared.storeLocations(name: placeMark?.name, country: placeMark?.country, state: placeMark?.administrativeArea, city: placeMark?.locality)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newRegion : MKCoordinateRegion = mapView.region
        let center : CLLocationCoordinate2D = newRegion.center
        let span : MKCoordinateSpan = newRegion.span
    }

    func zoomToRegion(lat : CLLocationDegrees, long: CLLocationDegrees) {
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let regionRadius : CLLocationDistance = 15000
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func storeLocation(lastLocation: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(lastLocation, completionHandler: {
            (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                print("Name: \(firstLocation?.name)")
                print("Country: \(firstLocation?.country)")
                print("State: \(firstLocation?.administrativeArea)")
                print("City: \(firstLocation?.locality)")
                completionHandler(firstLocation)
            }
            else {
                // Error
                completionHandler(nil)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
