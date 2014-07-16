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

    func uiimage() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.drawAtPoint(CGPointZero)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class ActionViewController: UIViewController {
    enum ImageFilterOptions: Int {
        case ColorPosterize = 0
        case Pixellate
        case Vignette
    }

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var slider: UISlider?
    @IBOutlet var segmentedControl: UISegmentedControl?

    var image:UIImage?
    var filter:CIFilter?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentedControl!.selectedSegmentIndex = 0
        self.segmentedControlSelected(self.segmentedControl!)

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

        self.image = UIImage(imageData: imageData)
        var ciImage = CIImage(CGImage: self.image!.CGImage)
        if let myFilter = self.filter {
            myFilter.setValue(ciImage, forKey: "inputImage")
        }

        self.editImage {
            editedImage in

            weak var weakImageView = self.imageView
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if let imageView = weakImageView {
                    imageView.image = editedImage
                }
            }
        }
    }

    @IBAction func sliderValueChanged(slider:UISlider) {
        log("Slider value changed to \(slider.value)")
        self.editImage {
            editedImage in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.imageView!.image = editedImage
            }
        }
    }

    @IBAction func segmentedControlSelected(segmentedControl:UISegmentedControl) {
        log("Segment selected \(segmentedControl.selectedSegmentIndex)")

        switch (segmentedControl.selectedSegmentIndex) {
        case ImageFilterOptions.ColorPosterize.toRaw():
            filter = CIFilter(name: "CIColorPosterize")
        case ImageFilterOptions.Pixellate.toRaw():
            filter = CIFilter(name: "CIPixellate")
        case ImageFilterOptions.Vignette.toRaw():
            filter = CIFilter(name: "CIVignette")
        default:
            filter = nil
        }

        if let myImage = image {
            if let myFilter = filter {
                filter!.setValue(CIImage(CGImage: myImage.CGImage), forKey: "inputImage")
                self.editImage {
                    editedImage in
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.imageView!.image = editedImage
                    }
                }
            }
        }
    }

    func editImage(completionBlock:(UIImage?) -> ()) {
        log("Edit image called")

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if let myFilter = self.filter {
                if let myImage = self.image {
                    switch(self.segmentedControl!.selectedSegmentIndex) {
                    case ImageFilterOptions.ColorPosterize.toRaw():
                        myFilter.setValue(self.slider!.value * 10, forKey: "inputLevels")
                    case ImageFilterOptions.Pixellate.toRaw():
                        myFilter.setValue(self.slider!.value * 30, forKey: "inputScale")

                        let center = CGPointMake(myImage.size.width / 2, myImage.size.height / 2)
                        myFilter.setValue(CIVector(CGPoint:center), forKey: "inputCenter")
                    case ImageFilterOptions.Vignette.toRaw():
                        myFilter.setValue(self.slider!.value * 100, forKey: "inputRadius")
                        myFilter.setValue(self.slider!.value * 10, forKey: "inputIntensity")
                    default:
                        log("This path should not happen")
                    }

                    var ciImage = myFilter.outputImage
                    completionBlock(UIImage(CIImage: ciImage))
                } else {
                    log("Image is null")
                    completionBlock(nil)
                }
            } else {
                log("Filter is null")
                completionBlock(nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        let providerItem = NSItemProvider(item: self.imageView!.image.uiimage(), typeIdentifier: kUTTypeImage)
        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [providerItem]
        self.extensionContext.completeRequestReturningItems([extensionItem], completionHandler: nil)
    }

}
