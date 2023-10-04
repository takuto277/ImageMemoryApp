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
    func confirmCorrection(_ correction: Bool)
    func updateCurrentWordData(_ wordData: WordData, _ correction: Bool)
    func checkNextNumber(_ wordDataCount: Int, _ currentCount: Int)
}

protocol LearningEnglishViewControllerProtocol: AnyObject {
    func fadeOutAndChangeInfo()
    func fadeInInfo()
    func textReading(_ text: String)
    func navigationToScreen()
    func getCurrentWordData(_ correction: Bool)
    func finishedCurrentWordDataProcess()
}
