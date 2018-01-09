//
//  ViewController.swift
//  VSTwitterTextCounter
//
//  Created by Shady Elyaski on 01/04/2018.
//  Copyright (c) 2018 Dynamic Signal. All rights reserved.
//

import UIKit
import VSTwitterTextCounter

class ViewController: UIViewController
{
    @IBOutlet weak var twitterTextView: UITextView!
    @IBOutlet weak var twitterTextCounter: VSTwitterTextCounter!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        twitterTextView.layer.borderWidth = 0.5
        twitterTextView.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        unregisterForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func tweetButtonPressed(_ sender: Any)
    {
        twitterTextView.text = ""   // Reset text
        textViewDidChange(twitterTextView)  // Update counters
        twitterTextView.resignFirstResponder()  // Dismiss Keyboard
    }
    
    // MARK: - Keyboard
    
    func registerForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterForKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            {
                UIView.animate(withDuration: duration, animations: {
                    self.bottomLayoutConstraint.constant = keyboardSize.height + 20
                    self.view.layoutSubviews()
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
        {
            UIView.animate(withDuration: duration, animations: {
                self.bottomLayoutConstraint.constant = 20
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        /**
         Use Twitter's weightedLength to measure the characters left
         It should look like that:
         let weightedLength = TwitterTextParser.defaultParser().parseTweet(textView.text).weightedLength
         But for now we will use the following:-
         */
        let weightedLength = NSString(string: textView.text).length
        twitterTextCounter.update(with: textView, textWeightedLength: weightedLength)
    }
}

