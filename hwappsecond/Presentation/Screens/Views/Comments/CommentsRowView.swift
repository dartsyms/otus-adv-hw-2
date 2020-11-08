//
//  CommentsRowView.swift
//  hwappsecond
//

import SwiftUI

struct CommentRowView: View {
    @ObservedObject var viewModel: CommentRowViewModel
    
    init(viewModel: CommentRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let url = URL(string: viewModel.comment.owner?.picture ?? "https://randomuser.me/api/portraits/men/80.jpg")!
        HStack(alignment: .center) {
            AsyncImage(url: url, placeholder: { Image(systemName: "photo") }, image: { Image(uiImage: $0).resizable() })
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .padding(.all, 5)
            
            VStack(alignment: .leading) {
                Text(viewModel.comment.message ?? "")
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundColor(.primary)
            }.padding(.trailing, 20)
            
            VStack(alignment: .trailing) {
                    HStack {
                        Text(viewModel.comment.owner?.firstName ?? "")
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                        Text(viewModel.comment.publishDate ?? "")
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    }
            }.padding(.trailing, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white)
        .modifier(CardModifier())
        .padding(.all, 1)
    }
}
