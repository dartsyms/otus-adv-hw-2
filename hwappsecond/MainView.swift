//
//  MainView.swift
//  hwappsecond
//

import SwiftUI

enum Tab {
    case users, posts, tags
}

struct MainView: View {
    @State private var selection: Tab = .posts
    
    var body: some View {
        TabView(selection: $selection) {
            Text("Users List")
                .tabItem {
                    Image(systemName: (selection == .users ? "person.circle.fill" : "person.circle"))
                    Text("Users")
                }
                .tag(Tab.users)
            Text("Posts List")
                .tabItem {
                    Image(systemName: (selection == .posts ? "pencil.circle.fill" : "pencil.circle"))
                    Text("Posts")
                }
                .tag(Tab.posts)
            TagsListView()
                .tabItem {
                    Image(systemName: (selection == .tags ? "tag.circle.fill" : "tag.circle"))
                    Text("Tags")
                }
                .tag(Tab.tags)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
