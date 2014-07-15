//
//  ViewController.swift
//  MyPhotoFilter
//
//  Created by Yuichi Fujiki on 7/15/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
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
    }
}

