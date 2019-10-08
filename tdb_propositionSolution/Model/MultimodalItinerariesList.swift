//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// MultimodalItinerariesList :
//
// Créé par : Olivier Chevallier le 01.10.19
//--------------------------------------------------


import Foundation
import CoreLocation

class MultimodalItinerariesList: ItinerariesList {
    //MARK: - Properties
    //MARK: Mutable
    var departureTime: Date?
    var carItinerary: CarItinerary?
    var transitItineraries: TransitItinerariesList?
    var parking: Parking?
    
    //MARK: Computed
    var timeToDestination: Int {
        get {
            var value = 0
            for itinerary in self.transitItineraries!.itineraries {
                let timeToDestination = (itinerary as? TransitItinerary)!.timeToDestination
                if value == 0 || value > timeToDestination {
                    value = timeToDestination
                }
            }
            return value
        }
    }
    
    var emissions: Double {
        get {
            return getEmissions()
        }
    }
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Multimodal")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        let parkingList = ParkingList.getInstance()
        
        for parking in parkingList.parkings {
            dispatchGroup.enter()
            parking.getDispo { available in
                if available < 0 || available > 0 {
                    let carItinerariesList = CarItinerariesList(origin:self.origin, destination: parking.location)
                    carItinerariesList.itinerariesCalculated {
                        let tempCarItinerary = (carItinerariesList.itineraries.first! as? CarItinerary)!
                        let tempTransitItineraries = TransitItinerariesList(origin: parking.location, destination: self.destination, departureTime: self.departureTime(carItinerary: tempCarItinerary))
                        tempTransitItineraries.itinerariesCalculated {
                            let actualTimeToDestination = (self.transitItineraries?.itineraries.first as? TransitItinerary)?.timeToDestination
                            let newTimeToDestination = (tempTransitItineraries.itineraries.first as? TransitItinerary)!.timeToDestination
                            if self.carItinerary == nil || actualTimeToDestination ?? 0 > newTimeToDestination {
                                self.parking = parking
                                self.carItinerary = tempCarItinerary
                                self.transitItineraries = tempTransitItineraries
                            }
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
        }
    }
    
    private func departureTime(carItinerary: CarItinerary) -> Date {
        return Date().advanced(by: Double((carItinerary.expectedTime + 10) * 60))
    }
    
    private func getCarItinerary(parking: Parking) {
        let carItinerariesList = CarItinerariesList(origin:origin, destination: parking.location)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as? CarItinerary
        }
    }
    
    private func getEmissions() -> Double {
        var emissions = carItinerary!.emissions + transitItineraries!.avgEmissions
        return emissions
    }
}
