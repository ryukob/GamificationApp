/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing the details for a landmark.
 */

import SwiftUI

struct TaskRegistView: View {
    
    @ObservedObject var profile = UserProfile()
    //    @State var taskName = ""
    @State var flag = false
    //    @EnvironmentObject var model: Model
    @State private var showingRegistationAlert = false
    
    
    var body: some View {
        // NOTE: 画面をレンダリングするかで画面遷移を発生する
        if profile.isTaskRegisted {
            TaskView()
        } else {
            
            
            //        NavigationView {
            VStack {
                HStack{
                    Text("Gamify")
                        .font(.custom("Arial Rounded MT Bold", size: 36))
                        .foregroundColor(Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
                    Spacer()
                }
                .padding()
                .background(Color(red: 151/255, green: 206/255, blue: 204/255, opacity: 1))
                
                Spacer()
                Text("習慣を登録しよう")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 76/255, green: 76/255, blue: 84/255, opacity: 1))
                
                HStack{
                    Spacer(minLength:20)
                    TextField("例. 腕立て伏せ1回", text: $profile.taskName)
                        .padding(16.0)  // 余白を追加
                        .font(.custom("Roboto", size: 24))
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 6.0, height: 6.0))
                                .stroke(Color.gray, lineWidth: 2.0)
                        )
                    Spacer(minLength:20)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation() {
                        //                        print(self.flag)
                        //                        profile.isTaskRegisted.toggle()
                        showingRegistationAlert = true
                    }
                }){
                    Text("START")
                        .font(.title)
                        .fontWeight(.bold)
                        .font(.custom("Roboto", size: 28))
                        .foregroundColor(Color.white)
                    
                }
                .frame(width: 280.0, height: 56.0)
                .padding(10) //ボタン内部のpadding
                .background(Color(red: 18/255, green: 144/255, blue: 142/255, opacity: 1))
                .cornerRadius(48.0)
                .alert(isPresented: $showingRegistationAlert){
                    Alert(title: Text(String(format: "「\(profile.taskName)」で登録しますか？")),
                          primaryButton: .default(Text("いいえ")),    // キャンセル用
                          secondaryButton: .default(Text("はい"),
                                                    action: {
                                                        profile.isTaskRegisted.toggle()
                                                    }
                          )
                    )
                }
            }
            .padding(.bottom, 10)
        }
    }
}
