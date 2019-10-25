//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// MultimodalItinerary : Sous-classe d'Itinerary modélisant un itinéraire multimodal
//
// Créé par : Olivier Chevallier le 10.10.19
//--------------------------------------------------


import Foundation
import CoreLocation

class MultimodalItinerary: Itinerary {
    //MARK: - Properties
    //MARK: Immutable
    let parking: Parking
    
    //MARK: Mutable
    var carItinerary: CarItinerary
    var transitItinerariesList: TransitItinerariesList
    
    //MARK: Comuputed
    override var timeToDestination: Int {
        get {
            return computeTimeToDestination()
        }
    }
    
    //MARK: - Initializer
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, parking: Parking, carItinerary: CarItinerary, transitItinerariesList: TransitItinerariesList) {
        self.parking = parking
        self.carItinerary = carItinerary
        self.transitItinerariesList = transitItinerariesList
        super.init(origin: origin, destination: destination, transport: "Multimodal")
        self.expectedTime = computeExpectedTime()
        self.emissions = computeEmissions()
    }
    
    //MARK: - Private methods
    private func computeExpectedTime() -> Int {
        if transitItinerariesList.itineraries.count < 1 {
            return Int.max
        }
        return transitItinerariesList.itineraries.first!.timeToDestination
    }
    
    private func computeTimeToDestination() -> Int {
        if transitItinerariesList.itineraries.count < 1 {
            return Int.max
        }
        return transitItinerariesList.itineraries.first!.timeToDestination
    }
    
    private func computeEmissions() -> Double {
        return carItinerary.emissions + transitItinerariesList.avgEmissions
    }
}
