//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarWebServiceNames :
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation

class CarWebService {
    public static let baseURL = "https://api.mapbox.com/geocoding/v5/"
    public static let accessToken = "pk.eyJ1Ijoib2xpdmllcmNoZXZhbGxpZXIiLCJhIjoiY2p5eTdmYmduMHhweTNubWVmY3dtNmxjeSJ9.5c6fG8q3ZkNmavCGLs8krw"
    
    //MARK: - Commands
    public static let places = "mapbox.places/"
    public static func getPlaces(txt: String, proximity: String) -> String {
        let stringURL = baseURL + places + txt + ".json?language=fr&proximity=" + proximity + "&access_token=" + accessToken
        print(stringURL)
        return stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //MARK: getPlaces
    struct FeaturesCollection: Decodable {
        let attribution: String
        let features: [Feature]
    }
    
    struct Feature: Decodable {
        let center: [Double]
        let context: [Context]?
        let geometry: Geometry
        let id: String
        let place_name: String
        let place_type: [String]
        let properties: Property
        let text: String
    }
    
    struct Context: Decodable {
        let id: String
        let text: String
    }
    
    struct Geometry: Decodable {
        let coordinates: [Double]
        let type: String
    }
    
    struct Property: Decodable {
        let address: String?
        let category: String?
    }
}
