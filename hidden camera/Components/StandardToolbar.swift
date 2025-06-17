import SwiftUI

struct StandardToolbar: ViewModifier {
    let onRefresh: (() -> Void)?
    let onHexagon: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                if let onRefresh = onRefresh {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: onRefresh) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.customButton)
                        }
                    }
                }
                
                if let onHexagon = onHexagon {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: onHexagon) {
                            Image(systemName: "hexagon.fill")
                                .foregroundColor(.customButton)
                        }
                    }
                }
            }
    }
}

extension View {
    func standardToolbar(onRefresh: (() -> Void)? = nil, onHexagon: (() -> Void)? = nil) -> some View {
        self.modifier(StandardToolbar(onRefresh: onRefresh, onHexagon: onHexagon))
    }
}