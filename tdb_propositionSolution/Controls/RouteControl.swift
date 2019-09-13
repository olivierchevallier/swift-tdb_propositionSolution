//
//  RouteControl.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 13.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import UIKit

@IBDesignable class RouteControl: UIStackView {
    //MARK: Properties
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
        stk_labels.axis = .vertical
        stk_labels.addArrangedSubview(lbl_transportType)
        stk_labels.addArrangedSubview(lbl_infos)
        
        lbl_transportType.text = transportType
        lbl_infos.text = infos
        
        btn_go.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn_go.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn_go.backgroundColor = UIColor.green
        btn_go.setTitle("GO", for: .normal)
        btn_go.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn_go.setTitleColor(UIColor.white, for: .normal)
        btn_go.layer.cornerRadius = 10
        
        addArrangedSubview(stk_labels)
        addArrangedSubview(btn_go)
    }
}
