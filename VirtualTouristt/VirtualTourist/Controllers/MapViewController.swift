//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Lola M on 7/23/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    var context: NSManagedObjectContext {
        return dataController.shared.viewContext
    }

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
        let touchPoint = sender.location (in: mapView)
        let pin = Pin(context: context)
        pin.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        try? context.save()
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        setupFetchedResultsController()
    }

    override func viewDidDisappear(_ animated: Bool) { super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController = performFetch()
            updaeMapView()
        }
        catch {
            fatalError("The fetch couldn't be performed. \(error.localizedDescription)")
        }
    }
    
    func updaeMapView() {
        guard let pins = fetchedResultsController.fetchedObjects else { return }
        for pin in pins {
            if mapView.annotations.contains(where: { pin.compare(to: $0.coordinate) }) { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            let PhotosViewController = segue.destination as! PhotosViewController
            PhotosViewController.pin = sender as? Pin
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedResultsController.fetchedObjects?.filter {$0.compare(to: view.annotation!.coordinate)}.first!
        performSegue(withIdentifier: "showPhotos", sender: pin)
    }
    
    func controllerDidChangedContent (_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updaeMapView()
    }
}
