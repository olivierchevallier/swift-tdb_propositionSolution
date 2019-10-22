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
    let walkColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
    let carColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
    let multiColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7)
    
    //MARK: Mutable
    var mapView: NavigationMapView!
    var carItinerary: CarItinerary?
    var transitItineraries = [TransitItinerary]()
    var transitItinerariesList: TransitItinerariesList?
    var multimodalItineraries: MultimodalItinerariesList?
    var multimodalItinerary: MultimodalItinerary?
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
        let route = self.carItinerary!.route!
        let navigationVC = NavigationViewController(for: route)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_goMixTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: multimodalItinerary!.carItinerary.route!)
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
            print("route : \(self.carItinerary!.route!)")
            self.btn_goCar.isLoading(false)
            let emissions = round(self.carItinerary!.emissions * 100) / 100
            self.lbl_carTime.text = "\(self.carItinerary!.timeToDestination) min. - \(emissions)g. de CO2"
            self.drawRoute(route: self.carItinerary!.route!, color: self.carColor, identifier: "car")
        }
    }
    
    private func getTransitItineraries() {
        btn_goTransit.isLoading(true)
        lbl_transitTime.text = "Chargement..."
        transitItineraries = [TransitItinerary]()
        transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        transitItinerariesList!.itinerariesCalculated {
            for transitIntnerary in self.transitItinerariesList!.itineraries {
                self.transitItineraries.append(transitIntnerary as! TransitItinerary)
            }
            self.btn_goTransit.isLoading(false)
            let avgEmissions = round(self.transitItinerariesList!.avgEmissions)
            self.lbl_transitTime.text = "\(self.transitItineraries.first!.timeToDestination) min. - \(avgEmissions)g. de CO2"
        }
    }
    
    private func getMultimodalItineraries() {
        btn_goMix.isLoading(true)
        lbl_mixTime.text = "Chargement..."
        lbl_mixVia.text = ""
        multimodalItineraries = MultimodalItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        multimodalItineraries!.itinerariesCalculated {
            self.multimodalItinerary = self.multimodalItineraries!.getMosEfficient(transitItineraries: self.transitItinerariesList!, carItinerary: self.carItinerary!)
            let emissions = round(self.multimodalItinerary!.emissions)
            self.lbl_mixTime.text = "\(self.multimodalItinerary!.timeToDestination) min. - \(emissions)g. de CO2"
            self.showParking()
            self.drawRoute(route: self.multimodalItinerary!.carItinerary.route!, color: self.multiColor, identifier: "multimodal")
            self.btn_goMix.isLoading(false)
        }
    }
    
    private func getWalkItinerary() {
        lbl_walkTime.text = "Chargement..."
        let walkItinerariesList = WalkItinerariesList(origin:userLocation!, destination: destination!.coordinate, walkSpeed: defaults.double(forKey: "walkSpeed"))
        walkItinerariesList.itinerariesCalculated {
            let walkItinerary = walkItinerariesList.itineraries.first! as? WalkItinerary
            let emissions = round(walkItinerary!.emissions)
            self.lbl_walkTime.text = "\(walkItinerary!.timeToDestination) min. - \(emissions)g. de CO2"
            self.drawRoute(route: walkItinerary!.route!, color: self.walkColor, identifier: "walk")
        }
    }
    
    private func showParking() {
        let destinationAnnotation = ParkingAnnotation()
        destinationAnnotation.coordinate = multimodalItinerary!.parking.location
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
                itineraries = multimodalItinerary!.transitItinerariesList.itineraries
            }
            destinationVC.itineraries = (itineraries as? [TransitItinerary])!
        }
    }
}
