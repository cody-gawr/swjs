//
//  MainViewController+helpers.swift
//  Autobrain
//
//  Created by Kyle Smith on 8/30/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

extension MainViewController: NSURLConnectionDataDelegate {
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("connection didFailWithError error: \(error)")
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        print("connection didReceiveResponse response: \(response)")
    }
    
    func connection(_ connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        
        print("connection didSendBodyData bytesWritten: \(bytesWritten)")
    }
}
