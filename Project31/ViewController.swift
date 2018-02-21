//
//  ViewController.swift
//  Project31
//
//  Created by Jake Grant on 2/20/18.
//  Copyright © 2018 Jake Grant. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func updateUI(for webView: WKWebView) {
        if let webTitle = webView.title, let webAddress = webView.url {
            title = webTitle
            addressBar.text = webAddress.absoluteString
        } else {
            title = "Multibrowser"
            addressBar.text = ""
        }
    }
    
    // MARK: - WebView actions
    @objc func addWebView() {
        let webView = WKWebView()
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
        updateUI(for: webView)
    }
    
    @objc func deleteWebView() {
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.index(of: webView) {
                stackView.removeArrangedSubview(webView)
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                    addressBar.text = nil
                } else {
                    var currentIndex = Int(index)
                    
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    @objc func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        
        updateUI(for: webView)
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func webViewDidFinishLoad(_ webView: WKWebView) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    // MARK: - Trigger gestures along with system gestures
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Load user entered url on keyboard return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

