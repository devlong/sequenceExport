//
//  ViewController.swift
//  SequenceExportDemo
//
//  Created by long on 8/4/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SequenceExport.shared.setCurrentSequencer()
        SequenceExport.shared.exportM4a()
    }
}

