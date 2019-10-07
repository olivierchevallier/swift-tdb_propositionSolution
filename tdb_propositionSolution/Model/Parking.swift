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
    let id: Int
    let nom: String
    let location: CLLocationCoordinate2D
    let realTime: Bool
    
    //MARK: Initializer
    init(id: Int, nom: String, east: Double, north: Double, realTime: String) {
        let coordinates = Parking.mn95_to_wgs84(e: east, n: north)
        self.nom = nom
        location = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.realTime = realTime.lowercased() == "vrai"
        self.id = id
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
        let url = URL(string: ParkingRessource.getFillingRate(id: id))
        Network.executeHTTPGet(url: url!, dataCompletionHandler: { data in
            do {
                let parkingsFillRate = try JSONDecoder().decode(ParkingRessource.ParkingsFillingDatas.self, from: data!)
                dispo = parkingsFillRate.features.first!.attributes.available
                dispatchGroup.leave()
            } catch {
                print("JSON error : \(error)")
            }
        })
        //TODO: Résoudre problème de lenteur du à la ligne ci-dessous
        dispatchGroup.wait()
        
        return dispo
    }
}
