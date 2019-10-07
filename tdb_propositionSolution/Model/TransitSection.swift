//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitSection :
//
// Créé par : Olivier Chevallier le 07.10.19
//--------------------------------------------------


import Foundation

class TransitSection {
    //MARK: - Properties
    //MARK: Immutable
    var line: TransitLine?
    let departure: TransitWebService.TransitStop
    let arrival: TransitWebService.TransitStop
    let dispatchGroup = DispatchGroup()
    
    //MARK: Mutable
    var polyline: [[Double]]?
    
    //MARK: - Initilization
    init(journey: TransitWebService.Journey?, departure: TransitWebService.TransitStop, arrival: TransitWebService.TransitStop) {
        self.line = journey != nil ? TransitLine(journey: journey!) : nil
        self.departure = departure
        self.arrival = arrival
        if self.line != nil {
            getPolyline()
        }
    }
    
    //MARK: Private methods
    private func getPolyline() {
        dispatchGroup.enter()
        let lineDestinationShort = line!.destination.splitAtFirst(delimiter: ", ")!.last
        let url = URL(string: TransitWebService.getLinePolyline(line: line!.number, direction: lineDestinationShort))!
        Network.executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                print(url)
                print(String(decoding: data!, as: UTF8.self))
                let linePolyLineDatas = try JSONDecoder().decode(TransitWebService.linePolyLineDatas.self, from: data!)
                let lineGeometry = linePolyLineDatas.features.first!.geometry
                self.polyline = lineGeometry.paths.first!
                print(self.polyline)
                self.dispatchGroup.leave()
            } catch {
                print("JSON error \(error)")
            }
        })
    }
    
    //MARK: Public functions
    public func polylineSetted(completionHandler: @escaping() -> Void){
        dispatchGroup.notify(queue: .main, execute: {
            completionHandler()
        })
    }
}
