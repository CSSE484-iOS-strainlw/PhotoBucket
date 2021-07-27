//
//  PhotoBucketTableViewController.swift
//  PhotoBucket
//
//  Created by Loki Strain on 7/26/21.
//

import Foundation
import UIKit
import Firebase

class PhotoBucketTableViewController: UITableViewController {
    
    let photoBucketCellIdentifier = "PhotoBucketCell"
    let detailSegueIdentifier = "DetailSegue"
    var photoBucketsRef: CollectionReference!
    var photoBucketListener: ListenerRegistration!
    
    var photoBuckets = [PhotoBucket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        photoBucketRef = Firestore.firestore().collection("MovieQuotes")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        photoBucketListener = photoBucketsRef.order(by: "created", descending: true).limit(to: 50).addSnapshotListener( { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.photoBuckets.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
                    
                    self.photoBuckets.append(PhotoBucket(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            }else{
                print("Error")
                return
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoBucketListener.remove()
    }
    
    @objc func showAddQuoteDialog(){
        let alertController = UIAlertController(title: "Create a new PhotoBucket", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Photo Url"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Caption"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create PhotoBucket", style: .default) { (action) in
            
            let photoURLTextField = alertController.textFields![0] as UITextField
            let captionTextField = alertController.textFields![1] as UITextField
            
            self.movieQuotesRef.addDocument(data: ["quote": quoteTextField.text!,"movie":movieTextField.text!, "created": Timestamp.init()])
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoBuckets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: photoBucketCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = photoBuckets[indexPath.row].quote
        cell.detailTextLabel?.text = photoBuckets[indexPath.row].movie
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let photoBucketToDelete = photoBuckets[indexPath.row]
            photoBucketsRef.document(photoBucketToDelete.id!).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier{
            if let indexPath = tableView.indexPathForSelectedRow{

                (segue.destination as! PhotoBucketDetailViewController).photoBucketRef = photoBuckets.document(photoBuckets[indexPath.row].id!)
            }
        }
    }
}
