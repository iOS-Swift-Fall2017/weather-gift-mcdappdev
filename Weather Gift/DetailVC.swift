//
//  DetailVC.swift
//  Weather Gift
//
//  Created by Jimmy McDermott on 10/11/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var currentPage = 0
    var locationsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = locationsArray[currentPage]
    }
}
