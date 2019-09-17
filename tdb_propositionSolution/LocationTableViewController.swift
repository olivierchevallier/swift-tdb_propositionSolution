//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationTableViewController : Controleur du tableau affichant les résultats de recherche de lieux
//
// Créé par : Olivier Chevallier le 11.09.19
//--------------------------------------------------

import UIKit
import os.log

class LocationTableViewController: UITableViewController {
    //MARK: - Properties
    //MARK: Var
    var userLocationStr: String?
    var destinationLocation: Location?
    var locations = [Location]()
    
    //MARK: Const
    let dispatchGroup = DispatchGroup()
    
    //MARK: Controls
    @IBOutlet var txt_search: UITextField!
    @IBOutlet var indic_loading: UIActivityIndicatorView!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_search.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func txt_searchChanged(_ sender: UITextField) {
        locations = [Location]()
        if txt_search.text != "" {
            indic_loading.startAnimating()
            performSearch(searchTxt: txt_search.text!, userLocation: userLocationStr!)
        }
        // Le dispatchGroup permet d'attendre que les fonctions qui en font partie quittent le groupe avant d'effectuer ce qui se trouve dans notify. Comme le traitement se fait de manière asynchrone, c'est important
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            self.indic_loading.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destinationLocation = locations[indexPath.row]
    }
    
    @IBAction func btn_cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    /**
        Effectue la recherche de lieu à afficher dans le TableView
     */
    private func performSearch(searchTxt: String, userLocation: String){
        let url = generateURL(searchTxt: searchTxt, userLocation: userLocation)
        executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                let featuresCollection = try JSONDecoder().decode(FeaturesCollection.self, from: data!)
                for feature in featuresCollection.features {
                    self.locations.append(Location(name: feature.place_name, coordinate: feature.geometry.coordinates))
                }
            } catch {
                print("JSON error : \(error)")
            }
        })
    }
    
    /**
        Genère l'URL pour la recherche de lieux grâce à l'API search de MapBox
     */
    private func generateURL(searchTxt: String, userLocation: String) -> URL {
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as! String
        let stringURL = "https://api.mapbox.com/geocoding/v5/mapbox.places/" + searchTxt + ".json?proximity=" + userLocation + "&access_token=" + accessToken
        guard let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedStringURL) else {
            fatalError("Error generating URL")
        }
        return url
    }
    
    /**
        Exécute un requête HTTP GET sur l'URL donnée en permettant de traiter les données retournée par la requête dans le dataCompletionHandler (explication dataCompletionHandler : https://fluffy.es/return-value-from-a-closure/)
     */
    private func executeHTTPGet(url: URL, dataCompletionHandler: @escaping(Data?) -> Void) {
        dispatchGroup.enter()
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
        
            guard let mime = response.mimeType, mime == "application/vnd.geo+json" else {
                os_log("Wrong MIME type", log: OSLog.default, type: .debug)
                return
            }
            //Execution du code défini dans le dataCompletionHandler à l'appel de la méthode
            dataCompletionHandler(data)
            self.dispatchGroup.leave()
        })
        task.resume()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("The queued view cell is not an instance of LocationTableViewCell")
        }

        let location = locations[indexPath.row]
        cell.lbl_locationName.text = location.name

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        guard let mapViewController = segue.destination as? MapViewController else {
            fatalError("Unexpected destination : \(segue.destination)")
        }
        
        guard let selectedCell = sender as? LocationTableViewCell else {
            fatalError("Unexpected sender : \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        destinationLocation = locations[indexPath.row]
        mapViewController.destinationLocation = destinationLocation
    }
    
    //MARK: - Structures
    struct FeaturesCollection: Decodable {
        let attribution: String
        let features: [Feature]
    }
    
    struct Feature: Decodable {
        let center: [Double]
        let context: [Context]?
        let geometry: Geometry
        let id: String
        let place_name: String
        let place_type: [String]
        let properties: Property
        let text: String
    }
    
    struct Context: Decodable {
        let id: String
        let text: String
    }
    
    struct Geometry: Decodable {
        let coordinates: [Double]
        let type: String
    }
    
    struct Property: Decodable {
        let address: String?
        let category: String?
    }
}
