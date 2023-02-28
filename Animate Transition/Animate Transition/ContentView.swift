//
//  ContentView.swift
//  Animate Transition
//
//  Created by Aashish Bansal on 28/02/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Calling the OpenSettingsView
        OpenSettingsView()
        
    }
}

// Creating the Present-and-Dismiss struct
struct PresentAndDismiss: GeometryEffect{
    /*
     GeometryEffect is a Protocol used to change the VIsual Appearance of a View.
     It interpolates between values creating the Animations.
     */
    
    // Creating Properties
    var offsetValue: Double
    var animatableData: Double{
        get{
            offsetValue
        }
        
        set{
            offsetValue = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // Returns the Transform to apply on the View
        let rotationOffset = offsetValue // used to rotate the View
        let angleOfRotation = CGFloat(Angle(degrees: 95*(1 - rotationOffset)).radians)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1/max(size.width, size.height)
        
        transform3D = CATransform3DRotate(transform3D, angleOfRotation, 1, 0, 0)
        transform3D = CATransform3DTranslate(transform3D, -size.width/2.0, -size.height/2.0, 0) /// scaling down the image
        
        // Transforming Location Points
        let transformAffine1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height/2.0))
        let transformAffine2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(offsetValue * 2), y: CGFloat(offsetValue*2)))
        
        // Concatenating the Transforms
        if offsetValue<=0.5{
            return ProjectionTransform(transform3D).concatenating(transformAffine2).concatenating(transformAffine1)
        }
        else {
            return ProjectionTransform(transform3D).concatenating(transformAffine1)
        }
        
    } // end of function effectValue()
}

// Button to trigger opening of SettingsView
struct OpenSettingsView: View{
    // Property to Trigger Animation
    @State private var isShowing = false
    
    // Adding a Background Gradient
    let gradientBackground = Gradient(colors: [.black, .white, .black])
    
    // Creating a Border for Gradient
    let buttonBorderGradient = LinearGradient(gradient: Gradient(colors: [.black, .white, .black]), startPoint: .bottomLeading, endPoint: .bottomTrailing)
    
    // Body Computed Property
    var body: some View{
        VStack{
            ZStack{
                // Adding the Gradient
                LinearGradient(gradient: gradientBackground, startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
                
                // Creating the Clock and Button
                VStack{
                    Text("Wake Up")
                        .foregroundColor(.black)
                        .font(.title)
                    
                    Image(systemName: "clock")
                        .font(.largeTitle)
                }.offset(y: -25) // end of VStack
                
                // Creating the Button to start the animation
                Button(action: {
                    withAnimation(.easeInOut(duration: 1.0)){
                        self.isShowing = true
                    }
                }){
                    Image(systemName: "gear").font(Font.system(size: 20).weight(.bold))
                }
                .padding(10)
                .background(Color.orange)
                .cornerRadius(30)
                .foregroundColor(.black)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(buttonBorderGradient, lineWidth: 5).shadow(color: .gray, radius: 5))
                .offset(y: 200)
                // end of Button()
                
                // Toggling the SettingsView for Animation
                if isShowing{
                    SettingsView(show: $isShowing)
                        .transition(.fly) // This will just make the components fly
                        .zIndex(1) // This will put the OpenSettings Button() behind the View during Present
                }
            } // end of ZStack
        } // end of VStack
    }
}

// Extending animation
extension AnyTransition{
    static var fly: AnyTransition{
        get{
            AnyTransition.modifier(active: PresentAndDismiss(offsetValue: 0), identity: PresentAndDismiss(offsetValue: 1))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
