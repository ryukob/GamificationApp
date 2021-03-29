//
//  TaskView.swift
//  Landmarks
//
//  Created by ryu fukushima on 2021/01/25.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    
    @ObservedObject var profile = UserProfile()
    @State var flag = false
    @Environment(\.scenePhase) private var scenePhase
    @State var myCal = Calendar(identifier: .gregorian)
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            HStack{
                //Header
                Text("Gamify")
                    .font(.custom("Arial Rounded MT Bold", size: 36))
                    .foregroundColor(Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
                Spacer()
            }
            .padding()
            .background(Color(red: 151/255, green: 206/255, blue: 204/255, opacity: 1))
            
            Spacer()
            
            //Level表示
            Text("Lv. " + String(profile.level))
                .font(.system(size: 64, weight: .bold , design: .default))
                .foregroundColor(Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
                .padding(.bottom, 10)
            
            
            //ProgressBar
            ProgressBar(value:profile.currentExpAfterLevelUp,maxValue:100)
                .frame(width:280, height:30)
            Spacer()
            
            Button(action: {
                print(profile.isTaskDone)
                print(profile.currentExpAfterLevelUp)
                
                // タスク実行時
                if !profile.isTaskDone {
                    // 現在値の保存 //////////
                    profile.exLevel = profile.level
                    profile.exCurrentExpAfterLevelUp = profile.currentExpAfterLevelUp
                    // 次のレベルアップまでに必要な経験値の更新前の値を保存
                    profile.exNeedForLevelUpExp = profile.needForLevelUpExp
                    
                    
                    
                    
                    // 記録更新 //////////////////
                    // 継続日数の更新
                    profile.continuousDays += 1
                    // 経験値の更新
                    profile.previousExp = profile.nextExp
                    // 経験値の取得
                    profile.currentExpAfterLevelUp += profile.nextExp
                    
                    // レベルアップ判定
                    while profile.currentExpAfterLevelUp > profile.needForLevelUpExp {
                        profile.level += 1
                        profile.currentExpAfterLevelUp -= profile.needForLevelUpExp
                        profile.needForLevelUpExp = ExpCalculator.getNeedForLevelUpExp()
                    }
                    
                    // 次回取得経験値の計算
                    profile.nextExp = ExpCalculator.getNextExp(continuousDays: profile.continuousDays + 1)
                    // 実行フラグを建てる
                    profile.isTaskDone.toggle()
                    
                    print(profile.currentExpAfterLevelUp)
                    
                    // 次回更新日時を計算するため，21時間後のdataComponentsを取得
//                    let late3h = myCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(60 * 60 * (24-3)))
                    let late3h = myCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(1))
                    // 次回更新日時の取得と格納
                    var kousin = late3h
//                    kousin.hour = 3
//                    kousin.minute = 0
//                    kousin.second = 0
                    profile.updateTime = kousin
                }
                else{
                    // アラートのフラグを立てる
                    self.showingAlert = true
                }
            }){
                VStack{
                    Spacer()
                    
                    Text(profile.taskName)
                        .font(.system(size: 36, weight: .bold , design: .default))
                    
                    Text("next exp：" + String(format: "%.0f",profile.nextExp))
                        .font(.system(size: 18, weight: .light , design: .default))
                    
                    Spacer()
                    
                    Text("継続日数：" + String(profile.continuousDays) + "日")
                        .font(.system(size: 18, weight: .regular , design: .default))
                    
                    Spacer()
                    
                }
                .frame(width: 280.0, height: 280.0)
                .foregroundColor(profile.isTaskDone ? Color.white : Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
                .background(
                    profile.isTaskDone ? Color(red: 18/255, green: 144/255, blue: 142/255, opacity: 1) : Color(red: 151/255, green: 206/255, blue: 204/255, opacity: 1)
                )
                .cornerRadius(48.0)
                
            }.alert(isPresented: $showingAlert){
                Alert(title: Text("本日分の実行を\n取り消しますか？"),
                      primaryButton: .cancel(Text("いいえ")),    // キャンセル用
                      secondaryButton: .destructive(Text("はい"),
                                                    action: {
                                                        profile.isTaskDone = false
                                                        profile.nextExp = profile.previousExp
                                                        profile.continuousDays-=1
                                                        profile.currentExpAfterLevelUp = profile.exCurrentExpAfterLevelUp
                                                        profile.level = profile.exLevel
                                                        profile.needForLevelUpExp = profile.exNeedForLevelUpExp
                                                    }
                                                    
                                                    
                      )
                )   // 破壊的変更用
            }
            
            
            Spacer()
            
        }
        .padding(.bottom, 10)
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                print("バックグラウンド！")
            }
            if phase == .active {
                
                // 現在日時の取得
                let now = myCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                
                // デバッグ用
                print("フォアグラウンド！" ,"\n", (now),"\n",profile.updateTime)
                
                // 21/02/27追記 更新日時を過ぎていたら，タスク実行を許可する
                // 現在時刻と更新日時を比較しdiff1に格納
                let diff1 = myCal.dateComponents([.second], from: now,to: profile.updateTime)
                print(diff1,"\n")
                // 差分が負である（現在日時が更新日時を超えている）とき，タスク実行を有効にする
                if diff1.second! < 0 {
                    profile.isTaskDone = false
                }
            }
            if phase == .inactive {
                print("バックグラウンドorフォアグラウンド直前")
            }
        }
        
        // 経験値詳細表示ボックス
        let description = (profile.isTaskDone == true) ? String(format: "%.0fexpを獲得しました\n継続日数ボーナスにより獲得経験値が上昇しました(%.0f→%.0f)",profile.previousExp,profile.previousExp,profile.nextExp): ""
        Text(description)
        .font(.system(size: 18, weight: .regular , design: .default))
        .foregroundColor(Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
        .padding(10)
        .frame(width: 280.0, height: 140.0)
        .border(Color(red: 151/255, green: 206/255, blue: 204/255, opacity: 1), width: 10)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskView()
        }
    }
}

//ProgressBar
struct ProgressBar: View {
    private let value: Double
    private let maxValue: Double
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    
    init(value: Double,
         maxValue: Double,
         backgroundEnabled: Bool = true,
         backgroundColor: Color = Color(UIColor(red: 196/255,
                                                green: 196/255,
                                                blue: 196/255,
                                                alpha: 1.0)),
         foregroundColor: Color = Color(UIColor(red: 151/255,
                                          green: 206/255,
                                          blue: 204/255,
                                          alpha: 1.0))
    ){
        self.value = value
        self.maxValue = maxValue
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    private func progress(value: Double,
                          maxValue: Double,
                          width: CGFloat) -> CGFloat {
        let percentage = value / maxValue
        return width *  CGFloat(percentage)
    }
    
    var body: some View {
    // 1
        ZStack {
            // 2
            GeometryReader { geometryReader in
                // 3
                if self.backgroundEnabled {
                    Capsule()
                        .foregroundColor(self.backgroundColor) // 4
                }
                    
                Capsule()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width))
                    .foregroundColor(self.foregroundColor)
                    .animation(.easeIn)
            }
        }
    }
}




