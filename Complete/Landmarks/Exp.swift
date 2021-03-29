//
//  Exp.swift
//  Landmarks
//
//  Created by ryu fukushima on 2021/03/13.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import Numerics

class ExpCalculator{
    static let levelUpRate: Double = 100

    class func getNextExp(continuousDays: Int) -> Double{
        let baseExp: Double = 25
        let peakLevel: Double = 60
        let peakDays: Double = 60
        var nextExp: Double = 0

        // ベースの経験値を取得
        nextExp += baseExp
        // ボーナス分の取得
        let temp = (peakLevel * levelUpRate - peakDays * baseExp)
        nextExp += temp / 27.4 / (1.0 + sigmoid(continuousDays: continuousDays))
        
        print(nextExp)
        return nextExp
        }
    
    // シグモイドの部分を計算
    class func sigmoid(continuousDays: Int) -> Double{
        let sigmoid_a: Double = 3
        return exp(-1.0 * (sigmoid_a*((Double(continuousDays)-30.0)/30.0)))
    }
    
    // 最後のレベルアップから，次のレベルアップまでの経験値計算
    class func getNeedForLevelUpExp() ->Double{
        return self.levelUpRate
    }
}
