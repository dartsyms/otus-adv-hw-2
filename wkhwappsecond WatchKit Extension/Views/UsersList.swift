//
//  UsersList.swift
//  wkhwappsecond WatchKit Extension
//

import SwiftUI
import DummyApiNetworkClient

struct UsersList: View {
    @StateObject var dataSource = NetworkDataSource()
    var body: some View {
        NavigationView {
            VStack {
                self.users
            }
            .onAppear {
                self.dataSource.load()
            }
            .navigationTitle("Users")
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var users: some View {
        List {
            ForEach(Array(self.dataSource.users.enumerated()), id: \.element.id) { pair in
                HStack {
                    self.rowFor(user: pair.element)
                    .onAppear {
                        if self.dataSource.users.isLast(pair.element) {
                            self.dataSource.load()
                        }
                    }
                    
                    if self.dataSource.isLoading && self.dataSource.users.isLast(pair.element) {
                        ProgressView()
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .listStyle(PlainListStyle())
        }
    }
    
    private func rowFor(user: User) -> some View {
        return NavigationLink(destination: UserDetailsView(person: user)) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(verbatim: "\(user.firstName ?? "") \(user.lastName ?? "")")
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    Text(user.email ?? "")
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    HStack {
                        Text(user.phone ?? "")
                            .font(.system(size: 10, weight: .medium, design: .default))
                            .foregroundColor(.primary)
                            .padding(.top, 4)
                    }
                }
                .padding(.trailing, 4)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.all, 1)
        }
    }
}

struct UserDetailsView: View {
    @ObservedObject private(set) var viewModel = NetworkDataSource()
    
    var person: User
    
    init(person: User) {
        self.person = person
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(person.title?.rawValue ?? "")
                        .font(.subheadline)
                    Text(person.firstName ?? "")
                        .font(.subheadline)
                    Text(person.lastName ?? "")
                        .font(.subheadline)
                }
                Text(viewModel.userOrigin)
                    .font(.caption)
                    .padding(.bottom)
                HStack(alignment: .top) {
                    Text(viewModel.email)
                        .font(.caption)
                }
                HStack(alignment: .top) {
                    Text(viewModel.phone)
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        
        .onAppear {
            self.viewModel.loadDetailsFor(person.id)
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList()
    }
}
