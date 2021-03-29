/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The top-level definition of the Landmarks app.
 */

import SwiftUI

@main
struct LandmarksApp: App {
//    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
//            TaskRegistView().environmentObject(model)
            TaskRegistView()
        }
    }
}
