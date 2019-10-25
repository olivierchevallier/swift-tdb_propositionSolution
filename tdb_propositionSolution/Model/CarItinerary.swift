//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarItinerary : Sous-classe d'Itinerary modélisant un itinéraire en voiture
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation
import Mapbox
import MapboxDirections

class CarItinerary: Itinerary {
    
    //MARK: - Properties
    //MARK: Mutable
    var distance: Double
    var route: Route?
    
    //MARK: - Initializers    
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: Route) {
        self.distance = route.distance
        self.route = route
        super.init(origin: origin, destination: destination, transport: "Voiture")
        self.emissions = self.getEmissions()
        self.cost = self.route!.distance * 0.8 / 1000
        self.expectedTime = Int(self.route!.expectedTravelTime) / 60
    }
    
    //MARK: - Private methods
    private func getEmissions() -> Double {
        let car = Car.getInstance()
        let kmDistance = distance / 1000
        return car.emmissionPerKm * kmDistance
    }
}
