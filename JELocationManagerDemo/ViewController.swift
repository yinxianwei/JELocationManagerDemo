//
//  ViewController.swift
//  JELocationManagerDemo
//
//  Created by Work on 15/6/30.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    @IBAction func locationClick(sender: AnyObject) {
        
        JELocationManager.sharedManager.getLocation({ (city, coordinate, address) -> Void in

            self.label.text = String(format: "城市：%@,经纬度：%f,%f，地址：%@", city,coordinate.latitude,coordinate.longitude,address)
            
            }, failure: { (error) -> Void in
                self.label.text = error
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

