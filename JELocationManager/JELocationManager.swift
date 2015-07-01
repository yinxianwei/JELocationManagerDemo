//
//  JELocationManager.swift
//  JELocationManagerDemo
//
//  iOS8.0以上!
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class JELocationManager: NSObject,CLLocationManagerDelegate {
    
    typealias successfulBlock = (city : String, coordinate:CLLocationCoordinate2D, address:String) -> Void
    typealias failureBlock = (error:String) -> Void
    
    private var locationManager:CLLocationManager!
    private var successful:successfulBlock?
    private var failure:failureBlock?
    
    override init(){
        super.init()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //add by zhangzhenqiang
        locationManager.activityType = CLActivityType.Fitness
        locationManager.distanceFilter = 2000.0

        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    class var sharedManager: JELocationManager {
        struct Static {
            static let instance: JELocationManager = JELocationManager()
        }
        return Static.instance
    }
    
    private var hasLocated = false
    
//MARK: - 获取当前位置信息
    func getLocation(successful:successfulBlock,failure:failureBlock){
        hasLocated = false
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.successful = successful
        self.failure = failure
    }

//MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status)
        {  case CLAuthorizationStatus.NotDetermined:
            if locationManager.respondsToSelector("requestAlwaysAuthorization"){
                locationManager.requestAlwaysAuthorization()
            }

        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if hasLocated{
            return
        }
        hasLocated = true
        
        locationManager.stopUpdatingLocation()
        
        var location = newLocation
        var geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if placemarks.count > 0{
                let placemark = placemarks[0] as! CLPlacemark
                
                let cityObj: AnyObject? = placemark.addressDictionary["City"]
                let stateObj: AnyObject? = placemark.addressDictionary["State"]

                if var city = cityObj as? String{
                    
                    if let state = stateObj as? String{
                        
                        if (city as NSString).rangeOfString(state).location != NSNotFound{
                            city = state
                        }
                    }
                    self.successful?(city: city, coordinate: location.coordinate, address: placemark.name)
                }
                else{
                    self.failure?(error: "定位失败")
                }
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {

        self.failure?(error: "需要开启定位服务,请到设置->隐私,打开定位服务")
    }
    
}









