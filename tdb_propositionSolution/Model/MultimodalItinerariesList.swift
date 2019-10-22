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
    //MARK: Immutable
    let internalDispatchGroup = DispatchGroup()
    let parkingList = ParkingList.getInstance()

    //MARK: Mutable
    var shortest: MultimodalItinerary {
        get {
            return getShortestItinerary()
        }
    }
    var mostEco: MultimodalItinerary {
        get {
            return getMostEcoItinerary()
        }
    }
    var mostEfficient: MultimodalItinerary {
        get {
            return getMostEfficient()
        }
    }
    
    //MARK: - Initializers
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        super.init(origin: origin, destination: destination, transport: "Multimodal")
    }
    
    //MARK: - Private methods
    /// Calcul l'itinéraire
    override internal func calculateItineraries(completion: @escaping(Error?) -> Void){
        dispatchGroup.enter()
        for parking in parkingList.parkings {
            var carItinerary: CarItinerary?
            var transitItineraries: TransitItinerariesList?
            
            internalDispatchGroup.enter()
            getCarItinerary(parking: parking, completionHandler: { returnedCarItinerary in
                carItinerary = returnedCarItinerary
                self.getTransitItineraries(parking: parking, departureTime: self.departureTime(carItinerary: carItinerary!), completionHandler: { returnedTransitItinerariesList in
                    transitItineraries = returnedTransitItinerariesList
                    self.internalDispatchGroup.leave()
                })
            })
            
            internalDispatchGroup.notify(queue: .main) {
                self.itineraries.append(MultimodalItinerary(origin: self.origin, destination: self.destination, parking: parking, carItinerary: carItinerary!, transitItinerariesList: transitItineraries!))
            }
        }
        internalDispatchGroup.notify(queue: .main) {
            self.dispatchGroup.leave()
        }
    }
    
    private func departureTime(carItinerary: CarItinerary) -> Date {
        return Date().advanced(by: Double((carItinerary.expectedTime + 10) * 60))
    }
    
    private func getCarItinerary(parking: Parking, completionHandler: @escaping(CarItinerary) -> Void) {
        let carItinerariesList = CarItinerariesList(origin:origin, destination: parking.location)
        carItinerariesList.itinerariesCalculated {
            let carItinerary = carItinerariesList.itineraries.first! as? CarItinerary
            completionHandler(carItinerary!)
        }
    }
    
    private func getTransitItineraries(parking: Parking, departureTime: Date, completionHandler: @escaping(TransitItinerariesList) -> Void) {
        let transitItinerariesList = TransitItinerariesList(origin: parking.location, destination: destination, departureTime: departureTime)
        transitItinerariesList.itinerariesCalculated {
            completionHandler(transitItinerariesList)
        }
    }
    
    private func getShortestItinerary() -> MultimodalItinerary {
        var shortestTimeToDestination = Int.max
        var itineraryToReturn: MultimodalItinerary?
        
        for itinerary in itineraries {
            let itineraryTimeToDestination = itinerary.timeToDestination
            print("Time to destination \(itineraryTimeToDestination)")
            if itineraryTimeToDestination < shortestTimeToDestination {
                shortestTimeToDestination = itineraryTimeToDestination
                itineraryToReturn = itinerary as? MultimodalItinerary
            }
        }
        
        return itineraryToReturn!
    }
    
    private func getMostEcoItinerary() -> MultimodalItinerary {
        var emissions = -1.0
        var itineraryToReturn: MultimodalItinerary?
        
        for itinerary in itineraries {
            let itineraryConsumption = itinerary.emissions
            if emissions < 0 || itineraryConsumption < emissions {
                emissions = itineraryConsumption
                itineraryToReturn = itinerary as? MultimodalItinerary
            }
        }
        
        return itineraryToReturn!
    }
    
    private func getMostEfficient() -> MultimodalItinerary {
        var efficience = -1.0
        var itineraryToReturn: MultimodalItinerary?
        
        for itinerary in itineraries {
            let itineraryConsumption = itinerary.emissions
            let itineraryTimeToDestination = itinerary.timeToDestination
            let avg = itineraryConsumption / Double(itineraryTimeToDestination)
            if efficience < 0 || avg < efficience {
                efficience = avg
                itineraryToReturn = itinerary as? MultimodalItinerary
            }
        }
        
        return itineraryToReturn!
    }
    
    //MARK: Public methods
    public func getMosEfficient(transitItineraries: TransitItinerariesList, carItinerary: CarItinerary) -> MultimodalItinerary {
        var score = -1.0
        var minTime = -1.0
        var itineraryToReturn: MultimodalItinerary?
        for itinerary in itineraries {
            let timeToDestinationPercentage = Double(itinerary.timeToDestination) / Double(transitItineraries.itineraries.first!.timeToDestination)
            let emissionsPercentage = itinerary.emissions / carItinerary.emissions
            let itineraryScore = timeToDestinationPercentage + emissionsPercentage
            // Tests
            let unsetted = (minTime < 0 && score < 0)
            let shorterThanTransit = (minTime >= 1 && timeToDestinationPercentage < minTime)
            let betterScore = (score > itineraryScore && minTime > 1)
            let shorterAndBetterScore = (minTime < 1 && timeToDestinationPercentage < 1 && itineraryScore < score)
            print("\((itinerary as! MultimodalItinerary).parking.nom) (\(Double(itinerary.expectedTime)) min. / \(Double(transitItineraries.expectedTime) / Double(transitItineraries.count)) = \(timeToDestinationPercentage)) :")
            print(" unsetted \(unsetted) - shorterThanTransit \(shorterThanTransit) - betterScore \(betterScore) - shorterAndBetter \(shorterAndBetterScore)")
            if  unsetted || shorterThanTransit || betterScore || shorterAndBetterScore {
                score = timeToDestinationPercentage + emissionsPercentage
                minTime = timeToDestinationPercentage
                itineraryToReturn = itinerary as? MultimodalItinerary
            }
        }
        return itineraryToReturn!
    }
}
