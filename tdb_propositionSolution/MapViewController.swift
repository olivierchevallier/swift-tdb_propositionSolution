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

    //MARK: - Properties
    //MARK: Var
    var mapView: NavigationMapView!
    var str_userLocation: String?
    var destination: Location?
    var itineraries = [Itinerary]()
    
    //MARK: Controls
    @IBOutlet var txt_search: UITextField!
    @IBOutlet var routes: RoutesControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the map
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
    
    //MARK: - Actions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adaptMapStyle()
    }
    
    //MARK: - Private methods
    /// Retourne la localisation de l'utilisateur sous forme d'une chaine de caratères respectant le format "longitude,latitude"
    private func getFormatedUserLocation() -> String{
        let userLocation = mapView.userLocation!
        let latitude = String(format: "%10f", (userLocation.location?.coordinate.latitude)!)
        let longitude = String(format: "%10f", (userLocation.location?.coordinate.longitude)!)
        let stringFormatedLocation = longitude + "," + latitude
        return stringFormatedLocation.replacingOccurrences(of: " ", with: "")
    }
    
    /// Met à jour la vue pour y afficher la destination (annotation sur la carte + affichage du nom de la destination)
    private func showDestination() {
        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = destination!.coordinate
        previewZoom(sw: mapView.userLocation!.coordinate, ne: destination!.coordinate)
        self.mapView.addAnnotation(destinationAnnotation)
        self.routes.destinationName = destination!.name
    }
    
    /// Effectue un dézoom sur la carte pour y afficher deux coordonnées à la fois
    private func previewZoom(sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) {
        let coordinatesBounds = MGLCoordinateBounds(sw: sw, ne: ne)
        let insets = UIEdgeInsets(top: 100, left: 50, bottom: 300, right: 50)
        let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinatesBounds, edgePadding: insets)
        self.mapView.setCamera(routeCam, animated: true)
    }
    
    /// Adapte le style de la carte pour le mode sombre et pour le mode clair
    private func adaptMapStyle() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        
        switch userInterfaceStyle {
        case .dark :
            mapView.styleURL = MGLStyle.darkStyleURL
        default:
            mapView.styleURL = MGLStyle.lightStyleURL
        }
    }
    
    /// Supprime toutes les présentes sur la carte
    private func clearAnnotations(){
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
    }
    
    /// Met à jour les itinéraires pour correspondre à la destination
    private func updateItineraries(){
        if itineraries.count > 0 {
            itineraries.removeAll()
        }
        itineraries.append(Itinerary(origin: mapView.userLocation!.coordinate, destination: destination!.coordinate, transport: "Voiture"))
        routes.intineraries = itineraries
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        str_userLocation = getFormatedUserLocation()
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "showResults", sender: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let destinationVC = segue.destination as? LocationTableViewController {
                destinationVC.str_userLocation = self.str_userLocation
            }
        }
    }
    
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? LocationTableViewController, let destination = sourceViewController.destination {
            self.destination = destination
            mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            clearAnnotations()
            showDestination()
            updateItineraries()
            routes.isHidden = false
        }
    }
    
}

