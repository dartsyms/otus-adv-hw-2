//
//  MainView.swift
//  hwappsecond
//

import SwiftUI

public enum Tab {
    case users, posts, tags, share
}

struct MainView: View {
    @State private var selection: Tab = .posts
    
    @State private var copiedText: String = ""
    
    var dataUpdater = ShareDataUpdate()
    
    var body: some View {
        TabView(selection: $selection) {
            UsersListView()
                .tabItem {
                    Image(systemName: (selection == .users ? "person.circle.fill" : "person.circle"))
                    Text("Users")
                }
                .tag(Tab.users)
            PostsListView()
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
            SuffixesListView(dataSource: SuffixesDataSource(source: $copiedText.wrappedValue), dataUpdater: dataUpdater)
                .tabItem {
                    Image(systemName: (selection == .tags ? "tray.and.arrow.down.fill" : "tray.and.arrow.down"))
                    Text("Suffixes")
                }
                .tag(Tab.share)
        }
        .onAppear {
            if let defaults = UserDefaults(suiteName: "group.ru.it.kot.hwappsecond"),
               let text = defaults.string(forKey: "copied_text") {
                selection = text.isEmpty ? .posts : .share
                copiedText = text
                dataUpdater.notifier.send(true)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostDidBecomeActive)) { _ in
            if let defaults = UserDefaults(suiteName: "group.ru.it.kot.hwappsecond"),
               let text = defaults.string(forKey: "copied_text") {
                selection = text.isEmpty ? .posts : .share
                copiedText = text
                dataUpdater.notifier.send(true)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
