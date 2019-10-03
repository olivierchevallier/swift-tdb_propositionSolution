//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ParkingRessource :
//
// Créé par : Olivier Chevallier le 26.09.19
//--------------------------------------------------


import Foundation

class ParkingRessource {
    //MARK: - Data sources
    static let file = "parkingData"
    
    //MARK: - Data structure
    struct Parkings: Decodable {
        let parkings: [Parking]
        
        private enum CodingKeys : String, CodingKey {
            case parkings = "PARKINGS"
        }
    }
    
    struct Parking: Decodable {
        let east: Double
        let north: Double
        let nom: String
        let vocation: String
        let realTime: String
        
        private enum CodingKeys: String, CodingKey {
            case east = "E", north = "N", nom = "NOM", vocation = "VOCATION", realTime = "DONNEES_TEMPS_REEL"
        }
    }
}
