//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// ItinerariesViewController :
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
    //MARK: Var
    var destination:Location? {
        didSet {
            lbl_destination.text = destination!.name
            getItineraries()
        }
    }
    var carItinerary: CarItinerary?
    var transitItineraries = [TransitItinerary]()
    var userLocation: CLLocationCoordinate2D?
    
    //MARK: Controls
    @IBOutlet var lbl_destination: UILabel!
    @IBOutlet var btn_goCar: UIButton!
    @IBOutlet var btn_goTransit: UIButton!
    @IBOutlet var btn_goMix: UIButton!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func btn_goCarTapped(_ sender: Any) {
        let navigationVC = NavigationViewController(for: carItinerary!.route!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    //MARK: - Private function
    private func getItineraries() {
        getCarItinerary()
        getTransitItineraries()
        
    }
    
    private func getCarItinerary() {
        btn_goCar.isEnabled = false
        let carItinerariesList = CarItinerariesList(origin:userLocation!, destination: destination!.coordinate)
        carItinerariesList.itinerariesCalculated {
            self.carItinerary = carItinerariesList.itineraries.first! as! CarItinerary
            self.btn_goCar.isEnabled = true
        }
    }
    
    private func getTransitItineraries() {
        btn_goTransit.isEnabled = false
        let transitItinerariesList = TransitItinerariesList(origin: userLocation!, destination: destination!.coordinate)
        transitItinerariesList.itinerariesCalculated {
            for transitIntnerary in transitItinerariesList.itineraries {
                print("Départ : " + (transitIntnerary as! TransitItinerary).connection.from.departure!)
                print("Arrivée : " + (transitIntnerary as! TransitItinerary).connection.to.arrival!)
                print("Durée : \(transitIntnerary.expectedTime)")
                self.transitItineraries.append(transitIntnerary as! TransitItinerary)
            }
            self.btn_goTransit.isEnabled = true
        }
    }
}
