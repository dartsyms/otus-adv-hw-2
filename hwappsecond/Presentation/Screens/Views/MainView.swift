//
//  MainView.swift
//  hwappsecond
//

import SwiftUI

public enum Tab {
    case users, posts, tags, share, history
}

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selection: Tab = .posts
    
    @State private var copiedText: String = ""
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]) var items: FetchedResults<Item>
    
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
            SuffixesListView(dataSource: SuffixesDataSource(source: copiedText.isEmpty ? sharedContent: copiedText), dataUpdater: dataUpdater)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .tabItem {
                    Image(systemName: (selection == .tags ? "tray.and.arrow.down.fill" : "tray.and.arrow.down"))
                    Text("Suffixes")
                }
                .tag(Tab.share)
            ShareHistoryView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .tabItem {
                    Image(systemName: (selection == .tags ? "bookmark.fill" : "bookmark"))
                    Text("History")
                }
                .tag(Tab.history)
        }
        .onAppear {
            if let defaults = UserDefaults(suiteName: "group.ru.it.kot.hwappsecond"),
               let text = defaults.string(forKey: "copied_text") {
                selection = text.isEmpty ? .posts : .share
                copiedText = sharedContent
                dataUpdater.notifier.send(true)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostDidBecomeActive)) { _ in
            if let defaults = UserDefaults(suiteName: "group.ru.it.kot.hwappsecond"),
               let text = defaults.string(forKey: "copied_text") {
                selection = text.isEmpty ? .posts : .share
                copiedText = sharedContent
                dataUpdater.notifier.send(true)
            }
        }
    }
    
    private var sharedContent: String {
        return items.sorted { $0.timestamp! > $1.timestamp! }.first?.content ?? ""
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
