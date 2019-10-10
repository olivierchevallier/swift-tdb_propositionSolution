//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// WalkItinerariesList :
//
// Créé par : Olivier Chevallier le 10.10.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxCoreNavigation
import MapboxDirections

class WalkItinerariesList: ItinerariesList {
    //MARK: - Properties
    //MARK: Immutable
    let walkSpeed: Double
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, walkSpeed: Double) {
        self.walkSpeed = walkSpeed / 3.6
        super.init(origin: origin, destination: destination, transport: "Marche")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        let originWaypoint = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Départ")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Arrivée")
        let options = RouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .walking)
        options.speed = walkSpeed
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            for route in routes! {
                self.itineraries.append(WalkItinerary(origin: self.origin, destination: self.destination, route: route))
            }
            self.dispatchGroup.leave()
        })
    }
}
