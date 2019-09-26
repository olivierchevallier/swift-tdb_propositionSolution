//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ParkingList :
//
// Créé par : Olivier Chevallier le 26.09.19
//--------------------------------------------------


import Foundation

class ParkingList {
    //MARK: - Properties
    //MARK: Immutable
    let filter = "Parc relais"
    
    //MARK: Mutable
    private static var instance: ParkingList = {
        let parkingList = ParkingList()
        return parkingList
    }()
    var parkings = [Parking]()
    
    //MARK: Initializer
    private init() {
        if let path = Bundle.main.path(forResource: ParkingRessource.file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let parkings = try JSONDecoder().decode(ParkingRessource.Parkings.self, from: data)
                for parking in parkings.parkings {
                    if parking.vocation == filter {
                        let parking = Parking(nom: parking.nom, east: parking.east, north: parking.north)
                        self.parkings.append(parking)
                    }
                }
            } catch {
                print(error)
            }
        } else {
            fatalError("File with parkings data cannot be found ")
        }
    }
    
    //MARK: - Public methods
    /// Permet de récupérer l'instance unique de la classe
    static func getInstance() -> ParkingList {
        return instance
    }
}
