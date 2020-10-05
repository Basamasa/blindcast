//
//  SettingView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var mainModel: MainViewModel
    var body: some View {
        NavigationView{
            List{
                Text("setting.language")
            }
            .modifier(BlindNavigationView(label: "setting.header", hint: "setting.header.hint", isBack: false))
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
