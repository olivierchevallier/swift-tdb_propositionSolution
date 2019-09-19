//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitWebServiceNames :
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation

class TransitWebService {
    public static let baseURL = "https://transport.opendata.ch/v1/"
    
    //MARK: - Commands
    public static func getRoute(from: String, to: String) -> String {
        let stringURL = baseURL + "connections?from=" + from + "&to=" + to
        return stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //MARK: getRoute
    struct Connections: Decodable {
        let connections: [Connection]?
    }
    
    struct Connection: Decodable {
        let from: Stop
        let to: Stop
        let duration: String
        let sections: [Section]
    }
    
    struct Stop: Decodable {
        let arrival: String?
        let arrivalTimestamp: Int?
        let departure: String?
        let departureTimestamp: Int?
        let platform: String?
        let station: Station
    }
    
    struct Station: Decodable {
        let coordinate: Coordinate
        let id: String?
        let name: String?
        let score: String?
    }
    
    struct Coordinate: Decodable {
        let type: String
        let x: Double?
        let y: Double?
    }
    
    struct Section: Decodable {
        let journey: Journey? //Pour les passages à pieds on obtient null
        let walk: Walk?
        let departure: TransitStop
        let arrival: TransitStop
    }
    
    struct Journey: Decodable {
        let name: String
        let category: String
        let number: String
        let to: String
        let passList: [TransitStop]
    }
    
    struct TransitStop: Decodable {
        let station: Station
        let arrival: String? //format : 2019-09-19T17:22:00+0200
        let departure: String? //format : 2019-09-19T17:22:00+0200
        let delay: Int?
        let plateform: String?
    }
    
    struct Walk: Decodable {
        let duration: Int?
    }
}
