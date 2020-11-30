//
//  CustomBrowser.swift
//  ARBasicSetUp
//
//  Created by Ajithram on 30/11/20.
//

import Foundation
import WebKit

class CustomBrowser: UIViewController {
    var webView: WKWebView = WKWebView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var url: String? = ""
    var titleName: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpWebView()
        createActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    func setUpWebView() {
        if let loadUrl = URL(string: url ?? "")  {
            webView.load(URLRequest(url: loadUrl))
            webView.allowsBackForwardNavigationGestures = true
        }
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(canGoBack))
    }
    
    
    func executeJS(jsQuery: String = "") {
        webView.evaluateJavaScript(jsQuery, completionHandler: nil)
    }
    
    func setCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for (cookie) in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
    
    @objc func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func canGoBack(){
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = titleName
        executeJS()
        activityIndicator.stopAnimating()
        webView.isHidden = false
    }
}

// MARK: Call Functionality
extension CustomBrowser: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if ["tel", "sms", "facetime"].contains(url.scheme) && UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: Activity Indicator
extension CustomBrowser {
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    }
    
    func startAnimating(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimating(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

