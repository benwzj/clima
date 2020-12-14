//
//  WeatherManager.swift
//  Clima
//
//  Created by Ben Wen on 10/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let basicUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=7a855b4a34a2956cfe33baa2c2ba5cef"
    var temp: String?
    var weatherCondition: String?
    
    func setupCity(city:String){
        // send URL request, async wait for response...
        let uri = "\(basicUrl)&q=\(city)"
        performFetch(urlString: uri)
        // decordJSON
        // setup weather data, e.g. Templeture, sunny or rain,
    }
    func performFetch(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String (data: safeData, encoding: .utf8)
                    parseJSON(data: dataString)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (data: String?) {
        print (data ?? "Sorry can't read the data!")
    }

    func getTemp() ->String{
        return temp ?? "0c"
    }
    func getWeatherCondition() ->String{
        return weatherCondition  ?? "Sunny Day"
    }
}

