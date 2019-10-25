//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItinerariesTableViewController : Controôleur de la vue affichant une liste d'itinéraires en transport publics
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit
import CoreLocation

class TransitItinerariesTableViewController: UITableViewController {
    
    //MARK: - Properties
    //MARK: Mutable
    var itineraries = [TransitItinerary]()
    var departure = Date()
    var destination: CLLocationCoordinate2D?
    var userLocation: CLLocationCoordinate2D?
    
    //MARK: Controls
    @IBOutlet var lbl_from: UILabel!
    @IBOutlet var lbl_to: UILabel!
    @IBOutlet var btn_later: UIButton!
    @IBOutlet var btn_sooner: UIButton!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        showItinerary()    }
    
    //MARK: Actions
    @IBAction func btn_soonerTapped(_ sender: Any) {
        departure = departure.advanced(by: -15 * 60)
        getItineraries()
    }
    
    @IBAction func btn_laterTapped(_ sender: Any) {
        departure = departure.advanced(by: 15 * 60)
        getItineraries()
    }
    
    
    //MARK: - Private methods
    private func showItinerary() {
        if itineraries.count > 0 {
            lbl_from.text = (itineraries.first?.connection.from.station.name)!.splitAtFirst(delimiter: "@")!.first
            lbl_to.text = (itineraries.first?.connection.to.station.name)!.splitAtFirst(delimiter: "@")!.first
        }
    }
    
    private func getItineraries() {
        btn_later.isEnabled = false
        btn_sooner.isEnabled = false
        itineraries = [TransitItinerary]()
        print("userLocation : \(userLocation), destination : \(destination), departureTime: \(departure)")
        let transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!, departureTime: departure)
        transitItinerariesList.itinerariesCalculated {
            for transitIntnerary in transitItinerariesList.itineraries {
                self.itineraries.append(transitIntnerary as! TransitItinerary)
                self.tableView.reloadData()
                self.btn_later.isEnabled = true
                self.btn_sooner.isEnabled = true
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itineraries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransitItineraryTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransitItineraryTableViewCell else {
            fatalError("The queued view cell is not an instance of TransitItineraryTableViewCell")
        }
        
        let departureTime = itineraries[indexPath.row].departureTime
        let arrivalTime = itineraries[indexPath.row].arrivalTime
        let duration = itineraries[indexPath.row].expectedTime
        let lines = itineraries[indexPath.row].lines
        cell.lbl_times.text = "\(departureTime) - \(arrivalTime)"
        cell.lbl_travelTime.text = "\(duration) min."
        
        for subview in cell.stk_lines.arrangedSubviews {
            subview.removeFromSuperview()
        }
        for line in lines {
            let lbl_line = TransitLineControl()
            lbl_line.line = line
            cell.stk_lines.addArrangedSubview(lbl_line)
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransitItinerary" {
            guard let destinationVC = segue.destination as? TransitItineraryController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? TransitItineraryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected view cell is not being displayed by the table")
            }
            
            destinationVC.itinerary = itineraries[indexPath.row]
        }
    }
}
