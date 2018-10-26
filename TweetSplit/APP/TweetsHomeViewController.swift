//
//  TweetsHomeViewController.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 26/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxOptional

class TweetsHomeViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var tvMessage:UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lacMessageBottom: NSLayoutConstraint!
    @IBOutlet weak var vMessageContainer: UIView!
    @IBOutlet weak var lblStatus: UILabel!

    var viewModel: TweetsHomeViewModel!
    var messagePlaceholder : UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI(){
        addMessagePlaceholder()
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1);          //Invert table up-side-down
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tvMessage.layer.borderWidth = 0.5
        tvMessage.layer.borderColor = UIColor(white: 0.75, alpha: 1.0).cgColor
        tvMessage.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)

//        let nc = NotificationCenter.default
//        nc.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        nc.addObserver(self, selector:#selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func bindViewModel() {
        let messageObserver = tvMessage.rx.text
            .filterNil()
            .distinctUntilChanged()
            .do(onNext:{[weak self]_ in
                self?.tvMessage.invalidateIntrinsicContentSize()
            })
            .flatMap{message -> TweetObservable in
                message.getTweetObservable(limit: 50)
            }
            .share()
        
        messageObserver
            .map{$0.subTweets}
            .filterNil()
            .map{"\($0.count) tweets ...".styled(with: TextUtils.shared.tweetStatusStyle)}
            .bind(to: lblStatus.rx.attributedText)
            .disposed(by: rx.disposeBag)
        
        messageObserver
            .map{$0.error as? TSError}
            .filterNil()
            .map{$0.styledDescription.styled(with: TextUtils.shared.tweetStatusStyle)}
            .bind(to: lblStatus.rx.attributedText)
            .disposed(by: rx.disposeBag)
        
        messageObserver
            .map{message in
                return (( message.subTweets?.count ?? 0) == 0 || message.error != nil ) ? false : true
            }
            .startWith(false)
            .bind(to: btnSend.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        messageObserver
            .map{$0.message.isEmpty ? false : true}
            .bind(to: messagePlaceholder.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
}

//MARK:- UI Setup + Keyboard handling
extension TweetsHomeViewController{
    
    func addMessagePlaceholder(){
        messagePlaceholder = UILabel()
        messagePlaceholder.text = "Message"
        messagePlaceholder.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        messagePlaceholder.textColor = UIColor.blueyGrey
        messagePlaceholder.sizeToFit()
        tvMessage.addSubview(messagePlaceholder)
        messagePlaceholder.frame.origin = CGPoint(x: 8, y: (tvMessage.font?.pointSize)! / 2)
        messagePlaceholder.isHidden = !(tvMessage.text?.isEmpty ?? false)
    }
    
    @objc func keyboardDidShow(notification:Notification){
        if let info = notification.userInfo as? [String:AnyObject]{
            if var kbRect = info[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue{
                kbRect = self.view.convert(kbRect, from:nil)
                
                let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
                
                self.view.setNeedsLayout()
                lacMessageBottom.constant = kbRect.size.height
                self.view.setNeedsUpdateConstraints()
                
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                    self.view.layoutIfNeeded()
                }){ completed in
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification:Notification){
        tvMessage.resignFirstResponder()
        if let info = notification.userInfo as? [String:AnyObject]{
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            
            self.view.setNeedsLayout()
            lacMessageBottom.constant = 0
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
