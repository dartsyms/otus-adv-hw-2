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
//            .onDisappear {
//                self.dataSource.cancel()
//            }
            .navigationBarTitle("Users", displayMode: .inline)
        }
    }
    
    private var users: some View {
        List {
            ForEach(Array(self.dataSource.users.enumerated()), id: \.element.id) { pair in
                HStack {
                    UserRowView(viewModel: UserRowViewModel(user: pair.element))
                }
                .onAppear {
                    if self.dataSource.users.isLast(pair.element) {
                        self.dataSource.load()
                    }
                }
                
                if self.dataSource.isLoading && self.dataSource.users.isLast(pair.element) {
                    ProgressView()
                }
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
