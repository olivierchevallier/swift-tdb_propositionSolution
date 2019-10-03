//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// Parking :
//
// Créé par : Olivier Chevallier le 26.09.19
//--------------------------------------------------


import Foundation
import CoreLocation


class Parking {
    //MARK: - Properties
    //MARK: Immutable
    let nom: String
    let location: CLLocationCoordinate2D
    let realTime: Bool
    let mn95Coordinates: [Double] //[east,north]
    
    //MARK: Initializer
    init(nom: String, east: Double, north: Double, realTime: String, mn95Coordinates: [Double]) {
        let coordinates = Parking.mn95_to_wgs84(e: east, n: north)
        self.nom = nom
        location = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.realTime = realTime.lowercased() == "vrai"
        self.mn95Coordinates = mn95Coordinates
    }
    
    //MARK: Private methods
    private static func mn95_to_wgs84(e: Double, n: Double) -> (longitude: Double, latitude: Double){
        let civilCoordinates = mn95_to_civil(e: e, n: n)
        var longitude = 2.6779094
            + 4.728982 * civilCoordinates.e
            + 0.791484 * civilCoordinates.e * civilCoordinates.n
            + 0.1306 * civilCoordinates.e * pow(civilCoordinates.n, 2)
            - 0.0436 * pow(civilCoordinates.e, 3)
        var latitude = 16.9023892
            + 3.238272 * civilCoordinates.n
            - 0.270978 * pow(civilCoordinates.e, 2)
            - 0.002528 * pow(civilCoordinates.n, 2)
            - 0.0447 * pow(civilCoordinates.e, 2) * civilCoordinates.n
            - 0.0140 * pow(civilCoordinates.n, 3)
        latitude = latitude * 100 / 36
        longitude = longitude * 100 / 36
        return (longitude, latitude)
    }
    
    private static func mn95_to_civil(e: Double, n: Double) -> (e: Double, n: Double) {
        let referenceE: Double = 2600000
        let referenceN: Double = 1200000
        let eCivil = (e - referenceE) / 1000000
        let nCivil = (n - referenceN) / 1000000
        return(eCivil, nCivil)
    }
    
    //MARK: - Public methods
    /// Cette méthode retourne le nombre de place disponibles dans le parking et -1 si aucune information n'est disponible
    public func getDispo() -> Int {
        let dispatchGroup = DispatchGroup()
        var dispo = -1
        
        if self.realTime == false {
            return dispo
        }
        dispatchGroup.enter()
        let url = URL(string: ParkingRessource.getFillingRate())
        Network.executeHTTPGet(url: url!, dataCompletionHandler: { data in
            do {
                let parkingsFillRate = try JSONDecoder().decode(ParkingRessource.ParkingsFillingDatas.self, from: data!)
                for feature in parkingsFillRate.features {
                    if Int(feature.geometry.east) == Int(self.mn95Coordinates[0]) &&
                        Int(feature.geometry.north) == Int(self.mn95Coordinates[1]) {
                        dispo = feature.attributes.available
                    }
                }
                dispatchGroup.leave()
            } catch {
                print("JSON error : \(error)")
            }
        })
        dispatchGroup.wait()
        
        return dispo
    }
}
