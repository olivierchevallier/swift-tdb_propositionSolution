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

class MapViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    var mapView: NavigationMapView!
    var searchTxt: String?
    var userLocationStr: String?
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
    
    //MARK: Actions
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userLocationStr = getFormatedUserLocation()
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "showResults", sender: nil)
    }
    
    //MARK: Private methods
    private func getFormatedUserLocation() -> String{
        let userLocation = mapView.userLocation!
        let latitude = String(format: "%10f", (userLocation.location?.coordinate.latitude)!)
        let longitude = String(format: "%10f", (userLocation.location?.coordinate.longitude)!)
        let stringFormatedLocation = longitude + "," + latitude
        return stringFormatedLocation.replacingOccurrences(of: " ", with: "")
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            print(segue.destination)
            if let destinationVC = segue.destination as? LocationTableViewController {
                //destinationVC.searchTxt = self.searchTxt
                destinationVC.userLocationStr = self.userLocationStr
            }
        }
    }
    
}

