//
//  SegundaViewController.swift
//  CustomCamera
//
//  Created by Guilherme Gatto on 05/08/17.
//  Copyright © 2017 mackmobile. All rights reserved.
//

import UIKit

class SegundaViewController: UIViewController {

   
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image

    }

   
    @IBAction func compartilhar(_ sender: Any) {
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)

    }
  

}
