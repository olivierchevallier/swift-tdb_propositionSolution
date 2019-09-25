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
    //MARK: Mutable
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    var emissions: Double {
        get {
            return 0
        }
    }
    var cost: Double {
        get {
            return 0
        }
    }
    var expectedTime: Int {
        get {
            return 0
        }
    }
    
    //MARK: - Initializer
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, transport: String) {
        self.origin = origin
        self.destination = destination
        self.transport = transport
    }
}
