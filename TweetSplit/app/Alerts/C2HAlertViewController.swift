//
//  QUAlertViewController.swift
//  Qu
//
//  Created by Farooq Zaman on 07/07/2017.
//  Copyright © 2017 Open Dynamics SDN BHD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class C2HAlertViewController: UIViewController, BindableType {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnPrimary: UIButton!
    @IBOutlet weak var btnSecondary: UIButton!
    
    var viewModel: AlertViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.vContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func bindViewModel() {
        btnPrimary.rx.action = viewModel.onPrimary
        btnSecondary.rx.action = viewModel.onSecondary
        
        viewModel.title.asDriver().drive(lblTitle.rx.attributedText).disposed(by: rx.disposeBag)
        viewModel.title.asDriver().map{$0 == nil ? true : false}.drive(lblTitle.rx.isHidden).disposed(by: rx.disposeBag)
        
        viewModel.message.asDriver().drive(lblMessage.rx.attributedText).disposed(by: rx.disposeBag)
        viewModel.message.asDriver().map{$0 == nil ? true : false}.drive(lblMessage.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.titlePrimaryButton.asDriver()
            .drive(onNext:{[weak self] title in
                self?.btnPrimary.setTitle(title, for: .normal)
            }).disposed(by: rx.disposeBag)
        
        viewModel.titlePrimaryButton.asDriver().map{$0 == nil ? true : false}.drive(btnPrimary.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.titleSecondaryButton.asDriver()
            .drive(onNext:{[weak self] title in
                self?.btnSecondary.setTitle(title, for: .normal)
            }).disposed(by: rx.disposeBag)
        
        viewModel.titleSecondaryButton.asDriver().map{$0 == nil ? true : false}.drive(btnSecondary.rx.isHidden).disposed(by: rx.disposeBag)
    }
    
    func initUI(){
        btnSecondary.layer.borderWidth = 1.0
        btnSecondary.layer.borderColor = UIColor.tealish.cgColor
        
        vContainer.addDropShadow(opacity:0.5, radius:4.0)
        vContainer.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
}
