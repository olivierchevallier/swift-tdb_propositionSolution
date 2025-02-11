//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ItinerariesList : Classe définissant les prporiétés et fonctions communes aux listes d'itinéraires tout type de transport confondus.
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import Foundation
import Mapbox

class ItinerariesList {
    //MARK: - Properties
    //MARK: Immutable
    internal let dispatchGroup = DispatchGroup()
    
    //MARK: Mutable
    var itineraries = [Itinerary]()
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var transport: String
    
    //MARK: Computed
    var avgEmissions: Double {
        get {
            return computeAvgEmissions()
        }
    }
    var expectedTime: Int {
        get {
            return getExpectedTime()
        }
    }
    var count: Int {
        get {
            return itineraries.count
        }
    }
    
    
    //MARK: - Initializer
    init() {
        self.origin = CLLocationCoordinate2D()
        self.destination = CLLocationCoordinate2D()
        self.transport = ""
    }
    
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
    /// Calcul l'itinéraire, cette méthode doit être réécrite et est définie ici  pour permettre un traitement polymorphe
    internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        assert(false, "This method must be overriden by the subclass")
    }
    
    /// Cette fonction permet de calculer la moyenne des émissions des itinéraires de la liste
    private func computeAvgEmissions() -> Double {
        var totalEmissions = 0.0
        for itinerary in itineraries {
            totalEmissions += itinerary.emissions
        }
        return totalEmissions / Double(itineraries.count)
    }
    
    private func getExpectedTime() -> Int {
        let count = itineraries.count
        if count < 1 { return 0 }
        else {
            var total = 0
            for itinerary in itineraries {
                total += itinerary.expectedTime
            }
            return total
        }
    }
    
    //MARK: - Public methods
    /// Permet d'accéder aux différente valeurs calculées dépendante du fait que l'itinéraire ait fini de se calculer
    func itinerariesCalculated(completionHandler: @escaping() -> Void){
        dispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
