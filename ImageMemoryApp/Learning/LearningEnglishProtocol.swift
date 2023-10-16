//
//  LearningProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/01.
//

import Foundation

protocol LearningEnglishProtocol: AnyObject {
    func attachView(_ view: LearningEnglishViewControllerProtocol)
    func textReading(_ text: String)
    func confirmCorrection(_ selectedLeft: Bool)
    func selectedKnowButton()
    func selectedUnknownButton()
    func checkNextNumber()
}

protocol LearningEnglishViewControllerProtocol: AnyObject {
    func fadeOutAndChangeInfo(_ randomValue: Bool, _ wordData: WordData, _ fakeImage: String, _ currentNumber: Int, completion: (() -> Void)?)
    func fadeInInfo()
    func textReading(_ text: String)
    func navigationToDetailWordScreen(_ wordData: WordData)
    func navigationToResultScreen()
    func finishedCurrentWordDataProcess()
}
