//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItinerary :
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation
import Mapbox

class TransitItinerary: Itinerary {
    
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
        super.init(origin: origin, destination: destination, transport: "Transports publics")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateRoute(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        let originStr = getStrFormatedLocation(location: origin)
        let destinationStr = getStrFormatedLocation(location: destination)
        let url = URL(string: TransitWebService.getRoute(from: originStr, to: destinationStr))
        print("URL :" + url!.absoluteString)
        Network.executeHTTPGet(url: url!, dataCompletionHandler: { data in
            do {
                let connections = try JSONDecoder().decode(TransitWebService.Connections.self, from: data!)
                for connection in connections.connections! {
                    print(connection)
                }
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
