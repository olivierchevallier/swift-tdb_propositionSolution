//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// Location : Modèle représentant un lieu
//
// Créé par : Olivier Chevallier le 10.09.19
//--------------------------------------------------

import Foundation
import CoreLocation

class Location {
    
    //MARK: - Properties
    //MARK: Mutable
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    //MARK: - Initializer
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
    
    convenience init (name: String, coordinate: [Double]){
        self.init(name: name, coordinate: CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0]))
    }
    
}
