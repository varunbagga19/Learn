//
//  HomeView.swift
//  Learn
//
//  Created by Varun Bagga on 15/10/23.
//

import SwiftUI

struct HomeView: View {
    @State var allProfile = profiles
    var body: some View {
        ScrollView{
            ForEach(allProfile) { data in
                CardView()
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
