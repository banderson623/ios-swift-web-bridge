//
//  ViewController.swift
//  JamSlam
//
//  Created by Brian Anderson on 6/13/15.
//  Copyright (c) 2015 Brian Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!

  var isLoaded = false;

  // Execute javascript on the page
  // -------------------------------------------------------------
  func doJS(js: String) -> String{
    var result = "";
    if(isLoaded){
      println("Executing javascript: \(js)")
      result = webView.stringByEvaluatingJavaScriptFromString(js)!
    } else {
      println("Trying to run JS before it is loaded \(js)")
    }
    return result
  }

  // The protocol defined function for intercepting and inspecting
  // url requests made from the UIWebView. Returning true will
  // let the request be made, returning false cancels it.
  //
  // We use this to capture native calls!
  //
  func webView(webView: UIWebView,
    shouldStartLoadWithRequest request: NSURLRequest,
    navigationType nType: UIWebViewNavigationType) -> Bool {
      let urlString = request.URL?.absoluteString

      // If the string starts with 'ios:' then we know it is a call to a function here
      if (urlString!.substringToIndex(advance(urlString!.startIndex,4)) == "ios:") {
        let functionName = urlString!.substringFromIndex(advance(urlString!.startIndex,4))
        println("got an ios function call: \(functionName)")

        switch functionName {
        case "helloWorld":helloWorld()
        default : println("UNHANDLED \(functionName)")
        }

        // we do not want to actually leave the page when this is triggered
        return false
      }

      // make sure real requests are requested
      return true
  }

  // Callback when the webpage is finished loading
  func webViewDidFinishLoad(web: UIWebView){
    isLoaded = true
    println("Loading done!")

    let htmlTitle = doJS("document.title");
    println("Page title: " + htmlTitle)
  }

  func loadPage(){
    let localfilePath = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "html")
    let request = NSURLRequest(URL: localfilePath!)
    webView.loadRequest(request)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set this class as the delegate (basically meaning it the functions implimenting
    // the protocol (interface) will be found in this file
    webView.delegate = self
    loadPage()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func helloWorld() {
    println("Hello World from swift!")
  }


}

