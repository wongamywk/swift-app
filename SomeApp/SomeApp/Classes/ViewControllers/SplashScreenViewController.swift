//
//  SplashScreenViewController.swift
//  SomeApp
//
//  Created by Perry on 2/2/16.
//  Copyright © 2016 PerrchicK. All rights reserved.
//

import UIKit

class SplashScreenViewController : UIViewController {

    @IBOutlet weak var swiftLogo: UIImageView!
    @IBOutlet weak var swiftLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
        swiftLogo.animateMoveCenterTo(x: self.view.center.x, y: self.view.center.y)
        swiftLogo.animateFade(fadeIn: true)
        swiftLogo.animateZoom(zoomIn: true) { (finished) -> Void in
            self.swiftLabel.animateBump { [weak self] (finished) -> Void in
                guard let strongSelf = self else { return }
                
                //strongSelf.pushViewController(StarterViewController.instantiate(), animated: true)
                runBlockAfterDelay(afterDelay: 1.0, block: { () -> Void in
                    strongSelf.performSegueWithIdentifier(className(StarterViewController), sender: self)
                })
            }
        }
    }
}