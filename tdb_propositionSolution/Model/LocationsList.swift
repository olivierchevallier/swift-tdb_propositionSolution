//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationsList : Classe permettant d'obtenir une liste de lieux 
//
// Créé par : Olivier Chevallier le 10.10.19
//--------------------------------------------------


import Foundation
import CoreLocation

class LocationsList {
    //MARK: - Properties
    //MARK: Immutable
    let dispatchGroup = DispatchGroup()
    let proximity: CLLocationCoordinate2D
    
    //MARK: Mutable
    var searchTxt: String? {
        didSet {
            if self.searchTxt != nil || self.searchTxt! != "" {
                self.dispatchGroup.enter()
                if searched {
                    self.cleanList()
                } else {
                    searched = true
                }
                self.performSearch()
            }
        }
    }
    var locations = [Location]()
    var searched = false
    
    //MARK: - Initialization
    init(proximity: CLLocationCoordinate2D) {
        self.proximity = proximity
    }
    
    //MARK: - Private methods
    /// Rempli le tableau des lieux en fonction du texte recherché
    private func performSearch() {
        let url = URL(string: CarWebService.getPlaces(txt: searchTxt!, proximity: proximity.stringRepresentation()))!
        let reqSearchTxt = searchTxt!
        Network.executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                let featuresCollection = try JSONDecoder().decode(CarWebService.FeaturesCollection.self, from: data!)
                for feature in featuresCollection.features {
                    // Si le texte à changé ça veut dire que la requête ne correspond plus à la recherhce actuelle
                    if reqSearchTxt == self.searchTxt {
                        self.locations.append(Location(name: feature.place_name, coordinate: feature.geometry.coordinates))
                    } else {
                        self.dispatchGroup.leave()
                        return
                    }
                }
                self.dispatchGroup.leave()
            } catch {
                print("JSON error : \(error)")
            }
        })
    }
    
    private func cleanList() {
        self.locations = [Location]()
    }
    
    //MARK: - Public methods
    public func locationsObtained(completionHandler: @escaping() -> Void) {
        dispatchGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
