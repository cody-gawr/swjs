//
//  ComposeEmail.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/12/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

let placeholderText = "Tell us what you are thinking..."

class ComposeEmailController: UIViewController, UITextViewDelegate {
    
    lazy var messageTextField: UITextView = {
        let textField = UITextView()
        textField.delegate = self
        textField.isScrollEnabled = true
        textField.isUserInteractionEnabled = true
        textField.autocapitalizationType = .sentences
        let borderColor = PRIMARY_COLOR_PURPLE
        textField.layer.borderColor = borderColor.cgColor
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.autocorrectionType = .yes
        textField.spellCheckingType = .yes
        textField.text = placeholderText
        textField.textColor = .lightGray
        textField.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = PRIMARY_COLOR_PURPLE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Feedback", for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(nil, action: #selector(sendEmail), for: .touchUpInside)
        return button
    }()
    
    let api: APIClient?
    let reviewType: String?
    
    init(reviewType: String, client: APIClient) {
        self.reviewType = reviewType
        self.api = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        title = "Send Feedback"
        hideKeyboardWhenTappedAround()
        
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // if the user navigates back home make sure we reset our flag
        Session.current().viewController?.isShowingReview = false
    }
    
    func setupViews() {
        view.addSubview(messageTextField)
        view.addSubview(sendButton)
        
        _ = messageTextField.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 64 + 32, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 250)
        _ = sendButton.anchor(messageTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 64, bottomConstant: 0, rightConstant: 64, widthConstant: 0, heightConstant: 48)
    }
    
    @objc func sendEmail() {
        let params:NSDictionary = ["message" : messageTextField.text,
                                   "os"      : "iOS"]
        
        Session.current().viewController?.isShowingReview = false
        api!.updateFeedbackStatus(reviewRequestStatus: 1, reviewType: reviewType!)
        api!.sendCustomerFeedback(params: params, success: { (responseObject) in
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            // Act like we send the email if this fails
            //self.navigationController?.popViewController(animated: true)
            debugPrint(error.localizedDescription)
        }
        
    }
    
    
    //MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == placeholderText) {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let line = textView.caretRect(for: (textView.selectedTextRange?.start)!)
        let overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top)
        if overflow > 0 {
            var offset = textView.contentOffset
            offset.y += overflow + 8
            UIView.animate(withDuration: 0.2, animations: {
                textView.setContentOffset(offset, animated: true)
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
