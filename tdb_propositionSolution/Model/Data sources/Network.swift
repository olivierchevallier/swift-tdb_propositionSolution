//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// Network : Class permettant d'effectuer des requêtes HTTP
//
// Créé par : Olivier Chevallier le 19.09.19
//--------------------------------------------------


import Foundation
import os.log

class Network {
    //MARK: - Public methods
    /// Exécute un requête HTTP GET sur l'URL donnée en permettant de traiter les données retournée par la requête dans le dataCompletionHandler (explication dataCompletionHandler : https://fluffy.es/return-value-from-a-closure/)
    static func executeHTTPGet(url: URL, dataCompletionHandler: @escaping(Data?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            if error != nil || data == nil {
                os_log("Client error", log: OSLog.default, type: .debug)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                os_log("Server error", log: OSLog.default, type: .debug)
                return
            }
            //Execution du code défini dans le dataCompletionHandler à l'appel de la méthode
            dataCompletionHandler(data)
        })
        task.resume()
    }
}
