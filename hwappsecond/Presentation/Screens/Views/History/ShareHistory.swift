//
//  ShareHistory.swift
//  hwappsecond
//

import SwiftUI
import CoreData

struct ShareHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]) var sharedItems: FetchedResults<Item>
    
    @State private var searchStr: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                self.rows
            }
            
            .navigationBarTitle("Share History", displayMode: .inline)
        }
            
    }
    
    private var rows: some View {
        List {
            ForEach(sharedItems.sorted { $0.timestamp! > $1.timestamp! }, id: \.id) { item in
                HStack {
                    Text("\(item.content ?? "")")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(item.timestamp ?? Date())")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
}

struct ShareHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ShareHistoryView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

