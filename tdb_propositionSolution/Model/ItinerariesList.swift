//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ItinerariesList :
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import Foundation
import Mapbox

class ItinerariesList {
    //MARK: - Properties
    //MARK: Var
    var itineraries = [Itinerary]()
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    
    //MARK: Const
    internal let dispatchGroup = DispatchGroup()
    
    //MARK: - Initializer
    //MARK: - Initializer
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, transport: String) {
        self.origin = origin
        self.destination = destination
        self.transport = transport
        self.calculateItineraries(completion: { (error) in
            if error != nil {
                print("Error getting itineraries")
            }
        })
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        assert(false, "This method must be overriden by the subclass")
    }
    
    //MARK: - Public methods
    /// Permet d'accéder aux différente valeurs calculées dépendante du fait que l'itinéraire ait fini de se calculer
    func itinerariesCalculated(completionHandler: @escaping() -> Void){
        dispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
