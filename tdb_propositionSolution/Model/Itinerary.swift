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
    var route: Route?
    var cost = 0
    var emmissions = 0
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    
    //MARK: Const
    private let dispatchGroup = DispatchGroup()
    
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
    /// Permet d'accéder au temps éstimé pour un itinéraire. La valeur est accessible au travers d'un completionHandler
    func expectedTime(completionHandler: @escaping(Int) -> Void){
        dispatchGroup.notify(queue: .main) {
            let interval = Int(self.route!.expectedTravelTime)
            completionHandler(interval / 60)
        }
    }
    
    
}
