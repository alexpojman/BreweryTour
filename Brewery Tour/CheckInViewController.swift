//
//  CheckInViewController.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/15/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {

    @IBAction func didSelectCloseModalButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
