//
//  ViewController.swift
//  Project7
//
//  Created by Danny G on 11/3/16.
//  Copyright © 2016 Daniel Grovenstein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var et: UITextField!
    @IBOutlet var descriptionTv: UITextView!
    @IBOutlet var temperatureTv: UITextView!
    @IBOutlet var humidityTv: UITextView!
    @IBOutlet var windSpeedTv: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getWeather(sender: AnyObject) {
        let city = et.text!
        let key = "ccfd47de0d2c7d32710250bfc8eec407"
        let url = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&APPID=" + key
        
        let nsurl = NSURL(string: url)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
          let task = session.dataTaskWithURL(nsurl!) {
            (data, result, error)->Void in
            
            let mdata = NSMutableData(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(mdata, options: .AllowFragments)
                    if let weatherArray = json["weather"] as? [[String: AnyObject]] {
                        for weatherObject in weatherArray {
                        if let description = weatherObject["description"] as? String {
                        self.descriptionTv.text = description
                        }
                    }
                    }
                    let mainObject = json["main"] as? [String: AnyObject]
                    let temperature = mainObject!["temp"] as? Double
                    let celsius = temperature! - 273.0
                    let fahrenheit = Double(round(((celsius * 9.0 / 5.0) + 32.0))*100.0)/100.0
                    self.temperatureTv.text = String(fahrenheit) + " °F"
                    
                    let humidity = mainObject!["humidity"] as? Int
                    self.humidityTv.text = String(humidity!) + "%"
                    
                    let windObject = json["wind"] as? [String: AnyObject]
                    let windSpeed = windObject!["speed"] as? Double
                    self.windSpeedTv.text = String(windSpeed!) + " mph"
                }catch {
                }
            }
        }
        task.resume()
    }
}


