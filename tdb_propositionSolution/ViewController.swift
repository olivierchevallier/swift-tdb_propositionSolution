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

class ViewController: UIViewController, MGLMapViewDelegate {

    //MARK: Properties
    var mapView: NavigationMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true) {
            
        }
    }
}

