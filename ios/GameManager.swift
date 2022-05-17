//
//  GameManager.swift
//  CounterApp
//
//  Created by Volodymyr Nazarkevych on 04.05.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

enum SelectedButton {
  case left
  case right
}

enum Constants {
  static let lowTimeInterval: TimeInterval = 0.5
  static let moreTimeInterval: TimeInterval = 2
}

protocol GameManagerProtocol: AnyObject {
  func updateText(text: String, color: UIColor)
  func updateTime(time: String)
  func setEnableButton(isEnable: Bool)
}

class GameManager {

  private var text: String = ""

  private var timerSetText: Timer?
  private var timeResponse: Timer?

  private var countTest = 0

  private var startDate: Date?
  private var arrayTimes: [Double] = []

  private var isFirst = true

  weak var delegate: GameManagerProtocol?

  func startLogicTimer() {
    timerSetText = Timer.scheduledTimer(timeInterval: Constants.lowTimeInterval, target: self, selector: #selector(setText), userInfo: nil, repeats: false)
  }

  private func randomString(length: Int = 5) -> String {
    let letters: NSString = "<>"
    let len = UInt32(letters.length)

    var randomString = ""

    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }

    return randomString
  }

  func checkedAnswer(button: SelectedButton) {
    timeResponse?.invalidate()
    timerSetText?.invalidate()
    delegate?.setEnableButton(isEnable: false)
    if let startDate = startDate {
      let resultTime = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
      arrayTimes.append(resultTime)
      self.startDate = nil
      delegate?.updateTime(time: String(format: "%.3f", resultTime))
    }

    let textArray = Array(text)
    switch button {
    case .left:
      if textArray[2] == "<" {
        delegate?.updateText(text: "Correct", color: .green)
      } else {
        delegate?.updateText(text: "Failed", color: .red)
      }
    case .right:
      if textArray[2] == ">" {
        delegate?.updateText(text: "Correct", color: .green)
      } else {
        delegate?.updateText(text: "Failed", color: .red)
      }
    }
//    if countTest == 5 {
//      countTest = 0
//      let sumArray = arrayTimes.reduce(0, +)
//      let avgArray = sumArray / Double(arrayTimes.count)
//      delegate?.updateText(text: "-----", color: .black)
//
//      let alert = UIAlertController(title: "Game over", message: "You average time: \(String(format: "%.3f", avgArray)) ms. \n Do you want start new game?", preferredStyle: UIAlertController.Style.alert)
//      alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [weak self] _ in
//        guard let self = self else { return }
//        self.startLogicTimer()
//      }))
//      alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
//      //          self.present(alert, animated: true, completion: nil)
//      return
//    }
    Timer.scheduledTimer(timeInterval: Constants.lowTimeInterval, target: self, selector: #selector(self.setDefaultText), userInfo: nil, repeats: false)
  }

  @objc func setDefaultText() {
    delegate?.updateText(text: "-----", color: .black)
    startLogicTimer()
  }

  @objc func setText() {
    delegate?.setEnableButton(isEnable: true)
    self.text = randomString()
    delegate?.updateText(text: self.text, color: .black)
    self.countTest += 1
    self.startDate = Date()
    timeResponse = Timer.scheduledTimer(timeInterval: Constants.moreTimeInterval, target: self, selector: #selector(self.timeResponseFailed), userInfo: nil, repeats: false)
  }

  @objc func timeResponseFailed() {
    delegate?.updateText(text: "Time response failed", color: .black)
    Timer.scheduledTimer(timeInterval: Constants.lowTimeInterval, target: self, selector: #selector(self.setDefaultText), userInfo: nil, repeats: false)
  }
}
