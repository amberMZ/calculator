//
//  ViewController.swift
//  calculator
//
//  Created by Mingyu Zhang on 9/1/16.
//  Copyright (c) 2016 Mingyu Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberDisplayLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func numberPressed(_ sender: UIButton) {
//        println("\(sender)")
        let value = sender.titleLabel?.text!
        // ? optional : if the var before is null, ignore things after ?
//        if numberDisplayLabel.text!.characters.count >= 8 {
//            return
//        }
        numberDisplayLabel.text! += "\(value)"
        
        
        var valueOfDobule = Double(numberDisplayLabel.text!)!
        // no multiple .
    }
    
    @IBOutlet weak var numberDisplayLabel: UILabel!
    
    
    
}

