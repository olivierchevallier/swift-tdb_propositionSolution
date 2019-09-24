//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitStepControl :
//
// Créé par : Olivier Chevallier le 23.09.19
//--------------------------------------------------


import UIKit

@IBDesignable class TransitStepControl: UIControl {
    let lineHeight = CGFloat(140)
    
    var line: TransitLine? {
        didSet {
            if line == nil {
                lbl_line.text = "🚶‍♂️ Marche"
                destination = ""
                numberOfStops = 0
                lbl_line.sizeToFit()
            } else {
                lbl_line.line = line!
                destination = line!.destination
            }
        }
    }
    var destination: String? {
        didSet {
            if destination == "" {
                lbl_destination.text = ""
            } else {
                lbl_destination.text = "→" + destination!
            }
            lbl_destination.sizeToFit()
        }
    }
    var departureStop: String? {
        didSet {
            lbl_departureStop.text = departureStop!
            lbl_departureStop.sizeToFit()
        }
    }
    var arrivalStop: String? {
        didSet {
            lbl_arrivalStop.text = arrivalStop!
            lbl_arrivalStop.sizeToFit()
        }
    }
    var departureTime: String? {
        didSet {
            lbl_departureTime.text = departureTime!
            lbl_departureTime.sizeToFit()
        }
    }
    var arrivalTime: String? {
        didSet {
            lbl_arrivalTime.text = arrivalTime!
            lbl_arrivalTime.sizeToFit()
        }
    }
    var numberOfStops: Int? {
        didSet {
            if numberOfStops == 0 {
                lbl_numberOfStops.text = ""
            } else {
                lbl_numberOfStops.text = "\(numberOfStops!) arrêt"
                if numberOfStops! > 1 {
                    lbl_numberOfStops.text! += "s"
                }
            }
        }
    }
    override var intrinsicContentSize: CGSize {
        let width = max(lbl_departureStop.frame.width, lbl_arrivalStop.frame.width)
        return CGSize(width: width, height: lineHeight + 50)
    }
    
    private var lbl_line = TransitLineControl()
    private var lbl_destination = UILabel()
    private var lbl_departureTime = UILabel()
    private var lbl_arrivalTime = UILabel()
    private var lbl_departureStop = UILabel()
    private var lbl_arrivalStop = UILabel()
    private var lbl_numberOfStops = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let xPosition = lbl_departureTime.frame.size.width + 15
        let yPosition = lbl_line.frame.height + 20
        let fromStop = CGPoint(x: xPosition, y: yPosition)
        let toStop = CGPoint(x: xPosition, y: yPosition + lineHeight)
        drawStop(position: fromStop)
        drawStop(position: toStop)
        drawLine(from: fromStop, to: toStop)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        showTimes()
        showStops()
        showLineInfos()
        showJourneyInfos()
        backgroundColor = UIColor.systemBackground
    }
    
    private func drawStop(position: CGPoint) {
        let stop = UIBezierPath()
        stop.addArc(withCenter: position, radius: 5.0, startAngle: 0, endAngle: 360, clockwise: true)
        if line != nil {
            line!.backgroundColor.setStroke()
            line!.backgroundColor.setFill()
        } else {
            UIColor.gray.setStroke()
            UIColor.gray.setFill()
        }
        stop.fill()
    }
    
    private func drawLine(from: CGPoint, to: CGPoint) {
        let line = UIBezierPath()
        line.move(to: from)
        line.addLine(to: to)
        line.lineWidth = 3
        line.stroke()
    }
    
    private func showTimes() {
        addSubview(lbl_departureTime)
        addSubview(lbl_arrivalTime)
        let yPosition = lbl_line.frame.height + 30
        lbl_departureTime.text = "10:10"
        lbl_departureTime.sizeToFit()
        lbl_departureTime.frame.origin = CGPoint(x: 0, y: yPosition)
        lbl_arrivalTime.text = "22:22"
        lbl_arrivalTime.sizeToFit()
        lbl_arrivalTime.frame.origin = CGPoint(x: 0, y: yPosition + lineHeight)
    }
    
    private func showStops() {
        let xPosition = lbl_departureTime.frame.size.width + 30
        let yPosition = lbl_departureTime.frame.origin.y
        addSubview(lbl_departureStop)
        addSubview(lbl_arrivalStop)
        lbl_departureStop.text = "Départ"
        lbl_departureStop.sizeToFit()
        lbl_departureStop.frame.origin = CGPoint(x: xPosition, y: yPosition)
        lbl_arrivalStop.text = "Arrivée"
        lbl_arrivalStop.sizeToFit()
        lbl_arrivalStop.frame.origin = CGPoint(x: xPosition, y: lbl_arrivalTime.frame.origin.y)
    }
    
    private func showLineInfos() {
        let xPosition = CGFloat(0)
        let yPosition = CGFloat(0)
        addSubview(lbl_line)
        addSubview(lbl_destination)
        lbl_line.text = "BUS X"
        lbl_line.sizeToFit()
        lbl_line.frame.origin = CGPoint(x: xPosition, y: yPosition)
        lbl_destination.text = "→ Terminus"
        lbl_destination.sizeToFit()
        lbl_destination.frame.origin.x = xPosition + lbl_line.frame.width + 10
        lbl_destination.frame.origin.y = yPosition
    }
    
    private func showJourneyInfos() {
        let xPosition = lbl_departureStop.frame.origin.x
        addSubview(lbl_numberOfStops)
        lbl_numberOfStops.text = "X arrêt(s)"
        lbl_numberOfStops.sizeToFit()
        let yPosition = lineHeight / 2 + lbl_departureTime.frame.origin.y
        lbl_numberOfStops.frame.origin = CGPoint(x: xPosition, y: yPosition)
    }

}
