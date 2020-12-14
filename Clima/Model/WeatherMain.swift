//
//  WeatherManager.swift
//  Clima
//
//  Created by Ben Wen on 10/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func didUpdateWeather(weatherModel: WeatherModel)
    func didFailFetchData (_ error: Error)
    func didFailDecodeData (_ error: Error )
}

struct WeatherManager {
    let basicUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=7a855b4a34a2956cfe33baa2c2ba5cef"
    var temp: String?
    var weatherCondition: String?
    var delegate: WeatherDelegate?
    
    func setupCity(city:String){
        let uri = "\(basicUrl)&q=\(city)"
        performFetch(urlString: uri)
    }
    func setupLatLon(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let uri = "\(basicUrl)&lat=\(latitude)&lon=\(longitude)"
        performFetch(urlString: uri)
    }
    func performFetch(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailFetchData(error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String (data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(data: safeData){
                        delegate?.didUpdateWeather (weatherModel: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (data: Data)->WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode (WeatherData.self, from: data)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            return WeatherModel (id: id, name: name, temp: temp)
        }catch{
            delegate?.didFailDecodeData(error)
            return nil
        }
     }

    func getTemp() ->String{
        return temp ?? "0c"
    }
    func getWeatherCondition() ->String{
        return weatherCondition  ?? "Sunny Day"
    }
}

