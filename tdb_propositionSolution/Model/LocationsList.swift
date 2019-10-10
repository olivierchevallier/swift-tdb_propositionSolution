//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationsList :
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
                if searched {
                    locationsObtained {
                        self.cleanList()
                        self.performSearch()
                    }
                } else {
                    searched = true
                    self.performSearch()
                }
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
    private func performSearch() {
        dispatchGroup.enter()
        let url = URL(string: CarWebService.getPlaces(txt: searchTxt!, proximity: proximity.stringRepresentation()))!
        Network.executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                let featuresCollection = try JSONDecoder().decode(CarWebService.FeaturesCollection.self, from: data!)
                for feature in featuresCollection.features {
                    self.locations.append(Location(name: feature.place_name, coordinate: feature.geometry.coordinates))
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
