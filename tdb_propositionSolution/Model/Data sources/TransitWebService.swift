//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitWebServiceNames : Class permettant de générer les liens des différents web services relatifs aux transport publics
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation

class TransitWebService {
    //MARK: - Commands
    public static func getRoute(from: String, to: String) -> String {
        let baseURL = "https://transport.opendata.ch/v1/"
        let stringURL = baseURL + "connections?from=" + from + "&to=" + to
        return stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    public static func getLineColors() -> String {
        let baseURL = "https://prod.ivtr-od.tpg.ch/v1/"
        let accessKey = "82ecbba0-60d5-11e3-a274-0002a5d5c51b"
        let stringURL = baseURL + "GetLinesColors.json?key=" + accessKey
        print(stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
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
        let transitOperator: String
        let passList: [TransitStop]
        
        private enum CodingKeys : String, CodingKey {
            case name, category, number, to, transitOperator = "operator", passList
        }
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
    
    //MARK: getLineColors
    struct LineColors: Decodable {
        let colors: [LineColor]
    }
    
    struct LineColor: Decodable {
        let lineCode: String
        let hexa: String
        let background: String
        let text: String
    }
}
