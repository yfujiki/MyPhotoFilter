//
//  UIImage+Additions.swift
//  MyPhotoFilter
//
//  Created by Yuichi Fujiki on 7/16/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

import UIKit
import AssetsLibrary

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

    func saveToPhotos() {
        let library = ALAssetsLibrary()
        let imageData = UIImagePNGRepresentation(self.uiimage())
        library.writeImageDataToSavedPhotosAlbum(imageData, metadata:nil, completionBlock: nil)
    }

    func encodeToBase64JPEGString() -> (String) {
        let imageData = UIImageJPEGRepresentation(self, 0.8)
        let imageString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
        log("image string : \(imageString)")
        return "data:image/jpeg;base64," + imageString
    }
}
