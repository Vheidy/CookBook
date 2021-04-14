//
//  SwiftUIView.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 07.04.2021.
//

import SwiftUI

//struct SwiftUIView: View {
//    
//    @State var inputText: String = ""
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Hello, World!")
//                TextField("Input", text: $inputText)
//            }
//            if true {
//                Text("1")
//            } else {
//                Text("2")
//            }
//            List(1..<10) { value in
//                Text("Row: \(value); Value: \(inputText)")
//            }
//        }
//    }
//}
//
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
//
//protocol Helper {
//    associatedtype Version
//    
//    var version: Version { get }
//}
//
//struct iOSHelper: Helper {
//    typealias Version = String
//    var version: String { "1" }
//}
//
//struct WatchOSHelper: Helper {
//    typealias Version = Int
//    var version: Int { 1 }
//}
//
//class ManagerHelper: Hashable {
//    
//    var id: String
//    
//    var version: some Helper {
//        WatchOSHelper()
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//}
