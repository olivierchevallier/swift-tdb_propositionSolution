//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitNavigationCollectionViewCell :
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class TransitNavigationCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    //MARK: Mutable
    var section: TransitWebService.Section? {
        didSet {
            if section?.journey != nil {
                let line = TransitLine(journey: self.section!.journey!)
                lbl_connection.text = "Descendez du"
                lbl_connectionLine.line = line
                lbl_leaveAt.text = " dans x min. à"
                lbl_leaveAt.isHidden = false
                lbl_connectionLine.isHidden = false
            } else {
                lbl_connection.text = "Marchez jusqu'à "
                lbl_leaveAt.isHidden = true
                lbl_connectionLine.isHidden = true
            }
            lbl_nextStop.text = TransitItinerary.splitAtFirst(str: section!.arrival.station.name!, delimiter: "@")!.first
            resizeLabels()
        }
    }
    var nextSection: TransitWebService.Section? {
        didSet {
            if self.nextSection != nil {
                if self.nextSection!.journey != nil {
                    let line = TransitLine(journey: self.nextSection!.journey!)
                    lbl_nextConnection.text = "Puis prenez le"
                    lbl_nextConnectionLine.line = line
                    lbl_nextConnectionIn.text = "dans x min."
                    lbl_nextConnectionDirection.text = "→ \(line.destination)"
                    lbl_nextConnectionLine.isHidden = false
                    lbl_nextConnectionIn.isHidden = false
                } else {
                    lbl_nextConnection.text = "Puis marchez jusqu'à"
                    lbl_nextConnectionDirection.text = TransitItinerary.splitAtFirst(str: nextSection!.arrival.station.name!, delimiter: "@")!.first
                    lbl_nextConnectionLine.isHidden = true
                    lbl_nextConnectionIn.isHidden = true
                }
            } else {
                lbl_nextConnection.text = "Puis marchez jusqu'à"
                lbl_nextConnectionDirection.text = "Votre destination"
                lbl_nextConnectionLine.isHidden = true
                lbl_nextConnectionIn.isHidden = true
            }
            resizeLabels()
        }
    }
    
    //MARK: Controls
    @IBOutlet var lbl_connection: UILabel!
    @IBOutlet var lbl_nextStop: UILabel!
    @IBOutlet var lbl_nextConnection: UILabel!
    @IBOutlet var lbl_nextConnectionLine: TransitLineControl!
    @IBOutlet var lbl_nextConnectionDirection: UILabel!
    @IBOutlet var lbl_nextConnectionIn: UILabel!
    @IBOutlet var lbl_connectionLine: TransitLineControl!
    @IBOutlet var lbl_leaveAt: UILabel!
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private methods
    private func resizeLabels() {
        lbl_connection.sizeToFit()
        lbl_nextConnection.sizeToFit()
        lbl_connection.sizeToFit()
    }
}
