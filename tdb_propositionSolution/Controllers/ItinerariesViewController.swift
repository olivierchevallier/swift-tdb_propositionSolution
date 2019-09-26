//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ItinerariesViewController : Contrôleur de la vue affichant les différentes options d'itinéraires disponibles (voiture, TP, Mix)
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class ItinerariesViewController: UIViewController {
    //MARK: - Properties
    //MARK: Mutable
    var carItinerary: CarItinerary?
    var transitItineraries = [TransitItinerary]()
    var userLocation: CLLocationCoordinate2D?
    
    //MARK: Observed
    var destination:Location? {
        didSet {
            lbl_destination.text = destination!.name
            getItineraries()
        }
    }
    
    //MARK: Controls
    @IBOutlet var lbl_destination: UILabel!
    @IBOutlet var btn_goCar: GoButtonControl!
    @IBOutlet var btn_goTransit: GoButtonControl!
    @IBOutlet var btn_goMix: GoButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func btn_goCarTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: carItinerary!.route!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    private func getItineraries() {
        getCarItinerary()
        getTransitItineraries()
        getMultimodalItinerary()
    }
    
    private func getCarItinerary() {
        btn_goCar.isLoading(true)
        let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: destination!.coordinate)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as! CarItinerary
            self.btn_goCar.isLoading(false)
        }
    }
    
    private func getTransitItineraries() {
        btn_goTransit.isLoading(true)
        transitItineraries = [TransitItinerary]()
        let transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        transitItinerariesList.itinerariesCalculated {
            for transitIntnerary in transitItinerariesList.itineraries {
                self.transitItineraries.append(transitIntnerary as! TransitItinerary)
            }
            self.btn_goTransit.isLoading(false)
        }
    }
    
    private func getMultimodalItinerary() {
        let parkingList = ParkingList.getInstance()
        let dispatchGroup = DispatchGroup()
        //var itineraries = Dictionary<Int, Parking>
        btn_goMix.isLoading(true)
        for parking in parkingList.parkings {
            dispatchGroup.enter()
            let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: parking.location)
            carItinerariesList.itinerariesCalculated {
                let myCarItinerary = carItinerariesList.itineraries.first! as! CarItinerary
                let transitItinerariesList = TransitItinerariesList(origin: parking.location, destination: self.destination!.coordinate)
                transitItinerariesList.itinerariesCalculated {
                    let myTransitItinerary = transitItinerariesList.itineraries.first!
        
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.btn_goMix.isLoading(false)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransitItineraries" {
            if let destinationVC = segue.destination as? TransitItinerariesTableViewController {
                destinationVC.itineraries = transitItineraries
            }
        }
    }
}
