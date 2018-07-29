//
//  InstructionsViewController.swift
//  cerberus
//
//  Created by Gleb Karpushkin on 29/07/2018.
//  Copyright © 2018 Gleb Karpushkin. All rights reserved.
//

import UIKit
import WebKit

final class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(red: 115/255, green: 188/255, blue: 113/255, alpha: 1)
        let request = URLRequest(url: URL(string: "https://support.apple.com/en-us/HT205362#findmyios")!)
        webView?.load(request)
    }
}
