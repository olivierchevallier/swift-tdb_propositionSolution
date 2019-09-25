//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationTableViewController : Contrôleur du tableau affichant les résultats de recherche de lieux
//
// Créé par : Olivier Chevallier le 11.09.19
//--------------------------------------------------

import UIKit
import os.log

class LocationTableViewController: UITableViewController {
    //MARK: - Properties
    //MARK: Mutable
    var str_userLocation: String?
    var destination: Location?
    var locations = [Location]()
    
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
            performSearch(searchTxt: txt_search.text!, userLocation: str_userLocation!)
        }
        // Le dispatchGroup permet d'attendre que les fonctions qui en font partie quittent le groupe avant d'effectuer ce qui se trouve dans notify. Comme le traitement se fait de manière asynchrone, c'est important
        Network.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            self.indic_loading.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destination = locations[indexPath.row]
    }
    
    @IBAction func btn_cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    /// Effectue la recherche de lieu à afficher dans le TableView.
    /// - Parameter userLocation: La localisation de l'utilisateur doit être passée sous forme de chaine de caractères respectant le format "longitude,latitude"
    private func performSearch(searchTxt: String, userLocation: String){
        let url = URL(string: CarWebService.getPlaces(txt: searchTxt, proximity: userLocation))!
        Network.executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                let featuresCollection = try JSONDecoder().decode(CarWebService.FeaturesCollection.self, from: data!)
                for feature in featuresCollection.features {
                    self.locations.append(Location(name: feature.place_name, coordinate: feature.geometry.coordinates))
                }
            } catch {
                print("JSON error : \(error)")
            }
        })
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
        
        destination = locations[indexPath.row]
        mapViewController.destination = destination
    }
}
