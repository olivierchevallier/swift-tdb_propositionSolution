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
        lbl_carTime.text = "Chargement..."
        let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: destination!.coordinate)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as! CarItinerary
            self.btn_goCar.isLoading(false)
            self.lbl_carTime.text = "\(self.carItinerary!.expectedTime) min."
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
            self.lbl_transitTime.text = "\(self.transitItineraries.first!.expectedTime) min."
        }
    }
    
    private func getMultimodalItinerary() {
        let parkingList = ParkingList.getInstance()
        var retainedParking: Parking?
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
                
                let transitItinerariesList = TransitItinerariesList(origin: parking.location, destination: self.destination!.coordinate)
                transitItinerariesList.itinerariesCalculated {
                    let myTransitItinerary = transitItinerariesList.itineraries.first!
                    tempMultimodalItinerary.itineraries.append(myTransitItinerary)
                    
                    let totalTravelTime = myTransitItinerary.expectedTime + (myCarItinerary.expectedTime)
                    print("(check) Total expected travel time (\(myTransitItinerary.expectedTime) (transit)+\(myCarItinerary.expectedTime)(car)): \(totalTravelTime)")
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                if self.multimodalItinerary.itineraries.count < 1 {
                    self.multimodalItinerary = tempMultimodalItinerary
                    retainedParking = parking
                }
                else if self.multimodalItinerary.expectedTime > tempMultimodalItinerary.expectedTime {
                    self.multimodalItinerary = tempMultimodalItinerary
                    retainedParking = parking
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.lbl_mixTime.text = "\(self.multimodalItinerary.expectedTime) min."
            self.lbl_mixVia.text = "via \(retainedParking!.nom)"
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
