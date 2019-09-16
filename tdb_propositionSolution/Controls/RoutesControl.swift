//
//  RoutesControl.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 13.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import UIKit

@IBDesignable class RoutesControl: UIStackView {
    //MARK: Properties
    private var lbl_destinationName = UILabel()
    private var routeControls = [RouteControl]()
    
    var destinationName = "Nom destination" {
        didSet {
            lbl_destinationName.text = self.destinationName
        }
    }
    var intineraries = [Itinerary]() {
        didSet {
            for cpt in 0..<intineraries.count {
                routeControls[cpt].itinerary = intineraries[cpt]
            }
        }
    }
    var routes = [String]()
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: Private methods
    private func setupView() {
        lbl_destinationName.text = self.destinationName
        lbl_destinationName.font = UIFont.boldSystemFont(ofSize: 25)
        addArrangedSubview(lbl_destinationName)
        
        let subView = UIView(frame: bounds)
        subView.backgroundColor = UIColor.systemBackground
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        // Pour les tests de l'interface uniquement
        for cpt in 0..<3 {
            let routeControl = RouteControl()
            routeControl.axis = .horizontal
            routeControl.transportType = "Type de transport"
            routeControl.infos = "(X min, Yg CO2, CHF Z.-)"
            addArrangedSubview(routeControl)
            routeControls.append(routeControl)
        }
        // Fin pour les tests
        
        self.layer.cornerRadius = 10
    }
}
