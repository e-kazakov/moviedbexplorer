//
//  KeyboardObserver.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 21.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

struct KeyboardInfo {
  let animationCurve: UIView.AnimationCurve
  let animationDuration: Double
  let beginFrame: CGRect
  let endFrame: CGRect
}

extension KeyboardInfo {
  init?(from notification: Notification) {
    let name = notification.name
    let userInfo = notification.userInfo
    
    guard name == UIResponder.keyboardWillShowNotification || name == UIResponder.keyboardWillChangeFrameNotification,
      let curveValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
      let durationValue = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let beginFrameBoxedValue = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
      let endFrameBoxedValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
      else { return nil }
    
    animationCurve = UIView.AnimationCurve(rawValue: curveValue)!
    animationDuration = durationValue
    beginFrame = beginFrameBoxedValue.cgRectValue
    endFrame = endFrameBoxedValue.cgRectValue
  }
}

class KeyboardObserver {
  
  private let notificationCenter: NotificationCenter
  
  var onKeyboardWillShow: ((KeyboardInfo) -> Void)?
  var onKeyboardWillHide: (() -> Void)?
  
  init(notificationCenter: NotificationCenter) {
    self.notificationCenter = notificationCenter
  }
  
  func startObserving() {
    notificationCenter.addObserver(self,
                                   selector: #selector(keyboardWillShow),
                                   name: UIResponder.keyboardWillShowNotification,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(keyboardWillHide),
                                   name: UIResponder.keyboardWillHideNotification,
                                   object: nil)
  }
  
  func stopObserving() {
    notificationCenter.removeObserver(self)
  }
  
  @objc
  private func keyboardWillShow(notification: Notification) {
    guard let keyboardInfo = KeyboardInfo(from: notification) else { return }
    
    onKeyboardWillShow?(keyboardInfo)
  }

  @objc
  private func keyboardWillHide(notification: Notification) {
    onKeyboardWillHide?()
  }
  
}
