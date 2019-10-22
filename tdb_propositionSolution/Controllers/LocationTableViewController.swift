//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationTableViewController : Contrôleur du tableau affichant les résultats de recherche de lieux
//
// Créé par : Olivier Chevallier le 11.09.19
//--------------------------------------------------

import UIKit
import CoreLocation
import os.log

class LocationTableViewController: UITableViewController {
    //MARK: - Properties
    
    //MARK: Mutable
    var str_userLocation: String?
    var userLocation: CLLocationCoordinate2D?
    var destination: Location?
    var locations = [Location]()
    var locationsList: LocationsList?
    
    //MARK: Controls
    @IBOutlet var txt_search: UITextField!
    @IBOutlet var indic_loading: UIActivityIndicatorView!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_search.becomeFirstResponder()
        locationsList = LocationsList(proximity: userLocation!)
    }
    
    //MARK: - Actions
    @IBAction func txt_searchChanged(_ sender: UITextField) {
        if txt_search.text != "" {
            indic_loading.startAnimating()
            locationsList!.searchTxt = txt_search.text
        }
        
        locationsList!.locationsObtained() {
            self.tableView.reloadData()
            self.indic_loading.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destination = locationsList!.locations[indexPath.row]
    }
    
    @IBAction func btn_cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList!.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("The queued view cell is not an instance of LocationTableViewCell")
        }

        let location = locationsList!.locations[indexPath.row]
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
        
        destination = locationsList!.locations[indexPath.row]
        mapViewController.destination = destination
    }
}
