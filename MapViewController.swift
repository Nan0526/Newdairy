//
//  MapViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/13.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var theLocation: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager=CLLocationManager()
    var tlong:Double=0
    var tlan:Double=0
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func managerConfig(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    
    @IBAction func showMyLocation(_ sender: UIButton) {
        managerConfig()
//        if(manager == nil){
//            manager=CLLocationManager()
//            manager.delegate=self
//        }
        //manager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            manager.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            let distance : CLLocationDistance = 10.0
            manager.distanceFilter = distance
            //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationHelper()
        }
        
    }
    func locationHelper(){
        if let coordinate = manager.location?.coordinate{
            let annotation = MKPointAnnotation()
            annotation.title = "my location"
            annotation.coordinate = coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            tlan=annotation.coordinate.latitude
            tlong=annotation.coordinate.longitude
            reverseGeocode()
        }
        
    }
    func reverseGeocode(){
        let geocoder = CLGeocoder()
        var p:CLPlacemark?
        let currentLocation = CLLocation(latitude: tlan, longitude: tlong)
        
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
            
            
            if error != nil {
                print("error：\(String(describing: error?.localizedDescription)))")
                
                return
            }
            let pm = placemarks as! [CLPlacemark]
           // print(pm)
            if pm.count > 0{
                p = placemarks![0] as? CLPlacemark
                print(p?.name)
                self.theLocation.text = p?.name
            } else {
                print("No placemarks!")
            }
        }
    }
    @IBAction func entry(_ sender: UIButton) {
        //把位置信息返回去
        print("send notify")
        let notificationName = Notification.Name(rawValue: "locationNotification")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["location":theLocation.text])
        print("end send")
        //back
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopUpdatingLocation()
    }
    
}
