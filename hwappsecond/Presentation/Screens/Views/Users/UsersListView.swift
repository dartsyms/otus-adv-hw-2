//
//  UsersListView.swift
//  hwappsecond
//

import SwiftUI

struct UsersListView: View {
    @StateObject var dataSource = UsersDataSource()
    
    var body: some View {
        NavigationView {
//        CustomNavigationView(transition: .custom(.moveAndFade, .moveBackAndFade)) {
            VStack {
                self.users
            }
            .onAppear {
                self.dataSource.load()
            }
            .navigationBarTitle("Users", displayMode: .inline)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var users: some View {
        List {
            ForEach(self.dataSource.cachedUsers, id: \.userId) { user in
                HStack {
                    UserRowView(viewModel: UserRowViewModel(user: user))
                }
                .onAppear {
                    if self.dataSource.cachedUsers.isLast(user) {
                        self.dataSource.loadCached()
                    }
                }
                
                if self.dataSource.isLoading && self.dataSource.cachedUsers.isLast(user) {
                    ProgressView()
                }
            }
            .listRowInsets( EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) )
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
//        .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        .background(Color.gray)
        .listStyle(PlainListStyle())
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
