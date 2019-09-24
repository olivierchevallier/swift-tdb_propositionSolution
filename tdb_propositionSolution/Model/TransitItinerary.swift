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
    
    //MARK: Const
    let connection: TransitWebService.Connection
    
    //MARK: Computed
    override var emissions: Double {
        get {
            return 0
        }
    }
    override var cost: Double {
        get {
            return 0
        }
    }
    override var expectedTime: Int {
        get {
            let duration = connection.duration
            let daysStr = duration.startIndex..<duration.index(duration.startIndex, offsetBy: 2)
            let hoursStr = duration.index(duration.startIndex, offsetBy: 3)..<duration.index(duration.startIndex, offsetBy: 5)
            let minutesStr = duration.index(duration.startIndex, offsetBy: 6)..<duration.index(duration.startIndex, offsetBy: 8)
            let days = Int(duration[daysStr])!
            let hours = Int(duration[hoursStr])!
            let minutes = Int(duration[minutesStr])!
            let durationInMinutes = days * 24 * 60 + hours * 60 + minutes
            return durationInMinutes
        }
    }
    var departureTime: String {
        get {
            return TransitItinerary.makeTimePrensentable(time: connection.from.departure!)
        }
    }
    var arrivalTime: String {
        get {
            return TransitItinerary.makeTimePrensentable(time: connection.to.arrival!)
        }
    }
    var lines: [String] {
        get {
            var table = [String]()
            let sections = connection.sections
            for section in sections {
                if section.journey == nil {
                    table.append("Marche")
                } else {
                    table.append(section.journey!.number)
                }
            }
            return table
        }
    }
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, connection: TransitWebService.Connection) {
        self.connection = connection
        super.init(origin: origin, destination: destination, transport: "Transports publics")
    }
    
    //MARK: - Private methods
    public static func makeTimePrensentable(time: String) -> String {
        let subStrIndex = time.index(time.startIndex, offsetBy: 11)..<time.index(time.startIndex, offsetBy: 16)
        let subStr = time[subStrIndex]
        return String(subStr)
    }
}
