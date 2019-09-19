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
    var route: Route? //sera spécifique à l'itinéraire pour voiture
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    
    //MARK: Const
    internal let dispatchGroup = DispatchGroup()
    
    //MARK: Computed
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
        calculateRoute(completion: { (error) in
            if error != nil {
                print("Error getting route")
            }
        })
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire 
    internal func calculateRoute(completion: @escaping(Error?) -> Void){
        assert(false, "This method must be overriden by the subclass")
    }
    
    //MARK: - Public methods
    /// Permet d'accéder aux différente valeurs calculées dépendante du fait que l'itinéraire ait fini de se calculer
    func routeCalculated(completionHandler: @escaping() -> Void){
        dispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
