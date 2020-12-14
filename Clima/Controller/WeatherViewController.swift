import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.setupLatLon(latitude: lat, longitude: lon)
        }
        print("this is test the location manager")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        weatherManager.setupCity(city: searchTextField.text!)
        print(searchTextField.text!)
        textField.text = ""
    }
}

//MARK: - WeatherDelegate

extension WeatherViewController: WeatherDelegate {
    
    func didUpdateWeather (weatherModel: WeatherModel){
        //cityLabel.text = weatherModel.name
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.tempString
            self.cityLabel.text = weatherModel.name
            self.conditionImageView.image = UIImage(systemName: weatherModel.condition)
        }
        print (weatherModel.condition)
    }
    func didFailFetchData (_ error: Error){
        print (error)
    }
    
    func didFailDecodeData (_ error: Error){
        print (error)
    }
}

