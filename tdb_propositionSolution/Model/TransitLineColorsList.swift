//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLineColorsList :
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------


import Foundation

class TransitLineColorsList {
    //MARK: - Properties
    //MARK: Immutable
    let dispatchGroup = DispatchGroup()
    
    //MARK: Mutable
    private static var instance: TransitLineColorsList = {
        let transitLineColorsList = TransitLineColorsList()
        transitLineColorsList.dispatchGroup.wait()
        return transitLineColorsList
    }()
    var lineColors = [TransitWebService.LineColor]()
    
    //MARK: - Initializers
    private init() {
        dispatchGroup.enter()
        let url = URL(string: TransitWebService.getLineColors())
        Network.executeHTTPGet(url: url!, dataCompletionHandler: { data in
            do {
                let lineColors = try JSONDecoder().decode(TransitWebService.LineColors.self, from: data!)
                self.lineColors = lineColors.colors
                self.dispatchGroup.leave()
            } catch {
                print("JSON error : \(error)")
            }
        })
    }
    
    //MARK: - Public methods
    static func getInstance() -> TransitLineColorsList {
        return instance
    }
}
