//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// WalkItinerary :
//
// Créé par : Olivier Chevallier le 10.10.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxDirections

class WalkItinerary: Itinerary {
    
    //MARK: - Properties
    //MARK: Mutable
    var distance: Double
    var route: Route?
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: Route) {
        self.distance = route.distance
        self.route = route
        super.init(origin: origin, destination: destination, transport: "Marche")
        self.emissions = 0
        self.cost = 0
        self.expectedTime = Int(self.route!.expectedTravelTime) / 60
    }
}
