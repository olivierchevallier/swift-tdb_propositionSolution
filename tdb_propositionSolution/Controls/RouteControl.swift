//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// RouteControl : Contrôle affichant un itinéraire
//
// Créé par : Olivier Chevallier le 13.09.19
//--------------------------------------------------

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

@IBDesignable class RouteControl: UIStackView {
    
    //MARK: - Properties
    //MARK: Var
    private var lbl_transportType = UILabel()
    private var lbl_infos = UILabel()
    private var btn_go = UIButton()
    private var stk_labels = UIStackView()
    
    
    var transportType = "" {
        didSet {
            lbl_transportType.text = transportType
        }
    }
    var infos = "" {
        didSet {
            lbl_infos.text = infos
        }
    }
    var itinerary: Itinerary? {
        didSet {
            transportType = itinerary!.transport
            self.infos = "Chargement..."
            btn_go.isEnabled = false
            updateStyleBtnGo()
            itinerary!.routeCalculated {
                self.infos = String(format: "%d min, %.01fg CO2, CHF %.02f.-", self.itinerary!.expectedTime, self.itinerary!.emissions, self.itinerary!.cost)
                self.btn_go.isEnabled = true
                self.updateStyleBtnGo()
            }
        }
    }

    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: - Private methods
    /// Met en place tous les éléments à afficher dans la vue 
    private func setupView() {
        stk_labels.axis = .vertical
        stk_labels.addArrangedSubview(lbl_transportType)
        stk_labels.addArrangedSubview(lbl_infos)
        
        lbl_transportType.text = transportType
        lbl_infos.text = infos
        
        btn_go.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn_go.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn_go.backgroundColor = UIColor.green
        btn_go.setTitle("GO", for: .normal)
        btn_go.setTitleColor(UIColor.white, for: .normal)
        btn_go.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn_go.layer.cornerRadius = 10
        btn_go.addTarget(self, action: #selector(btn_goTapped(button:)), for: .touchUpInside)
        
        addArrangedSubview(stk_labels)
        addArrangedSubview(btn_go)
    }
    
    /// Met à jour le style du bouton pour refléter son état d'activation
    private func updateStyleBtnGo(){
        if btn_go.isEnabled {
            btn_go.backgroundColor = UIColor.green
        } else {
            btn_go.backgroundColor = UIColor.gray
        }
    }
    
    @objc private func btn_goTapped(button: UIButton) {
        if itinerary != nil {
            let navigationVC = NavigationViewController(for: itinerary!.route!)
            self.window?.rootViewController!.present(navigationVC, animated: true, completion: nil)
        }
    }
}
