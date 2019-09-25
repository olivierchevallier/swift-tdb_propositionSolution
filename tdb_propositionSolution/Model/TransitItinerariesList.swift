//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItinerariesList : Classe permettant d'obtenir la liste des itinéraires en transports publics pour un lieu de départ et une destination donnés à l'initialisation de l'instance. 
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import Foundation
import CoreLocation

class TransitItinerariesList: ItinerariesList {    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Transports publics")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        let originStr = getStrFormatedLocation(location: origin)
        let destinationStr = getStrFormatedLocation(location: destination)
        let url = URL(string: TransitWebService.getRoute(from: originStr, to: destinationStr))
        Network.executeHTTPGet(url: url!, dataCompletionHandler: { data in
            do {
                let connections = try JSONDecoder().decode(TransitWebService.Connections.self, from: data!)
                for connection in connections.connections! {
                    let transitItinerary = TransitItinerary(origin: self.origin, destination: self.destination, connection: connection)
                    self.itineraries.append(transitItinerary)
                }
                self.dispatchGroup.leave()
            } catch {
                print("JSON error : \(error)")
            }
        })
    }
    
    private func getStrFormatedLocation(location: CLLocationCoordinate2D) -> String {
        let latitude = String(format: "%10f", (location.latitude))
        let longitude = String(format: "%10f", (location.longitude))
        let strFormatedLocation = longitude + "," + latitude
        return strFormatedLocation.replacingOccurrences(of: " ", with: "")
    }
}
