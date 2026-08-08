//
//  BouncingDotVIew.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 09/08/26.
//

import SwiftUI

struct BouncingDotHi: View {
    @State private var dotX: CGFloat = 0
    @State private var dotY: CGFloat = 0
    @State private var scaleX: CGFloat = 1.0
    @State private var scaleY: CGFloat = 1.0
    
    @State private var trailingPath: CGFloat = 0.0
    
    let fontSize: CGFloat = 120
    private var floorY: CGFloat { fontSize * 0.62 }
    
    // Each hop = (dx, apexHeight, duration)
    private var rightHops: [(CGFloat, CGFloat, Double)] {
        [
            (fontSize * 0.5,  fontSize * 0.55, 0.55),
            (fontSize * 0.42, fontSize * 0.30, 0.42),
            (fontSize * 0.36, fontSize * 0.18, 0.36),
            (fontSize * 0.30, fontSize * 0.10, 0.30),
            (fontSize * 0.24, fontSize * 0.05, 0.24)
        ]
    }
    
    private var leftHops: [(CGFloat, CGFloat, Double)] {
        [
            (-fontSize * 0.24, fontSize * 0.05, 0.24),
            (-fontSize * 0.30, fontSize * 0.10, 0.30),
            (-fontSize * 0.36, fontSize * 0.18, 0.36),
            (-fontSize * 0.42, fontSize * 0.30, 0.42),
            (-fontSize * 0.5,  fontSize * 0.55, 0.55)
        ]
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text("H")
                .font(.system(size: fontSize, weight: .bold, design: .rounded))
            
            ZStack(alignment: .top) {
                Capsule()
                    .frame(width: fontSize * 0.12, height: fontSize * 0.52)
                    .padding(.top, fontSize * 0.35)
                
                Circle()
                    .frame(width: fontSize * 0.14, height: fontSize * 0.14)
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .bottom)
                    .offset(x: dotX, y: dotY)
            }
            .frame(width: fontSize * 0.3, height: fontSize, alignment: .top)
            
            Spacer().frame(width: trailingPath)
        }
        .foregroundStyle(.primary)
        .onAppear { runFullCycle() }
    }
    
    // MARK: - Full loop
    
    private func runFullCycle() {
        runHops(rightHops) {
            pause(0.25) {
                runHops(leftHops) {
                    jumpHome {
                        pause(0.5) {
                            runFullCycle()   // loop forever
                        }
                    }
                }
            }
        }
    }
    
    private func pause(_ seconds: Double, then completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    // MARK: - One arc hop, squirrel-style
    
    private func runHops(_ hops: [(CGFloat, CGFloat, Double)], completion: @escaping () -> Void) {
        guard !hops.isEmpty else { completion(); return }
        var remaining = hops
        let (dx, apex, duration) = remaining.removeFirst()
        
        let crouch = duration * 0.12     // tiny anticipation squash before launch
        let rise = duration * 0.42       // going up
        let fall = duration * 0.38       // coming down
        let land = duration * 0.08       // squash on landing
        
        let startX = dotX
        let midX = startX + dx * 0.55
        let endX = startX + dx
        
        // 1. Anticipation: squash down and wide, like crouching to jump
        withAnimation(.easeOut(duration: crouch)) {
            scaleX = 1.25
            scaleY = 0.7
        }
        
        pause(crouch) {
            // 2. Launch + rise: stretch tall and thin, ease out (decelerating climb)
            withAnimation(.easeOut(duration: rise)) {
                dotX = midX
                dotY = floorY - apex
                scaleX = 0.8
                scaleY = 1.25
                trailingPath = max(trailingPath, midX)
            }
            pause(rise) {
                // 3. Fall: ease in (accelerating down), stretch continues slightly
                withAnimation(.easeIn(duration: fall)) {
                    dotX = endX
                    dotY = floorY
                    scaleX = 0.9
                    scaleY = 1.1
                    trailingPath = max(trailingPath, endX)
                }
                pause(fall) {
                    // 4. Landing squash
                    withAnimation(.easeOut(duration: land)) {
                        scaleX = 1.2
                        scaleY = 0.75
                    }
                    pause(land) {
                        withAnimation(.easeInOut(duration: land)) {
                            scaleX = 1.0
                            scaleY = 1.0
                        }
                        pause(land) {
                            runHops(remaining, completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Final jump back onto the i
    
    private func jumpHome(completion: @escaping () -> Void) {
        withAnimation(.easeOut(duration: 0.18)) {
            scaleX = 1.3
            scaleY = 0.6
        }
        pause(0.18) {
            withAnimation(.interpolatingSpring(stiffness: 220, damping: 13)) {
                dotX = 0
                dotY = 0
                scaleX = 1.0
                scaleY = 1.0
                trailingPath = 0          
            }
            pause(0.6, then: completion)
        }
    }
}


#Preview {
    BouncingDotHi()
}
