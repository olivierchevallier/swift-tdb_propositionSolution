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
    var distance: Double
    var route: Route?
    
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
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: Route) {
        self.distance = route.distance
        self.route = route
        super.init(origin: origin, destination: destination, transport: "Voiture")
    }
    
    //MARK: - Private methods
    
    //MARK: - Public methods
}
