//
//  FakeNavigationBar.swift
//  hwappsecond
//

import SwiftUI

struct FakeNavigationBar: View {
    @EnvironmentObject private var viewModel: CustomNavigationViewModel
    
    let label: String
    
    var body: some View {
        ZStack {
            HStack {
                if viewModel.currentScreen != nil {
                    backView
                        .simultaneousGesture(
                            TapGesture().onEnded { self.viewModel.pop(to: .prev) }
                        )
                        .padding()
                }
                Spacer()
            }
            .frame(height: UIDevice.current.hasNotch ? 84 : 64)
            .frame(maxWidth: .infinity)
            .background(Color("BackgroundMain"))
            .compositingGroup()
            .shadow(color: Color("BackroundMain").opacity(0.2), radius: 0, x: 0, y: 2)
            Text(label)
                .foregroundColor(.primary)
                .font(Font.body.weight(.bold))
//                .padding(.top, UIDevice.current.hasNotch ? 40 : 20)
        }
    }
    
    var backView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.02)
                .frame(width: 60, height: 60)
                .allowsHitTesting(false)
            HStack {
                Spacer()
                Image(systemName: "chevron.left")
                    .font(Font.system(size: 20).weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .frame(width: 50, height: 50)
            .contentShape(Rectangle())
        }
    }
}
