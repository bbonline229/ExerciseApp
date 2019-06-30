//
//  RunRecordCell.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit

class RunRecordCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordContainView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locations: [CLLocationCoordinate2D] = []
    private var lastLocation: CLLocationCoordinate2D!
    
    var runRecord: RunModel! {
        didSet {
            dateLabel.text = runRecord.dateDescription
            distanceLabel.text = runRecord.distanceDescription
            paceLabel.text = runRecord.paceDescription
            timeLabel.text = runRecord.durationDescription
            
            drawMap()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        mapView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        recordContainView.layer.cornerRadius = 5
        recordContainView.layer.masksToBounds = true
        
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    private func drawMap() {
        mapView.removeOverlays(mapView.overlays)
        locations = []
        
        for location in runRecord.locations {
            locations.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.logitude))
            lastLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.logitude)
        }
        
        let aPolyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(aPolyline)
        
        let region = MKCoordinateRegion(center: lastLocation, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
}

extension RunRecordCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .lightBlue
        renderer.lineWidth = 5
        return renderer
    }
}
