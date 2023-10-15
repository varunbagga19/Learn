//
//  CardView.swift
//  Learn
//
//  Created by Varun Bagga on 15/10/23.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 32)
                .fill(.orange)
                .frame(width: UIScreen.main.bounds.width - 40,
                       height: UIScreen.main.bounds.height/2)
            VStack(alignment: .center){
                HStack {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(.yellow)
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                Spacer()
                
                RoundedRectangle(cornerRadius: 32)
                    .foregroundColor(.green)
                    .frame(width:UIScreen.main.bounds.width-60,height: 60)
                    .overlay {
                        Text("This is varun branch")
                    }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 40,
                    height: UIScreen.main.bounds.height/2)
        }
    }
}

#Preview {
    CardView()
}
