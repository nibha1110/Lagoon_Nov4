//
//  EditCommentView.swift
//  Crocodile
//
//  Created by Nibha Aggarwal on 8/5/16.
//  Copyright © 2016 Nibha Aggarwal. All rights reserved.
//

import UIKit

protocol EditCommentProtocol: class {
    func cancelComment()
    func DoneComment(textview: String!)
}

class EditCommentView: UIView, UITextViewDelegate {
    @IBOutlet weak var textView_comment: UITextView!
    var delegate:EditCommentProtocol!
    var Str_date: NSString!
    var keyboardWillHide: Bool! = false
    var bool_textfield: Bool! = false
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EditCommentView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    override func drawRect(rect: CGRect) {
        
        
        textView_comment.delegate = self
        // Keyboard Hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillHideNotification, object: nil)

    }

    func showCommentView(view1: UIView, frame1: CGRect) -> UIView
    {
        self.frame = frame1
        view1.addSubview(self)
        self.alpha = 0
        let transitionOptions = UIViewAnimationOptions.CurveEaseIn
        UIView.transitionWithView(self, duration: 0.4, options: transitionOptions, animations: {
            self.alpha = 1
            
            }, completion: { finished in
                
                // any code entered here will be applied
                // .once the animation has completed
        })
        return self
    }
    
    func removeCommentView(view1: UIView) -> UIView
    {
        let transitionOptions = UIViewAnimationOptions.CurveEaseOut
        UIView.transitionWithView(self, duration: 0.4, options: transitionOptions, animations: {
            self.alpha = 0
            
            }, completion: { finished in
                self.removeFromSuperview()
                // any code entered here will be applied
                // .once the animation has completed
        })
        
        return self
    }
    
    
    @IBAction func CancelComment_btnAction(sender: AnyObject) {
        self.delegate.cancelComment()
    }
    
    @IBAction func DoneComment_btnAction(sender: AnyObject) {
        self.delegate.DoneComment(textView_comment.text as String)
    }

    
    // MARK: - Textview delegates
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.keyboardWillHide = true
        if textView == textView_comment {
            UIView.animateWithDuration(0.6, animations: {() -> Void in
                self.frame = CGRectMake(0, -180, 1024, 748)
                }, completion: {(finished: Bool) -> Void in
                    self.bool_textfield = true
            })
        }
        textView_comment.becomeFirstResponder()
    }
    
    
    // MARK: - Keyboard hide
    
    
    func keyboardWillShow() {
        if keyboardWillHide == true{
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.frame = CGRectMake(0, 20, 1024, 748)
                }, completion: {(finished: Bool) -> Void in
            })
        }
        self.keyboardWillHide = false
    }
}
