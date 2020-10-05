//
//  ViewModifier.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import SwiftUI


struct BlindNavigationView: ViewModifier {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var label: LocalizedStringKey
    var hint: LocalizedStringKey
    var isBack: Bool
    var backLabel : String? = nil
    
    func body(content: Content) -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                ZStack {
                    Rectangle().frame(maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50)
                        .foregroundColor(Color.black.opacity(0))
                        .accessibility(label: Text(label))
                        .accessibility(hint: Text(hint))
                    Text(label).accessibility(hidden: true)
                }
                if isBack {
                    ZStack{
                        Rectangle().frame(width: 50, height: 50)
                            .accessibility(label: Text("zurueck"))
                            .foregroundColor(Color.black.opacity(0))
                    
                        Text("Back").accessibility(hidden: true)
                    }.onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            Divider().background(Color.black).frame(maxWidth: .infinity)
            content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
        .navigationBarTitle(Text(""))
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
