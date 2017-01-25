//
//  ViewController.swift
//  GMapsDemo
//
//  Created by Gabriel Theodoropoulos on 29/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    var locationManager = CLLocationManager()
    
    let marker = GMSMarker()
    
    var arrLatLong: NSArray!
    var count = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 26.891126, longitude: 75.773097, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: 26.891126, longitude: 75.773097)
        marker.title = "Jaipur"
        marker.snippet = "Rajasthan"
        marker.icon = UIImage(named:"arrow")
        marker.map = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        arrLatLong = [CLLocation(latitude: 26.891126, longitude: 75.773097),
                      CLLocation(latitude: 26.891050, longitude: 75.772678),
                      CLLocation(latitude: 26.890897, longitude: 75.772142),
                      CLLocation(latitude: 26.890820, longitude: 75.771680),
                      CLLocation(latitude: 26.890753, longitude: 75.771326),
                      CLLocation(latitude: 26.891011, longitude: 75.771208),
                      CLLocation(latitude: 26.891576, longitude: 75.770962),
                      CLLocation(latitude: 26.891987, longitude: 75.770801),
                      CLLocation(latitude: 26.891796, longitude: 75.770296),
                      CLLocation(latitude: 26.891662, longitude: 75.769663)]
        
        let btnMove = UIButton.init(frame: CGRect(x: 0, y: 20, width: 100, height: 40))
        btnMove.setTitle("Move", for: .normal)
        btnMove.addTarget(self, action: #selector(changeLocation), for: .touchUpInside)
        view.addSubview(btnMove)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: IBAction method implementation
    
    @IBAction func changeMapType(_ sender: AnyObject) {
        marker.rotation = DegreeBearing(A: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude), B: CLLocation(latitude: 26.890782, longitude: 75.771638))
    }
    
    
    @IBAction func findAddress(_ sender: AnyObject) {
    
    }
    
    
    @IBAction func createRoute(_ sender: AnyObject) {
    
    }
    
    
    @IBAction func changeTravelMode(_ sender: AnyObject) {
    
    }
    
    func DegreeBearing(A:CLLocation,B:CLLocation)-> Double{
        var dlon = self.ToRad(degrees: B.coordinate.longitude - A.coordinate.longitude)
        let dPhi = log(tan(self.ToRad(degrees: B.coordinate.latitude) / 2 + M_PI / 4) / tan(self.ToRad(degrees: A.coordinate.latitude) / 2 + M_PI / 4))
        if  abs(dlon) > M_PI{
            dlon = (dlon > 0) ? (dlon - 2*M_PI) : (2*M_PI + dlon)
        }
        return self.ToBearing(radians: atan2(dlon, dPhi))
    }
    
    func ToRad(degrees:Double) -> Double{
        return degrees*(M_PI/180)
    }
    
    func ToBearing(radians:Double)-> Double{
        return (ToDegrees(radians: radians) + 360).truncatingRemainder(dividingBy: 360)
    }
    
    func ToDegrees(radians:Double)->Double{
        return radians * 180 / M_PI
    }
    
    @IBAction func changeLocation() {
        if timer != nil {
            timer?.invalidate()
            count = 0
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        timer?.fire()
//        updateLocation()
    }
    
    func updateLocation() {
        if count < arrLatLong.count {
//            UIView.animate(withDuration: 0.5, animations: {
//                
//                // Your changes to the UI, eg. moving UIImageView up 300 points
//                self.marker.rotation = self.DegreeBearing(A: CLLocation(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude), B: self.arrLatLong.object(at: self.count) as! CLLocation)
//                
//            }) { (success) in
//                
//                // This executes when animation is completed
//                // Create another animation here. It starts when previous ends
        
//                UIView.animate(withDuration: 1.0, animations: {
//                    
//                    self.marker.position = (self.arrLatLong.object(at: self.count) as! CLLocation).coordinate
//                    
//                }, completion: { (success) in
//                    
//                    // This executes when animation is completed
//                    self.count = self.count + 1
//                    
//                })
                
//            }
//            UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
//            
//                print(self.DegreeBearing(A: CLLocation(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude), B: self.arrLatLong.object(at: self.count) as! CLLocation))
//            }, completion: { (bool) in
//            
//            
//            })
            
            UIView.animate(withDuration: 1.0, animations: {
                 self.marker.rotation = self.DegreeBearing(A: CLLocation(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude), B: self.arrLatLong.object(at: self.count) as! CLLocation)
            }, completion: {
                (value: Bool) in
                self.marker.position = (self.arrLatLong.object(at: self.count) as! CLLocation).coordinate
                self.count = self.count + 1
            })
            
            
        } else {
            //count = 0
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
//            (view as! GMSMapView).isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last!.horizontalAccuracy <= manager.desiredAccuracy {
            UIView.animate(withDuration: 0.1, animations: {
                self.marker.rotation = self.DegreeBearing(A: CLLocation(latitude: self.marker.position.latitude, longitude: self.marker.position.longitude), B: manager.location!)
            }, completion: {
                (value: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.marker.position = (manager.location?.coordinate)!
                    //                let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 17.0)
                    //                (self.view as! GMSMapView).camera = camera
                })
            })
        }
        
//        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
//        timer.fire()
    }
}
