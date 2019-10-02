//
//  ViewController.swift
//  WeatherApp
//
//  Created by William Tomas on 01/10/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //on s'abonne à l'appuie du bouton terminé sur le clavier virtuel pour lancer la recherche
        //pas de weak self car seul ViewController
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
        .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
//        //on s'abonne au champs de saisie de texte, chaque ajout de lettre produit un message dans la console
//        //on n'utilise pas weak self ici car nous avons qu'un seul ViewController
//        self.cityNameTextField.rx.value
//            .subscribe(onNext: { city in
//                //print($0)
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    } else {
//                        self.fetchWeather(by: city)
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city: String) {
        //prends en compte le fait q'une ville peut avoir des espaces
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL.urlForWeatherAPI(city: cityEncoded) else {
                return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance) //pour être async
            .catchErrorJustReturn(WeatherResult.empty) //ce qui est retourné tant que le nom de la ville n'est pas fini de taper
//            .subscribe(onNext: { result in
//                let weather = result.main
//                self.displayWeather(weather)
//            }).disposed(by: disposeBag)
        
        //permet de directement relier la valeur retournée à notre UI
        search.map{ "\($0.main.temp) ℃" }
            .bind(to:self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map{ "\($0.main.humidity) 💧" }
            .bind(to:self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather { //si il y a de la donnée
            self.temperatureLabel.text = "\(weather.temp) ℃"
            self.humidityLabel.text = "\(weather.humidity) 💧"
        } else {
            self.temperatureLabel.text = "Pas de température 🧐"
            self.humidityLabel.text = "Pas de données 🤷‍♂️"
        }
            
    }


}

