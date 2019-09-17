//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// Itinerary : Modèle représentant un itinéraire
//
// Créé par : Olivier Chevallier le 16.09.19
//--------------------------------------------------

import Foundation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class Itinerary {
    
    //MARK: - Properties
    //MARK: Var
    var route: Route? //sera spécifique à l'itinéraire pour voiture
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    
    //MARK: Const
    private let dispatchGroup = DispatchGroup()
    
    //MARK: Computed
    var emissions: Double {
        get {
            return self.route!.distance * 137.8 / 1000
        }
    }
    var cost: Double {
        get {
            return self.route!.distance * 0.8 / 1000
        }
    }
    var expectedTime: Int {
        get {
            return Int(self.route!.expectedTravelTime) / 60
        }
    }
    
    
    //MARK: - Initializer
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, transport: String) {
        self.origin = origin
        self.destination = destination
        self.transport = transport
        calculateRoute(completion: { (route, error) in
            if error != nil {
                print("Error getting route")
            }
        })
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire 
    private func calculateRoute(completion: @escaping(Route?, Error?) -> Void){
        dispatchGroup.enter()
        let originWaypoint = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Départ")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Arrivée")
        let options = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            self.route = routes?.first
            self.dispatchGroup.leave()
        })
    }
    
    //MARK: - Public methods
    /// Permet d'accéder aux différente valeurs calculées dépendante du fait que l'itinéraire ait fini de se calculer
    func routeCalculated(completionHandler: @escaping() -> Void){
        dispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
