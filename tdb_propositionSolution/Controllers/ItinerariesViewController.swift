//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ItinerariesViewController : Contrôleur de la vue affichant les différentes options d'itinéraires disponibles (voiture, TP, Mix)
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class ItinerariesViewController: UIViewController {
    //MARK: - Properties
    //MARK: Immutable
    let defaults = UserDefaults.standard
    let multimodalMargin = 10
    
    //MARK: Mutable
    var mapView: NavigationMapView!
    var carItinerary: CarItinerary?
    var transitItineraries = [TransitItinerary]()
    var multimodalItineraries: MultimodalItinerariesList?
    var multimodalItinerary = ItinerariesList()
    var userLocation: CLLocationCoordinate2D?
    
    //MARK: Observed
    var destination:Location? {
        didSet {
            lbl_destination.text = destination!.name
            getItineraries()
        }
    }
    
    //MARK: Controls
    @IBOutlet var lbl_destination: UILabel!
    @IBOutlet var btn_goCar: GoButtonControl!
    @IBOutlet var lbl_carTime: UILabel!
    @IBOutlet var btn_goTransit: GoButtonControl!
    @IBOutlet var lbl_transitTime: UILabel!
    @IBOutlet var btn_goMix: GoButtonControl!
    @IBOutlet var lbl_mixTime: UILabel!
    @IBOutlet var lbl_mixVia: UILabel!
    @IBOutlet var lbl_walkTime: UILabel!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
    }
    
    //MARK: - Actions
    @IBAction func btn_goCarTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: carItinerary!.route!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_goMixTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: multimodalItineraries!.carItinerary!.route!)
        performSegue(withIdentifier: "showMultimodalItineraries", sender: self)
        present(navigationVC, animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    private func getItineraries() {
        getCarItinerary()
        getTransitItineraries()
        getMultimodalItineraries()
        getWalkItinerary()
    }
    
    private func getCarItinerary() {
        btn_goCar.isLoading(true)
        lbl_carTime.text = "Chargement..."
        let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: destination!.coordinate)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as? CarItinerary
            self.btn_goCar.isLoading(false)
            let emissions = round(self.carItinerary!.emissions*100)/100
            self.lbl_carTime.text = "\(self.carItinerary!.timeToDestination) min. - \(emissions)g. de CO2"
            self.drawRoute(route: self.carItinerary!.route!, color: UIColor.red, identifier: "car")
        }
    }
    
    private func getTransitItineraries() {
        btn_goTransit.isLoading(true)
        lbl_transitTime.text = "Chargement..."
        transitItineraries = [TransitItinerary]()
        let transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        transitItinerariesList.itinerariesCalculated {
            for transitIntnerary in transitItinerariesList.itineraries {
                self.transitItineraries.append(transitIntnerary as! TransitItinerary)
            }
            self.btn_goTransit.isLoading(false)
            let avgEmissions = round(transitItinerariesList.avgEmissions*100)/100
            self.lbl_transitTime.text = "\(self.transitItineraries.first!.timeToDestination) min. - \(avgEmissions)g. de CO2"
        }
    }
    
    private func getMultimodalItineraries() {
        btn_goMix.isLoading(true)
        lbl_mixTime.text = "Chargement..."
        lbl_mixVia.text = ""
        multimodalItineraries = MultimodalItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        multimodalItineraries!.itinerariesCalculated {
            self.multimodalItineraries!.parking!.getDispo(completion: { available in
                let nombrePlaceStr = available >= 0 ? "(\(available)  places)" : "(disp. inconnue)"
                self.lbl_mixVia.text = "via \(self.multimodalItineraries!.parking!.nom) \(nombrePlaceStr)"
            })
            let emissions = round(self.multimodalItineraries!.emissions*100)/100
            self.lbl_mixTime.text = "\(self.multimodalItineraries!.timeToDestination) min. - \(emissions)g. de CO2"
            self.drawRoute(route: self.multimodalItineraries!.carItinerary!.route!, color: UIColor.blue, identifier: "multimodal")
            self.showParking()
            self.btn_goMix.isLoading(false)
        }
    }
    
    private func getWalkItinerary() {
        lbl_walkTime.text = "Chargement..."
        let walkItinerariesList = WalkItinerariesList(origin:userLocation!, destination: destination!.coordinate, walkSpeed: defaults.double(forKey: "walkSpeed"))
        walkItinerariesList.itinerariesCalculated {
            let walkItinerary = walkItinerariesList.itineraries.first! as? WalkItinerary
            let emissions = round(walkItinerary!.emissions*100)/100
            self.lbl_walkTime.text = "\(walkItinerary!.timeToDestination) min. - \(emissions)g. de CO2"
            self.drawRoute(route: walkItinerary!.route!, color: UIColor.green, identifier: "walk")
        }
    }
    
    private func showParking() {
        let destinationAnnotation = ParkingAnnotation()
        destinationAnnotation.coordinate = multimodalItineraries!.parking!.location
        mapView.addAnnotation(destinationAnnotation)
    }
    
    private func drawRoute(route: Route, color: UIColor, identifier: String) {
        guard route.coordinateCount > 0 else { return }
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        if let source = mapView.style?.source(withIdentifier: identifier + "-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: identifier + "-source", features: [polyline], options: nil)
            
            let lineStyle = MGLLineStyleLayer(identifier: identifier + "-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: color)
            lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TransitItinerariesTableViewController {
            var itineraries = [Itinerary]()
            if segue.identifier == "showTransitItineraries" {
                itineraries = transitItineraries
                destinationVC.destination = self.destination!.coordinate
                destinationVC.userLocation = userLocation
            } else if segue.identifier == "showMultimodalItineraries" {
                itineraries = multimodalItineraries!.transitItineraries!.itineraries
            }
            destinationVC.itineraries = (itineraries as? [TransitItinerary])!
        }
    }
}
