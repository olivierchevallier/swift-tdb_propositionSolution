//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// MapViewController : Controleur de la vue affichant la carte
//
// Créé par : Olivier Chevallier le 04.09.19
//--------------------------------------------------

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import os.log

class MapViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    var mapView: NavigationMapView!
    var userLocationStr: String?
    var destinationLocation: Location?
    var carDirectionsRoute: Route?
    var itineraries = [Itinerary]()
    @IBOutlet var txt_search: UITextField!
    @IBOutlet var routes: RoutesControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.delegate = self
        txt_search.delegate = self
        
        adaptMapStyle()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true) {
            
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? LocationTableViewController, let destinationLocation = sourceViewController.destinationLocation {
            self.destinationLocation = destinationLocation
            mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            clearAnnotations()
            showDestination()
            updateItineraries()
            routes.isHidden = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        adaptMapStyle()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userLocationStr = getFormatedUserLocation()
        textField.resignFirstResponder()
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
    
    private func calculateCarRoute(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoordinate, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoordinate, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            self.carDirectionsRoute = routes?.first
            
            self.previewZoom(sw: originCoordinate, ne: destinationCoordinate)
        })
    }
    
    private func showDestination() {
        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation!.coordinate
        previewZoom(sw: mapView.userLocation!.coordinate, ne: destinationLocation!.coordinate)
        self.mapView.addAnnotation(destinationAnnotation)
        self.routes.destinationName = destinationLocation!.name
    }
    
    private func previewZoom(sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) {
        let coordinatesBounds = MGLCoordinateBounds(sw: sw, ne: ne)
        let insets = UIEdgeInsets(top: 100, left: 50, bottom: 300, right: 50)
        let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinatesBounds, edgePadding: insets)
        self.mapView.setCamera(routeCam, animated: true)
    }
    
    private func adaptMapStyle() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        
        switch userInterfaceStyle {
        case .dark :
            mapView.styleURL = MGLStyle.darkStyleURL
        default:
            mapView.styleURL = MGLStyle.lightStyleURL
        }
    }
    
    private func clearAnnotations(){
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
    }
    
    private func updateItineraries(){
        if itineraries.count > 0 {
            itineraries.removeAll()
        }
        itineraries.append(Itinerary(origin: mapView.userLocation!.coordinate, destination: destinationLocation!.coordinate, transport: "Voiture"))
        routes.intineraries = itineraries
    }
    
    func startNavigation(){
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let destinationVC = segue.destination as? LocationTableViewController {
                destinationVC.userLocationStr = self.userLocationStr
            }
        }
    }
    
}

