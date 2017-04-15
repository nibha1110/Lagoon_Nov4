//
//  webservice.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 4/18/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import Foundation
import UIKit

@objc protocol responseProtocol {
    func responseDictionary(dic :NSMutableDictionary)
    optional func responseDictionaryDelta(dic :NSMutableDictionary)
    func NetworkLost(str: String!)
}

class webservice: UIViewController
{
    var delegate:responseProtocol!
    var appDel : AppDelegate!
    
    
    func callServiceCommon(request: NSMutableURLRequest!, postString: String!)
    {
        request.HTTPMethod = "POST"
        request.timeoutInterval = 15
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                if data == nil && response == nil{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("netLost")
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("noResponse")
                    }
                }
                
                print("error=\(error)")
                return
            }
            
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                self.appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.NetworkLost("noResponse")
                }
                return
            }
            
            
            do {
                
                let resposeDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                print(resposeDictionary)
                 dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.responseDictionary(resposeDictionary.mutableCopy() as! NSMutableDictionary)
                }
                
            }
            catch let error as NSError {
                print("error: \(error.localizedDescription)")
                
            }}
        task.resume()
    }
    

    func callServiceCommon_inspection(request: NSMutableURLRequest!, postString: String!)
    {
        request.HTTPMethod = "POST"
        //        request.timeoutInterval = 20
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                if data == nil && response == nil{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("netLost")
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("noResponse")
                    }
                }
                
                print("error=\(error)")
                return
            }
            
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                self.appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.NetworkLost("noResponse")
                }
                return
            }
            
            
            do {
                
                let resposeDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                                print(resposeDictionary)
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.responseDictionary(resposeDictionary.mutableCopy() as! NSMutableDictionary)
                }
                
            }
            catch let error as NSError {
                print("error: \(error.localizedDescription)")
                
            }}
        task.resume()
    }

    
    func callServiceCommon_Delta(request: NSMutableURLRequest!, postString: String!)
    {
        request.HTTPMethod = "POST"
        //        request.timeoutInterval = 20
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                if data == nil && response == nil{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("netLost")
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.NetworkLost("noResponse")
                    }
                }
                
                print("error=\(error)")
                return
            }
            
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                self.appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.NetworkLost("noResponse")
                }
                return
            }
            
            
            do {
                
                let resposeDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                                print(resposeDictionary)
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.responseDictionaryDelta!(resposeDictionary.mutableCopy() as! NSMutableDictionary)
                }
                
            }
            catch let error as NSError {
                print("error: \(error.localizedDescription)")
                
            }}
        task.resume()
    }

    
    
    func post(params : NSMutableDictionary!, url : String) {
        print(params)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        

        let data = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(string)
        do{
            
        }
        catch{
            
        }
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        }
        catch let error as NSError {
            print("error: \(error.localizedDescription)")
            
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            if response == nil
            {
                self.delegate.NetworkLost("noResponse")
            }
//            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("Body: \(strData)")
            
            if error != nil
            {
                // logs result in background...
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    print(error)
                });
                return
            }
            else
            {
                let strtemp : String = String(data: data!, encoding: NSUTF8StringEncoding)! as String
                print(strtemp)
                do {
                    
                    let resposeDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                    print(resposeDictionary)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate.responseDictionary(resposeDictionary.mutableCopy() as! NSMutableDictionary)
                    }
                }
                catch {}
            }
        })
        task.resume()
    }
}
