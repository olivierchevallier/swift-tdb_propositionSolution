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
                timeBeforeChange = computeTimeBefore(dateStr: section!.arrival.arrival!)
                lbl_connection.text = "Descendez du"
                lbl_connectionLine.line = line
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
                    timeBeforeNextConnection = computeTimeBefore(dateStr: nextSection!.departure.departure!)
                    lbl_nextConnection.text = "Puis prenez le"
                    lbl_nextConnectionLine.line = line
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
    var timeBeforeChange: Int? {
        didSet {
            if section?.journey != nil {
                if timeBeforeChange! > 0 {
                    lbl_leaveAt.text = " dans \(timeBeforeChange!) min. à"
                } else if timeBeforeChange! > -1 {
                    lbl_leaveAt.text = " maintenant à"
                } else {
                    lbl_leaveAt.text = ""
                }
            }
        }
    }
    var timeBeforeNextConnection: Int? {
        didSet {
            if self.nextSection != nil {
                if self.nextSection!.journey != nil {
                    if timeBeforeNextConnection! > 0 {
                        lbl_nextConnectionIn.text = "dans \(timeBeforeNextConnection!) min."
                    } else if timeBeforeNextConnection! > -1 {
                        lbl_nextConnectionIn.text = "maintenant"
                    } else {
                        lbl_nextConnectionIn.text = ""
                    }
                }
            }
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
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    //MARK: - Private methods
    private func initialize() {
        let timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: {_ in
            self.updateTimeInfos()
        })
    }
    
    private func resizeLabels() {
        lbl_connection.sizeToFit()
        lbl_nextConnection.sizeToFit()
        lbl_connection.sizeToFit()
    }
    
    private func computeTimeBefore(dateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateStr) {
            return Int(date.timeIntervalSinceNow) / 60
        }
        return 0
    }
    
    private func updateTimeInfos() {
        if self.nextSection != nil {
            if self.nextSection!.journey != nil {
                timeBeforeNextConnection = computeTimeBefore(dateStr: nextSection!.departure.departure!)
            }
        }
        if section?.journey != nil {
            timeBeforeChange = computeTimeBefore(dateStr: section!.arrival.arrival!)
        }
    }
}
