//
//  LocationTableViewCell.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 10.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet var lbl_locationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
