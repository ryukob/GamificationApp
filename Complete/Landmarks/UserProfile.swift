//
//  userProfile.swift
//  Landmarks
//
//  Created by ryu fukushima on 2021/01/30.
//  Copyright © 2021 Apple. All rights reserved.
//
import SwiftUI

class UserProfile: ObservableObject {
    
    /// タスク名
    @Published var taskName: String {
        didSet {
            UserDefaults.standard.set(taskName, forKey: "taskName")
        }
    }
    /// タスク登録状況
    @Published var isTaskRegisted: Bool {
        didSet {
            UserDefaults.standard.set(isTaskRegisted, forKey: "isTaskRegisted")
        }
    }
    /// タスク実行状況
    @Published var isTaskDone: Bool {
        didSet {
            UserDefaults.standard.set(isTaskDone, forKey: "isTaskDone")
        }
    }
    
    /// レベル
    @Published var level: Int {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }
    }/// 前のレベル
    @Published var exLevel: Int {
        didSet {
            UserDefaults.standard.set(exLevel, forKey: "exLevel")
        }
    }
    
    ///レベルアップまでの必要経験値
    @Published var needForLevelUpExp: Double {
        didSet {
            UserDefaults.standard.set(needForLevelUpExp, forKey: "needForLevelUpExp")
        }
    }
    ///前のレベルアップまでの必要経験値
    @Published var exNeedForLevelUpExp: Double {
        didSet {
            UserDefaults.standard.set(exNeedForLevelUpExp, forKey: "exNeedForLevelUpExp")
        }
    }
    
    ///　レベルアップ後取得経験値
    @Published var currentExpAfterLevelUp: Double {
        didSet {
            UserDefaults.standard.set(currentExpAfterLevelUp, forKey: "currentExpAfterLevelUp")
        }
    }
    ///　タスク実行前のレベルアップ後取得経験値
    @Published var exCurrentExpAfterLevelUp: Double {
        didSet {
            UserDefaults.standard.set(exCurrentExpAfterLevelUp, forKey: "exCurrentExpAfterLevelUp")
        }
    }
    
    
    /// 次回取得経験値
    @Published var nextExp: Double {
        didSet {
            UserDefaults.standard.set(nextExp, forKey: "nextExp")
        }
    }
    
    /// 前回取得経験値
    @Published var previousExp: Double {
        didSet {
            UserDefaults.standard.set(previousExp, forKey: "previousExp")
        }
    }
    
    /// 継続日数
    @Published var continuousDays: Int {
        didSet {
            UserDefaults.standard.set(continuousDays, forKey: "continuousDays")
        }
    }
    
    /// 更新日時
    @Published var updateTime: DateComponents {
        didSet {
            let encoder = JSONEncoder()
            if let encodedValue = try? encoder.encode(updateTime) {
                UserDefaults.standard.set(encodedValue, forKey: "updateTime")
            }

        }
    }
    
    /// 初期化処理
    init() {
        UserDefaults.standard.register(defaults: ["level" : 1, "nextExp" : ExpCalculator.getNextExp(continuousDays: 1),"needForLevelUpExp" : ExpCalculator.getNeedForLevelUpExp()] )
        taskName = UserDefaults.standard.string(forKey: "taskName") ?? ""
        isTaskRegisted = UserDefaults.standard.object(forKey:  "isTaskRegisted") as? Bool ?? false
        isTaskDone = UserDefaults.standard.object(forKey:  "isTaskDone") as? Bool ?? false
        nextExp = UserDefaults.standard.double(forKey: "nextExp")
        previousExp = UserDefaults.standard.double(forKey: "previousExp")
        continuousDays = UserDefaults.standard.integer(forKey: "continuousDays")
        level = UserDefaults.standard.integer(forKey: "level")
        exLevel = UserDefaults.standard.integer(forKey: "exLevel")
        needForLevelUpExp = UserDefaults.standard.double(forKey: "needForLevelUpExp")
        exNeedForLevelUpExp = UserDefaults.standard.double(forKey: "exNeedForLevelUpExp")
        currentExpAfterLevelUp = UserDefaults.standard.double(forKey: "currentExpAfterLevelUp")
        exCurrentExpAfterLevelUp = UserDefaults.standard.double(forKey: "exCurrentExpAfterLevelUp")
        
        
        // DateComponentsを保存するための処理 はじめ
        if let savedValue = UserDefaults.standard.data(forKey: "updateTime") {
            let decoder = JSONDecoder()
            if let value = try? decoder.decode(DateComponents.self, from: savedValue) {
                updateTime = value
            } else{
                updateTime = DateComponents()/// 値がない場合の処理
                print("[例外エラー]updateTimeの構造が壊れています。")
            }
        } else {
            updateTime = DateComponents()/// 値がない場合の処理
        }
        // DateComponentsを保存するための処理 おわり
    }
}
