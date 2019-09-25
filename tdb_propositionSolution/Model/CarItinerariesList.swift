//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarItinerariesList :
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections


class CarItinerariesList: ItinerariesList {
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Voiture")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        let originWaypoint = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Départ")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Arrivée")
        let options = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            //TODO: Créer la liste des itinéraires ici
            for route in routes! {
                self.itineraries.append(CarItinerary(origin: self.origin, destination: self.destination, route: route))
            }
            self.dispatchGroup.leave()
        })
    }
}
