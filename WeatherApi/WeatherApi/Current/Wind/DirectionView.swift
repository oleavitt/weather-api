//
//  DirectionView.swift
//  DirectionView
//
//  Created by Oren Leavitt on 3/17/26.
//

import SwiftUI

struct DirectionView: View {
    @ObservedObject var viewModel: DirectionViewModel

    var body: some View {
        ZStack {
            Image("compass-rose")
                .resizable()
                .scaledToFit()
                .opacity(0.25)
            Image("pointer-arrow")
                .resizable()
                .scaledToFit()
                .opacity(0.75)
                .padding(.vertical, 10)
                .rotationEffect(.degrees(viewModel.direction))
        }
    }
}

#Preview {
    VStack {
        DirectionView(viewModel: DirectionViewModel())
            .frame(height: 128)
    }
}
