//
//  ActionViewController.swift
//  MyPhotoFilterAction
//
//  Created by Yuichi Fujiki on 7/15/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

import UIKit
import MobileCoreServices

func log(text:String) {
    NSLog("###### %@ ######", text)
}

extension UIImage {
    convenience init(imageData:NSSecureCoding?) {
        if (imageData is UIImage) {
            let image = imageData as UIImage
            self.init(CGImage:(imageData as UIImage).CGImage)
        } else if (imageData is NSURL) {
            self.init(data: (NSData(contentsOfURL: imageData as NSURL)))
        } else if (imageData is NSData) {
            self.init(data: imageData as NSData)
        } else {
            self.init()
        }
    }
}

class ActionViewController: UIViewController {

    @IBOutlet var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        for item: AnyObject in self.extensionContext.inputItems! {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider

                log("Registered identifiers : \(itemProvider.registeredTypeIdentifiers)")

                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage) {
                    // This is an image. We'll load it, then place it in our image view.
                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage, options: nil, completionHandler: { (imageData, error) in
                        self.showImageWithSecureCoding(imageData)
                    })
                }
            }
        }
    }

    func showImageWithSecureCoding(imageData:NSSecureCoding?) {

        let image = UIImage(imageData: imageData)

        weak var weakImageView = self.imageView
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if let imageView = weakImageView {
                imageView.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext.completeRequestReturningItems(self.extensionContext.inputItems, completionHandler: nil)
    }

}
