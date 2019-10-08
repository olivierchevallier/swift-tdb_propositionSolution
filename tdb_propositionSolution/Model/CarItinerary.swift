//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarItinerary : Class modélisant un itinéraire en voiture
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
    //MARK: Mutable
    var distance: Double
    var route: Route?
    override var emissions: Double {
        get {
            // Selon mobitool.ch
            return self.route!.distance * 197.57 / 1000
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
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: Route) {
        self.distance = route.distance
        self.route = route
        super.init(origin: origin, destination: destination, transport: "Voiture")
    }
}
