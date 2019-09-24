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
            step.departureStop = TransitItinerary.splitAtFirst(str: section.departure.station.name!, delimiter: "@")!.first
            step.arrivalStop = TransitItinerary.splitAtFirst(str: section.arrival.station.name!, delimiter: "@")!.first
            step.departureTime = TransitItinerary.makeTimePrensentable(time: section.departure.departure!)
            step.arrivalTime = TransitItinerary.makeTimePrensentable(time: section.arrival.arrival!)
            if section.journey == nil {
                step.line = nil
            } else {
                let journey = (section.journey)!
                step.line = TransitLine(journey: journey)
                step.numberOfStops = journey.passList.count
            }
            stk_details.addArrangedSubview(step)
        }
    }
    
    // MARK: - Navigation
    
}
