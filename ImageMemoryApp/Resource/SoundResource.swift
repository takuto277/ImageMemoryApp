//
//  SoundResource.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/25.
//

import Foundation
import AVFoundation

class SoundResource {
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    
    init?() {
        // 正解の音声ファイルを設定
        if let correctSoundURL = Bundle.main.url(forResource: "Correct_sound", withExtension: "mp3") {
            do {
                correctSoundPlayer = try AVAudioPlayer(contentsOf: correctSoundURL)
            } catch {
                print("正解の音声ファイルを読み込めません: \(error.localizedDescription)")
            }
        }
        
        // 不正解の音声ファイルを設定
        if let wrongSoundURL = Bundle.main.url(forResource: "Wrong_sound", withExtension: "mp3") {
            do {
                wrongSoundPlayer = try AVAudioPlayer(contentsOf: wrongSoundURL)
            } catch {
                print("不正解の音声ファイルを読み込めません: \(error.localizedDescription)")
            }
        }
    }
    
    func playCorrenctSound() {
        // 正解の音声を再生
        correctSoundPlayer?.play()
    }
    
    func playWrongSound() {
        // 不正解の音声を再生
        wrongSoundPlayer?.play()
    }
}
