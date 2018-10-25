//
//  AlertViewModel.swift
//  C2H
//
//  Created by Farooq Zaman on 02/04/2018.
//  Copyright © 2018 TMS Software Sdn Bhd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import BonMot

struct AlertViewModel{
    let sceneCoordinator: SceneCoordinatorType
    let title:Variable<NSAttributedString?>
    let message:Variable<NSAttributedString?>
    let titlePrimaryButton:Variable<String?>
    let titleSecondaryButton:Variable<String?>
    let onPrimary: CocoaAction
    let onSecondary: CocoaAction

    static let titleStyle = StringStyle(
        .font(UIFont.pt14BodyDark),
        .minimumLineHeight(24),
        .alignment(.center),
        .color(.dusk)
    )
    
    static let bodyStyle = StringStyle(
        .font(UIFont.pt13SmallTextLight),
        .minimumLineHeight(18),
        .alignment(.center),
        .color(.blueyGrey)
    )

    init(coordinator: SceneCoordinatorType,
         title:NSAttributedString? = nil,
         message:NSAttributedString? = nil,
         titlePrimaryButton:String,
         titleSecondaryButton:String? = nil,
         primaryAction:CocoaAction? = nil,
         secondaryAction:CocoaAction? = nil) {
        
        self.sceneCoordinator = coordinator
        self.title = Variable(title)
        self.message = Variable(message)
        self.titlePrimaryButton = Variable(titlePrimaryButton)
        self.titleSecondaryButton = Variable(titleSecondaryButton)

        onPrimary = CocoaAction {
            return coordinator.pop()
                .do(onCompleted:{
                    if let primaryAction = primaryAction {
                        primaryAction.execute(())
                    }
                })
        }
        
        onSecondary = CocoaAction {
            return coordinator.pop()
                .do(onCompleted:{
                    if let secondaryAction = secondaryAction {
                        secondaryAction.execute(())
                    }
                })
        }
    }
}

//MARK :- Utility functions to create alerts
extension AlertViewModel{
    
    //Title & body String
    public static func create(coordinator: SceneCoordinatorType,
                              title:String,
                              message:String? = nil,
                              titlePrimaryButton:String,
                              primaryAction:CocoaAction? = nil) -> Observable <Void>{
        return create(coordinator: coordinator,
                  title: title.styled(with: AlertViewModel.titleStyle),
                  message: message?.styled(with: AlertViewModel.bodyStyle),
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: nil,
                  primaryAction: primaryAction,
                  secondaryAction: nil)
    }
    
    //Title String, body NSAttributed String
    public static func create(coordinator: SceneCoordinatorType,
                                   title:String,
                                   message:NSAttributedString? = nil,
                                   titlePrimaryButton:String,
                                   primaryAction:CocoaAction? = nil) -> Observable<Void> {
        return create(coordinator: coordinator,
                  title: title.styled(with: AlertViewModel.titleStyle),
                  message: message,
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: nil,
                  primaryAction: primaryAction,
                  secondaryAction: nil)
    }
    
    //Title & Body NSAttributed String
    public static func create(coordinator: SceneCoordinatorType,
                                   title:NSAttributedString,
                                   message:NSAttributedString? = nil,
                                   titlePrimaryButton:String,
                                   primaryAction:CocoaAction? = nil) -> Observable<Void> {
        return create(coordinator: coordinator,
                  title: title,
                  message: message,
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: nil,
                  primaryAction: primaryAction,
                  secondaryAction: nil)
    }
        
    //Title & body String
    public static func create(coordinator: SceneCoordinatorType,
                                   title:String,
                                   message:String? = nil,
                                   titlePrimaryButton:String,
                                   titleSecondaryButton:String,
                                   primaryAction:CocoaAction)->Observable<Void> {
        
        return create(coordinator: coordinator,
                  title: title.styled(with: AlertViewModel.titleStyle),
                  message: message?.styled(with: AlertViewModel.bodyStyle),
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: titleSecondaryButton,
                  primaryAction: primaryAction,
                  secondaryAction: nil)
    }
    
    //Title String, body NSAttributed String
    public static func create(coordinator: SceneCoordinatorType,
                                   title:String,
                                   message:NSAttributedString? = nil,
                                   titlePrimaryButton:String,
                                   titleSecondaryButton:String,
                                   primaryAction:CocoaAction,
                                   secondaryAction:CocoaAction) -> Observable<Void>{
        return create(coordinator: coordinator,
                  title: title.styled(with: AlertViewModel.titleStyle),
                  message: message,
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: titleSecondaryButton,
                  primaryAction: primaryAction,
                  secondaryAction: secondaryAction)
    }
    
    //Title NSAttributed String, body String
    public static func create(coordinator: SceneCoordinatorType,
                              title:NSAttributedString,
                              message:String? = nil,
                              titlePrimaryButton:String,
                              titleSecondaryButton:String,
                              primaryAction:CocoaAction,
                              secondaryAction:CocoaAction) -> Observable<Void>{
        return create(coordinator: coordinator,
                      title: title,
                      message: (message ?? "").styled(with: AlertViewModel.bodyStyle),
                      titlePrimaryButton: titlePrimaryButton,
                      titleSecondaryButton: titleSecondaryButton,
                      primaryAction: primaryAction,
                      secondaryAction: secondaryAction)
    }
    
    //Title & Body NSAttributed String
    public static func create(coordinator: SceneCoordinatorType,
                                   title:NSAttributedString,
                                   message:NSAttributedString? = nil,
                                   titlePrimaryButton:String,
                                   titleSecondaryButton:String,
                                   primaryAction:CocoaAction) -> Observable <Void> {
        return create(coordinator: coordinator,
                  title: title,
                  message: message,
                  titlePrimaryButton: titlePrimaryButton,
                  titleSecondaryButton: titleSecondaryButton,
                  primaryAction: primaryAction,
                  secondaryAction: nil)
    }
    
    public static func create(coordinator: SceneCoordinatorType,
                                   title:NSAttributedString? = nil,
                                   message:NSAttributedString? = nil,
                                   titlePrimaryButton:String,
                                   titleSecondaryButton:String? = nil,
                                   primaryAction:CocoaAction? = nil,
                                   secondaryAction:CocoaAction? = nil) -> Observable<Void>{
        
        let alertViewModel = AlertViewModel(coordinator: coordinator,
                                            title: title,
                                            message: message,
                                            titlePrimaryButton:titlePrimaryButton,
                                            titleSecondaryButton:titleSecondaryButton,
                                            primaryAction:primaryAction,
                                            secondaryAction:secondaryAction)
        
        return coordinator.transition(to: Scene.alert(alertViewModel), type: .alert)
    }
    
    public static func createPushNotificationAlert(coordinator: SceneCoordinatorType,
                                                   payload:NSDictionary?,
                                                   titlePrimaryButton:String,
                                                   titleSecondaryButton:String? = nil,
                                                   primaryAction:CocoaAction? = nil,
                                                   secondaryAction:CocoaAction? = nil) -> Observable<Void>{
        
        let title = payload?.value(forKeyPath: "aps.alert.title") as? String ?? ""
        let body = payload?.value(forKeyPath: "aps.alert.body") as? String ?? ""
        
        return AlertViewModel.create(coordinator: coordinator,
                                     title: title.styled(with: AlertViewModel.titleStyle),
                                     message: body.styled(with: AlertViewModel.titleStyle),
                                     titlePrimaryButton:titlePrimaryButton,
                                     titleSecondaryButton:titleSecondaryButton,
                                     primaryAction:primaryAction,
                                     secondaryAction:secondaryAction)
    }
}
