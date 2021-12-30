//
//  ContentView.swift
//  Pinch
//
//  Created by Yannick Fumukani on 12/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = CGSize(width: 0, height: 0)
    
    func resetImageState(){
        withAnimation(.spring()){
            imageOffset = .zero
            imageScale = 1
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.clear
                //: IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        withAnimation(.spring()){
                            if(imageScale == 5){
                                resetImageState()
                            } else {
                                imageScale = 5
                            }
                        }
                        
                    })
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{ value in
                                
                                if(imageScale <= 1){
                                    resetImageState()
                                }
                            }
                    )
                
            } //: ZStack
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .offset(x: 20, y:20)
                , alignment: .top)
            
        } //: NAVIGATION VIWE
        .navigationViewStyle(.stack)
        .onAppear(perform: {
            withAnimation(.linear(duration: 1.0)){
                isAnimating = true
            }
        })
        
        .onDisappear{
            withAnimation(.linear(duration: 1.0)){
                isAnimating = false
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
