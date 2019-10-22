//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLineColorsList : Classe permettant d'obtenir les couleurs correspondant aux lignes de transport publics. Ces informations ne changeant pas souvent, le design pattern du singleton est utilisé ici.
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
        let url = URL(string: TransitWebService.getLineColors())!
        Network.executeHTTPGet(url: url, dataCompletionHandler: { data in
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
    /// Permet de récupérer l'instance unique de la classe
    static func getInstance() -> TransitLineColorsList {
        return instance
    }
}
