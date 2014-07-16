//
//  ViewController.swift
//  MyPhotoFilter
//
//  Created by Yuichi Fujiki on 7/15/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

import UIKit
import MobileCoreServices

func log(text:String) {
    NSLog("###### %@ ######", text)
}

class ViewController: UIViewController {

    @IBOutlet var imageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showActivityViewController() {
        let image = UIImage(named: "TunnelView")
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)

        activityViewController.completionWithItemsHandler = {
            (activityType:String!, completed:Bool, returnedItems:Array?, error:NSError!) in

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                log("Completion block executed")

                if (returnedItems && returnedItems!.count > 0) {
                    let firstItem = returnedItems![0] as NSExtensionItem
                    if (firstItem.attachments.count > 0) {
                        let firstAttachment = firstItem.attachments[0] as NSItemProvider

                        firstAttachment.loadItemForTypeIdentifier(kUTTypeImage, options: nil, completionHandler: {
                            (image: NSSecureCoding!, error:NSError!) in
                            if (error) {
                                log(NSString(format:"Failed to receive image : %@", error.debugDescription));
                            } else if (image is UIImage) {
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.imageView!.image = image as UIImage
                                }
                            }
                            })
                    } else {
                        log("No attachments found")
                    }
                } else {
                    log("No extension items returned")
                }
                })

        }
    }
}

