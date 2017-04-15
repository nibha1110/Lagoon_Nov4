//
//  CalendarView.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 6/16/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

protocol CalendarProtocol: class {
    func cancelCalendar()
    func DoneCalendar(dateSelected: String!)
    
}

class CalendarView: UIView {
    @IBOutlet weak var picker_Date: UIDatePicker!
    var delegate:CalendarProtocol!
    var Str_date: NSString!
    var SStr_date: NSString!
    let dateForm: NSDateFormatter = NSDateFormatter()
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CalendarView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    override func drawRect(rect: CGRect) {
        
        
    }
    
    func todaydate() -> NSString
    {
        let date: NSDate! = NSDate()
        picker_Date.setDate(date, animated: true)
        picker_Date.maximumDate = date
        
        
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateForm.locale = twelveHourLocale
        dateForm.dateFormat = "dd/MM/yyyy"
        print("\(dateForm.stringFromDate(NSDate()))")
        Str_date = "  \(dateForm.stringFromDate(NSDate()))"
        return Str_date
    }
    
    func daysBetweenDate(currentstrDate: NSString!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = -1
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateForm.locale = twelveHourLocale
        dateForm.dateFormat = "dd/MM/yyyy"
        currentDate = dateForm.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        SStr_date = "  \(dateForm.stringFromDate(newDate))"
        return SStr_date
    }
    
    func daysBetweenDateMonth(currentstrDate: NSString!) -> NSString {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = -1
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        var currentDate: NSDate! = NSDate()
        let twelveHourLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateForm.locale = twelveHourLocale
        dateForm.dateFormat = "dd/MM/yyyy"
        currentDate = dateForm.dateFromString(currentstrDate as String)
        
        let newDate: NSDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        SStr_date = "\(dateForm.stringFromDate(newDate))"
        return SStr_date
    }
    
    
    func showDateView(view1: UIView, frame1: CGRect) -> UIView
    {
        self.frame = frame1
        view1.addSubview(self)
        self.alpha = 0
        let transitionOptions = UIViewAnimationOptions.TransitionCurlDown
        UIView.transitionWithView(self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 1
            
            }, completion: { finished in
                
                // any code entered here will be applied
                // .once the animation has completed
        })
        return self
    }
    
    func removeDateView(view1: UIView) -> UIView
    {
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
        UIView.transitionWithView(self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 0
            
            }, completion: { finished in
                self.removeFromSuperview()
                // any code entered here will be applied
                // .once the animation has completed
        })
        
        return self
    }
    
    
    @IBAction func picker_DateChanged(sender: AnyObject) {
        dateForm.dateFormat = "dd/MM/yyyy"
        Str_date = "  \(dateForm.stringFromDate(picker_Date.date))"
        print(Str_date)
    }
    
    @IBAction func Cancel_BtnAction(sender: AnyObject)
    {
        self.delegate.cancelCalendar()
    }

    
    @IBAction func Done_BtnAction(sender: AnyObject) {
        self.delegate.DoneCalendar(Str_date as String)
        
    }
}
