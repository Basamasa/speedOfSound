//
//  Extensions.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 02.05.22.
//
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}

extension AnyTransition {
    static var backslide1: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .bottom))}
    
    static var backslide2: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top))}
}
