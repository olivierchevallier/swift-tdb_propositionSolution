//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CLLocationCorrdinate2D+StringRepresentation : Extension de la calsse CLLocationCoordinate2D
//
// Créé par : Olivier Chevallier le 10.10.19
//--------------------------------------------------


import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    /// Retourne les coordonnées sous forme d'une chaine de caratères respectant le format "longitude,latitude"
    public func stringRepresentation() -> String{
        let str_latitude = String(format: "%10f", latitude)
        let str_longitude = String(format: "%10f", longitude)
        let stringFormatedLocation = str_longitude + "," + str_latitude
        return stringFormatedLocation.replacingOccurrences(of: " ", with: "")
    }
}
