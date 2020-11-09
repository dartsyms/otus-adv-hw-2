//
//  PostDetailsView.swift
//  hwappsecond
//


import SwiftUI
import CoreLocation
import DummyApiNetworkClient
import CustomNavigation

struct PostDetailsView: View {
    @State var post: Post
    
    var body: some View {
        let url = URL(string: post.image ?? "https://img.dummyapi.io/photo-1590178534645-de019aa7255e.jpg")!
        VStack {
            FakeNavigationBar(self.author)
            
            AsyncImage(url: url, placeholder: { Image(systemName: "photo")}, image: { Image(uiImage: $0).resizable() })
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
            
            VStack(alignment: .leading) {
                Text(post.text ?? "")
            }
            .padding(.bottom, 10)
            
            NavPushButton(destination: UserDetailsView(person: post.owner!, fromPost: true)) {
                Text("To author profile")
            }
            
            CommentsListView(dataSource: CommentsDataSource(post: post))
            
            Spacer()
        }
    }
    
    private var author: String {
        guard let name = post.owner?.firstName, let surname = post.owner?.lastName else { return "" }
        return "by \(name.capitalized) \(surname.capitalized)"
    }
}
