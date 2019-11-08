//
//  PhotosViewController.swift
//  VirtualTourist
//
//  Created by Lola M on 7/23/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var fetchedResultsController: NSFetchedResultsController<Photos>!
    var pin: Pin!
    var pageNumber = 1
    var isDeletingEverything = false
    
    var context: NSManagedObjectContext { return dataController.shared.viewContext }
    var doWeHavePhotos: Bool { return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0 }
    
    override func viewWillAppear (_ animated: Bool) { super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) { super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func newCollectionAction(_ sender: Any) {
        updateUI(processing: true)
        if doWeHavePhotos {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! { context.delete(photo) }
            try? context.save()
            isDeletingEverything = false
        }
        
        FlickerAPI.getPhotosUrls(with: pin.coordinate, pageNumber: pageNumber) {
            (urls, error, errorMessage) in
            DispatchQueue.main.async {
                self.updateUI(processing: false)
                guard (error == nil) && (errorMessage == nil) else {
                    self.alert(title: "Error", message: error?.localizedDescription ?? errorMessage)
                    return
                }
                guard let urls = urls,
                    !urls.isEmpty else {
                        self.messageLabel.isHidden = false
                        return
                }
                for url in urls {
                    let photo = Photos(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                }
                try? self.context.save()
            }
        }
        pageNumber += 1
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if doWeHavePhotos {
                updateUI(processing: false)
            }
            else {
                newCollectionAction(self)
            }
        } catch {
            fatalError("The fetch couldn't be performed. \(error.localizedDescription)")
        }
    }
    
    func updateUI(processing: Bool) {
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            newCollection.title = ""
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            newCollection.title = "New Collection"
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexpath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexpath) as! photoCell
        let photo = fetchedResultsController.object(at: indexpath)
        //cell.imageView.setPhoto(photo)
        //cell.imageView.setPhoto(photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) - 20 / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath, type == .delete && isDeletingEverything {
            collectionView.deleteItems (at: [indexPath])
            return
        }
        
        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems (at: [indexPath])
            return
        }
    }
}
