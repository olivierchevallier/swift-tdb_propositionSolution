//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarItinerariesList : Classe permettant d'obtenir la liste des itinéraires en voiture pour un lieu de départ et une destination donnés à l'initialisation de l'instance.
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxCoreNavigation
import MapboxDirections


class CarItinerariesList: ItinerariesList {
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Voiture")
    }
    
    //MARK: - Private methods
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        let originWaypoint = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Départ")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Arrivée")
        let options = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            for route in routes! {
                self.itineraries.append(CarItinerary(origin: self.origin, destination: self.destination, route: route))
            }
            self.dispatchGroup.leave()
        })
    }
}
