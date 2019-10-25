//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItineraryController : Contrôleur de la vue affichant les détails d'un itinéraire de transports publics.
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class TransitItineraryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    //MARK: Mutable
    var itinerary: TransitItinerary?
    var steps = [TransitStepControl]()
    
    //MARK: Controls
    @IBOutlet var lbl_times: UILabel!
    @IBOutlet var lbl_duration: UILabel!
    @IBOutlet var stk_details: UIStackView!
    @IBOutlet var scrl_details: UIScrollView!
    @IBOutlet var col_navigation: UICollectionView!
    
    //MARK: Computed
    private var numberOfSteps: Int {
        get {
            return itinerary!.connection.sections.count - 1
        }
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        col_navigation.layer.cornerRadius = 10
        col_navigation.delegate = self
        showItineraryInfos()
        showItinerarySteps()
    }
    
    //MARK: - Private methods
    private func showItineraryInfos() {
        lbl_times.text = "\(itinerary!.departureTime) - \(itinerary!.arrivalTime)"
        lbl_duration.text = "\(itinerary!.expectedTime) min."
    }
    
    private func showItinerarySteps() {
        for section in itinerary!.connection.sections {
            let step = TransitStepControl()
            steps.append(step)
            step.departureStop = section.departure.station.name!.splitAtFirst(delimiter: "@")!.first
            step.arrivalStop = section.arrival.station.name!.splitAtFirst(delimiter: "@")!.first
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
    
    //MARK: - Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSteps
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transitNavigationCollectionViewCell", for: indexPath) as! TransitNavigationCollectionViewCell
        let nextSection = indexPath.row + 1 < numberOfSteps ? itinerary!.connection.sections[indexPath.row + 1] : nil
        cell.section = itinerary!.connection.sections[indexPath.row]
        cell.nextSection = nextSection
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = col_navigation.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
