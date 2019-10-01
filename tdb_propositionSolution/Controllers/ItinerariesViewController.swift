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
    //MARK: Immutable
    let multimodalMargin = 10
    
    //MARK: Mutable
    var carItinerary: CarItinerary?
    var transitItineraries = [TransitItinerary]()
    var multimodalItineraries: MultimodalItinerariesList?
    var multimodalItinerary = ItinerariesList()
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
    @IBOutlet var lbl_carTime: UILabel!
    @IBOutlet var btn_goTransit: GoButtonControl!
    @IBOutlet var lbl_transitTime: UILabel!
    @IBOutlet var btn_goMix: GoButtonControl!
    @IBOutlet var lbl_mixTime: UILabel!
    @IBOutlet var lbl_mixVia: UILabel!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
    }
    
    //MARK: - Actions
    @IBAction func btn_goCarTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: carItinerary!.route!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_goMixTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: (multimodalItinerary.itineraries.first! as? CarItinerary)!.route!)
        performSegue(withIdentifier: "showMultimodalItineraries", sender: self)
        present(navigationVC, animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    private func getItineraries() {
        getCarItinerary()
        getTransitItineraries()
        getMultimodalItineraries()
    }
    
    private func getCarItinerary() {
        btn_goCar.isLoading(true)
        lbl_carTime.text = "Chargement..."
        let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: destination!.coordinate)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as? CarItinerary
            self.btn_goCar.isLoading(false)
            self.lbl_carTime.text = "\(self.carItinerary!.timeToDestination) min."
        }
    }
    
    private func getTransitItineraries() {
        btn_goTransit.isLoading(true)
        lbl_transitTime.text = "Chargement..."
        transitItineraries = [TransitItinerary]()
        let transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        transitItinerariesList.itinerariesCalculated {
            for transitIntnerary in transitItinerariesList.itineraries {
                self.transitItineraries.append(transitIntnerary as! TransitItinerary)
            }
            self.btn_goTransit.isLoading(false)
            self.lbl_transitTime.text = "\(self.transitItineraries.first!.timeToDestination) min."
        }
    }
    
    private func getMultimodalItineraries() {
        btn_goMix.isLoading(true)
        lbl_mixTime.text = "Chargement..."
        lbl_mixVia.text = ""
        multimodalItineraries = MultimodalItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        multimodalItineraries!.itinerariesCalculated {
            self.lbl_mixTime.text = "\(self.multimodalItineraries!.timeToDestination) min."
            self.lbl_mixVia.text = "via \(self.multimodalItineraries!.parking!.nom)"
            self.btn_goMix.isLoading(false)
        }
    }
    /*
    private func getMultimodalItinerary() {
        let parkingList = ParkingList.getInstance()
        var retainedParking: Parking?
        self.multimodalItinerary = ItinerariesList()
        let dispatchGroup = DispatchGroup()
        btn_goMix.isLoading(true)
        lbl_mixTime.text = "Chargement..."
        lbl_mixVia.text = ""
        
        for parking in parkingList.parkings {
            dispatchGroup.enter()
            let tempMultimodalItinerary = ItinerariesList()
            let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: parking.location)
            carItinerariesList.itinerariesCalculated {
                let myCarItinerary = carItinerariesList.itineraries.first! as! CarItinerary
                tempMultimodalItinerary.itineraries.append(myCarItinerary)
                let departureTime = Date().advanced(by: Double((myCarItinerary.expectedTime + self.multimodalMargin) * 60))
                let transitItinerariesList = TransitItinerariesList(origin: parking.location, destination: self.destination!.coordinate, departureTime: departureTime)
                transitItinerariesList.itinerariesCalculated {
                    let myTransitItinerary = transitItinerariesList.itineraries.first!
                    tempMultimodalItinerary.itineraries.append(myTransitItinerary)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                if self.multimodalItinerary.itineraries.count < 1 || self.multimodalItinerary.itineraries.last!.timeToDestination > tempMultimodalItinerary.itineraries.last!.timeToDestination {
                    self.multimodalItinerary = tempMultimodalItinerary
                    retainedParking = parking
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.lbl_mixTime.text = "\(self.multimodalItinerary.itineraries.last!.timeToDestination) min."
            print("\(self.multimodalItinerary.expectedTime + self.multimodalMargin) min.")
            self.lbl_mixVia.text = "via \(retainedParking!.nom)"
            self.btn_goMix.isLoading(false)
        }
    }
 */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TransitItinerariesTableViewController {
            var itineraries = [Itinerary]()
            if segue.identifier == "showTransitItineraries" {
                itineraries = transitItineraries
            } else if segue.identifier == "showMultimodalItineraries" {
                itineraries = multimodalItineraries!.transitItineraries!.itineraries
            }
            destinationVC.itineraries = (itineraries as? [TransitItinerary])!
        }
    }
}
