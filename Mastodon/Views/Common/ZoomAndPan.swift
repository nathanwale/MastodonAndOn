//
//  ZoomAndPan.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/2/2024.
//

import SwiftUI

///
/// A container view to allow zooming and panning
/// Adapted from https://stackoverflow.com/questions/58341820/isnt-there-an-easy-way-to-pinch-to-zoom-in-an-image-in-swiftui
///
struct ZoomAndPan<Content: View>: UIViewRepresentable
{
    /// Content to pan and zoom
    var content: Content
    
    /// Init with content
    init(@ViewBuilder content: () -> Content)
    {
        self.content = content()
    }
    
    /// Make UI View with Context
    func makeUIView(context: Context) -> UIScrollView
    {
        // create UIScrollView
        let scrollView = UIScrollView()
        
        // gives us `viewForZooming(in:)`
        scrollView.delegate = context.coordinator
        
        // configure min and max scale
        scrollView.maximumZoomScale = 20
        scrollView.minimumZoomScale = 1
        
        // add bounce
        scrollView.bouncesZoom = true
        
        // hosted view to hold SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        scrollView.addSubview(hostedView)
        
        return scrollView
    }
    
    /// Make coordinator
    func makeCoordinator() -> Coordinator 
    {
        Coordinator(hostingController: .init(rootView: content))
    }
    
    /// Update UI View
    func updateUIView(_ uiView: UIScrollView, context: Context) 
    {
        context.coordinator.hostingController.rootView = content
        assert(context.coordinator.hostingController.view.superview == uiView,
               "View mismatch")
    }
    
    ///
    /// Coordinator
    ///
    class Coordinator: NSObject, UIScrollViewDelegate
    {
        /// Hosting controller
        var hostingController: UIHostingController<Content>
        
        /// Init with hosting controller
        init(hostingController: UIHostingController<Content>)
        {
            self.hostingController = hostingController
        }
        
        /// View for zooming
        func viewForZooming(in scrollView: UIScrollView) -> UIView? 
        {
            hostingController.view
        }
    }
}

#Preview {
    ZoomAndPan
    {
        let url = URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg")!
        WebImage(url: url)
    }
}
