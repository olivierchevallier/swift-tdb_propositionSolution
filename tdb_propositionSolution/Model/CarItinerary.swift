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
    
    //MARK: - Initializers    
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: Route) {
        self.distance = route.distance
        self.route = route
        super.init(origin: origin, destination: destination, transport: "Voiture")
        self.emissions = self.route!.distance * 197.57 / 1000
        self.cost = self.route!.distance * 0.8 / 1000
        self.expectedTime = Int(self.route!.expectedTravelTime) / 60
    }
}
