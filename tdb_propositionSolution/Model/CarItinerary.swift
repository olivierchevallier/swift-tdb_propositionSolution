//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarItinerary :
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class CarItinerary: Itinerary {
    
    //MARK: - Properties
    //MARK: Var
    
    //MARK: Computed
    override var emissions: Double {
        get {
            return self.route!.distance * 137.8 / 1000
        }
    }
    override var cost: Double {
        get {
            return self.route!.distance * 0.8 / 1000
        }
    }
    override var expectedTime: Int {
        get {
            return Int(self.route!.expectedTravelTime) / 60
        }
    }
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Voiture")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateRoute(completion: @escaping(Error?) -> Void){
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
}
