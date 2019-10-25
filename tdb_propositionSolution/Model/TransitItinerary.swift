//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItinerary : Sous-classe d'Itinerary modélisant un itinéraire en transports publics
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation
import Mapbox

class TransitItinerary: Itinerary {
    
    //MARK: - Properties
    //MARK: Immutable
    let connection: TransitWebService.Connection
    let dateFormatter = DateFormatter()
    
    //MARK: Mutable
    var departureTime: String = ""
    var arrivalTime: String = ""
    var lines: [TransitLine?] = [TransitLine?]()
    
    //MARK: Computed
    override var timeToDestination: Int {
        get {
            if let date = dateFormatter.date(from:connection.to.arrival!) {
                return Int(date.timeIntervalSinceNow) / 60
            }
            return 0
        }
    }
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, connection: TransitWebService.Connection) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        self.connection = connection
        for section in self.connection.sections {
            let journey = section.journey != nil ? section.journey! : nil
        }
        super.init(origin: origin, destination: destination, transport: "Transports publics")
        self.lines = self.getLines()
        self.departureTime = self.getDepartureTime()
        self.arrivalTime = self.getArrivalTime()
        self.expectedTime = self.computeExpectedTime()
        self.emissions = self.computeEmissions()
    }
    
    //MARK: - Public methods
    public static func makeTimePrensentable(time: String) -> String {
        let subStrIndex = time.index(time.startIndex, offsetBy: 11)..<time.index(time.startIndex, offsetBy: 16)
        let subStr = time[subStrIndex]
        return String(subStr)
    }
    
    //MARK: - Private methods
    /// Fonction permettant de récupérer les émissions relatives à un itinéraire en TP. Le résultat est en équivalent de grammes de CO2
    private func computeEmissions() -> Double {
        // Selon mobitool.ch
        let transitAvgEmissions = 24.89
        var emissions = 0.0
        
        for index in 0..<lines.count {
            var distance = computeSectionDistance(index: index)
            emissions += distance / 1000 * transitAvgEmissions
        }
        return emissions
    }
    
    /// Fonction permettant de récuper la distance d'une étape en transports publics. La distance est donnée en mètres
    private func computeSectionDistance(index: Int) -> Double {
        var avgSpeed = 0.0
        var time = 0.0
        if lines[index] != nil {
            avgSpeed = lines[index]!.getAvgSpeed()
            let departure = connection.sections[index].departure.departure
            let arrival = connection.sections[index].arrival.arrival
            if let arrivalDate = dateFormatter.date(from:arrival!), let departureDate = dateFormatter.date(from: departure!) {
                time = Double(arrivalDate.timeIntervalSince(departureDate))
            }
        }
        return avgSpeed / 3.6 * time
    }
    
    private func computeExpectedTime() -> Int {
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
    
    private func getDepartureTime() -> String {
        return TransitItinerary.makeTimePrensentable(time: connection.from.departure!)
    }
    
    private func getArrivalTime() -> String {
        return TransitItinerary.makeTimePrensentable(time: connection.to.arrival!)
    }
    
    private func getLines() -> [TransitLine?] {
        var table = [TransitLine?]()
        let sections = connection.sections
        for section in sections {
            if section.journey == nil {
                table.append(nil)
            } else {
                let journey = (section.journey)!
                table.append(TransitLine(journey: journey))
            }
        }
        return table
    }
}
