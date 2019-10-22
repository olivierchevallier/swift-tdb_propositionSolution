//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// MapViewController : Contrôleur de la vue affichant la carte
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
    //MARK: Immutable
    let defaults = UserDefaults.standard
    
    //MARK: Mutable
    var mapView: NavigationMapView!
    var str_userLocation: String?
    var destination: Location?
    var itinerariesVC: ItinerariesViewController?
    
    //MARK: Controls
    @IBOutlet var txt_search: UITextField!
    
    //MARK: -
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        // Décommenter la ligne ci-dessous pour faire apparaître l'écran de config à chaque fois
        defaults.set(false, forKey: "configured")
        if defaults.bool(forKey: "configured") == false {
            performSegue(withIdentifier: "ConfigurationSegue", sender: self)
        }
        
        guard let itinerariesController = children.first as? ItinerariesViewController else {
            fatalError("Error while getting itineraries child view")
        }
        itinerariesVC = itinerariesController
        itinerariesVC!.view.isHidden = true
        itinerariesVC!.view.superview!.isUserInteractionEnabled = false
        
        setupMap()
        
        _ = TransitLineColorsList.getInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Actions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adaptMapStyle()
    }
    
    @objc func didLongPressMap(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let destination = Location(name: "Lieu pointé sur la carte", coordinate: coordinate)
        updateDestination(destination: destination)
    }
    
    //MARK: - Private methods
    private func setupMap() {
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMap(_:)))
        mapView.addGestureRecognizer(longPress)
        
        mapView.delegate = self
        txt_search.delegate = self
        
        adaptMapStyle()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true) {
            
        }
        mapView.compassViewPosition = .topLeft
        mapView.compassViewMargins = .init(x: txt_search.frame.minX + 10, y: txt_search.frame.maxY + 20)
    }
    
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
        //self.routes.destination = destination!.name
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
            let styleURL = URL(string: "mapbox://styles/olivierchevallier/ck0zcm1s40dcj1cmn87ye8wlc")
            mapView.styleURL = styleURL
        default:
            mapView.styleURL = MGLStyle.streetsStyleURL
        }
    }
    
    /// Supprime toutes les présentes sur la carte
    private func clearAnnotations(){
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
    }
    
    /// Met à jour les itinéraires pour correspondre à la destination
    private func showItineraries(){
        itinerariesVC!.view.isHidden = false
        itinerariesVC!.view.superview!.isUserInteractionEnabled = true
        itinerariesVC!.userLocation = self.mapView!.userLocation?.coordinate
        itinerariesVC!.destination = self.destination!
        itinerariesVC!.mapView = mapView
    }
    
    /// Change la destination et met à jour la vue en conséquence
    private func updateDestination(destination: Location) {
        self.destination = destination
        mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        clearAnnotations()
        showDestination()
        showItineraries()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        str_userLocation = getFormatedUserLocation()
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "showResults", sender: nil)
    }
    
    //MARK: - MGLMapViewDelegate
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if annotation as? ParkingAnnotation == nil {
            return nil
        }
        
        // For better performance, always try to reuse existing annotations.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "parking")
        
        // If there is no reusable annotation image available, initialize a new one.
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: UIImage(named: "parking")!, reuseIdentifier: "parking")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let destinationVC = segue.destination as? LocationTableViewController {
                destinationVC.userLocation = self.mapView.userLocation!.coordinate
                destinationVC.str_userLocation = self.str_userLocation
            }
        }
    }
    
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? LocationTableViewController, let destination = sourceViewController.destination {
            updateDestination(destination: destination)
        }
    }
    
}

class ParkingAnnotation: MGLPointAnnotation {
    
}
