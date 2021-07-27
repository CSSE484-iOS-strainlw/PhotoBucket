//
//  PhotoBucketDetailViewController.swift
//  PhotoBucket
//
//  Created by Loki Strain on 7/26/21.
//

import Foundation
import UIKit
import Firebase

class PhotoBucketDetailViewController: UIViewController {
    
    // @IBOutlet weak var : UILabel!
    // @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var photoBucket: PhotoBucket?
    var photoBucketRef: DocumentReference!
    var photoBucketListener: ListenerRegistration!
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(showEditDialog))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // updateView()
        photoBucketListener = photoBuckeyRef.addSnapshotListener { (documentSnapshot, error) in
            
            if let error = error {
                print("Error")
                return
            }
            if !documentSnapshot!.exists{
                print("might go back")
                return
            }
            self.photoBucket = PhotoBucket(documentSnapshot: documentSnapshot!)
            self.updateView()
            }
        }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photoBucketListener.remove()
    }
    
    @objc func showEditDialog(){
        
        
            let alertController = UIAlertController(title: "Edit this Caption", message: "", preferredStyle: .alert)
            
            // configure
            alertController.addTextField { (textField) in
                textField.placeholder = "Caption"
                textField.text = self.photoBucket?.caption
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
                let captionTextField = alertController.textFields![0] as UITextField
                
                self.photoBucketRef.updateData(["caption": captionTextField.text!])
                
            }
            alertController.addAction(submitAction)
            
            present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func updateView() {
        captionLabel.text = photoBucket?.caption
    }
}
