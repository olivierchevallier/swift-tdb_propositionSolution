//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItineraryController :
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class TransitItineraryController: UIViewController {
    //MARK: - Properties
    //MARK: Var
    var itinerary: TransitItinerary?
    var steps = [TransitStepControl]()
    
    //MARK: Controls
    @IBOutlet var lbl_times: UILabel!
    @IBOutlet var lbl_duration: UILabel!
    @IBOutlet var stk_details: UIStackView!
    @IBOutlet var scrl_details: UIScrollView!
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        showItineraryInfos()
        showItinerarySteps()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Private function
    private func showItineraryInfos() {
        lbl_times.text = "\(itinerary!.departureTime) - \(itinerary!.arrivalTime)"
        lbl_duration.text = "\(itinerary!.expectedTime) min."
    }
    
    private func showItinerarySteps() {
        for section in itinerary!.connection.sections {
            let step = TransitStepControl()
            steps.append(step)
            step.departureStop = section.arrival.station.name
            stk_details.addArrangedSubview(step)
        }
    }
    
    // MARK: - Navigation
    
}
