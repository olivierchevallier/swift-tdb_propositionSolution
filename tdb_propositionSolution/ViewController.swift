//
//  ViewController.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 04.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import os.log

class ViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate {

    //MARK: Properties
    var mapView: NavigationMapView!
    @IBOutlet var txt_search: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.delegate = self
        txt_search.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true) {
            
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch(txt: txt_search.text!)
        performSegue(withIdentifier: "showResults", sender: nil)
        return true
    }
    
    //MARK: Private methods
    private func performSearch(txt: String){
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as! String
        let stringURL = "https://api.mapbox.com/geocoding/v5/mapbox.places/" + txt + ".json?proximity=" + getFormatedUserLocation() + "&access_token=" + accessToken
        
        let session = URLSession.shared
        let url = URL(string: stringURL)!
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            if error != nil || data == nil {
                os_log("Client error", log: OSLog.default, type: .debug)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                os_log("Server error", log: OSLog.default, type: .debug)
                return
            }
            
            guard let mime = response.mimeType, mime == "application/vnd.geo+json" else {
                print("MIME type : " + response.mimeType!)
                os_log("Wrong MIME type", log: OSLog.default, type: .debug)
                return
            }
            
            do {
                // Prendre l'objet retourné par jsonObject, le transformer en une collection d'objets Location et afficher cette collection dans le vue modale
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                os_log("JSON error", log: OSLog.default, type: .debug)
            }
        })
        task.resume()
    }
    
    private func getFormatedUserLocation() -> String{
        let userLocation = mapView.userLocation!
        let latitude = String(format: "%10f", (userLocation.location?.coordinate.latitude)!)
        let longitude = String(format: "%10f", (userLocation.location?.coordinate.longitude)!)
        let stringFormatedLocation = longitude + "," + latitude
        return stringFormatedLocation.replacingOccurrences(of: " ", with: "")
    }
    
}

