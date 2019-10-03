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
    
    public static func getFillingRate() -> String {
        let stringURL = "https://ge.ch/sitgags1/rest/services/VECTOR/SITG_OPENDATA_03/MapServer/4869/query?geometry=1&outFields=*&returnGeometry=true&f=pjson"
        return stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //MARK: - Data structure
    //MARK: Parking
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
    
    //MARK: Parking filling
    struct ParkingsFillingDatas: Decodable {
        let features: [ParkingFillingFeatures]
    }
    
    struct ParkingFillingFeatures: Decodable {
        let attributes: ParkingFillingAttributes
        let geometry: ParkingFillingGeometry
    }
    
    struct ParkingFillingAttributes: Decodable {
        let available: Int
        let total: Int
        
        private enum CodingKeys: String, CodingKey {
            case available = "PLACE_DISPONIBLE", total = "PLACE_TOTALE"
        }
    }
    
    struct ParkingFillingGeometry: Decodable {
        let east: Double
        let north: Double
        
        private enum CodingKeys: String, CodingKey {
            case east = "x", north = "y"
        }
    }
}
