//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItinerariesTableViewController :
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit

class TransitItinerariesTableViewController: UITableViewController {
    
    //MARK: - Properties
    //MARK: Var
    var itineraries = [TransitItinerary]()
    var hideNavBar = true
    
    //MARK: Controls
    @IBOutlet var lbl_from: UILabel!
    @IBOutlet var lbl_to: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        showItinerary()
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
        for line in lines {
            let lbl_line = TransitLineControl()
            lbl_line.line = line
            cell.stk_lines.addArrangedSubview(lbl_line)
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: - Private methods
    private func showItinerary() {
        if itineraries.count > 0 {
            lbl_from.text = TransitItinerary.splitAtFirst(str: (itineraries.first?.connection.from.station.name)!, delimiter: "@")!.first
            lbl_to.text = TransitItinerary.splitAtFirst(str: (itineraries.first?.connection.to.station.name)!, delimiter: "@")!.first
        }
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
            hideNavBar = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if hideNavBar {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        hideNavBar = true
    }

}
