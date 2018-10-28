//
//  ChatMessageCell.swift
//  Qu
//
//  Created by Farooq Zaman on 02/08/2017.
//  Copyright © 2017 Open Dynamics SDN BHD. All rights reserved.
//

import UIKit
import Action
import RxSwift

class Avatar:UIImageView{
    override open var intrinsicContentSize: CGSize{
        get{
            return CGSize(width: 45.0, height: 45.0)
        }
    }
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var svContainer: UIStackView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivLogoLeft: UIImageView!
    @IBOutlet weak var ivLogoRight: UIImageView!
    @IBOutlet weak var lblMessage: UITextView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var ivImage: UIImageView!

    var disposeBag = DisposeBag()
    
    func configure(with tweet: Tweet, at indexPath:IndexPath){
        print("Message: \(String(describing: tweet.message))")
        lblMessage.text = tweet.message
        lblTimeStamp.text = tweet.time?.lowercased()
        
        ivLogoRight.isHidden = false
        ivLogoLeft.isHidden = true
        svContainer.alignment = .trailing
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivLogoLeft.layer.borderWidth = 0.5
        ivLogoLeft.layer.borderColor = UIColor.dusk.cgColor

        ivLogoRight.layer.borderWidth = 0.5
        ivLogoRight.layer.borderColor = UIColor.dusk.cgColor
        
        lblMessage.isScrollEnabled = false
        lblMessage.isEditable = false
        lblMessage.isSelectable = true
    }

    override func prepareForReuse() {
        ivLogoRight.isHidden = true
        ivLogoLeft.isHidden = true
        ivImage.isHidden = true
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Cell Registration Methods
    class var cellIdentifier: String{
        return String(describing: self)
    }
    
    class func registerCellIdentifier(_ tableView:UITableView?){
        tableView?.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
    }
}
