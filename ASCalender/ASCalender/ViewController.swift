//
//  ViewController.swift
//  ASCalender
//
//  Created by Ankit on 15/12/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calenderView: UIView!
    var calenderDateView : ASCalenderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if calenderDateView == nil {
            calenderDateView = Bundle.main.loadNibNamed("ASCalenderView", owner: self, options: nil)?.first as? ASCalenderView
            calenderDateView.backgroundColor = UIColor.darkGray
            calenderDateView.frame = CGRect(x: 0, y: 0, width: calenderView.frame.width, height: calenderView.frame.size.height)
            calenderDateView?.translatesAutoresizingMaskIntoConstraints = true
            calenderDateView.layoutSubviews()
            calenderView.setNeedsLayout()
            calenderDateView.layoutIfNeeded()
            calenderDateView.loadView()
            calenderView.addSubview(calenderDateView)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

