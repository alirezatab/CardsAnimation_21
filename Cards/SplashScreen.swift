/// Copyright (c) 2025 Kodeco
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct SplashScreen: View {
  var body: some View {
    ZStack {
      Color("background")
        .ignoresSafeArea()
      card(letter: "S", color: "appColor1")
        .splashAnimation(finalYposition: 240, delay: 0)
      card(letter: "D", color: "appColor2")
        .splashAnimation(finalYposition: 120, delay: 0.2)
      card(letter: "R", color: "appColor3")
        .splashAnimation(finalYposition: 0, delay: 0.4)
      card(letter: "A", color: "appColor6")
        .splashAnimation(finalYposition: -120, delay: 0.6)
      card(letter: "C", color: "appColor7")
        .splashAnimation(finalYposition: -240, delay: 0.8)
    }
  }
  
  func card(letter: String, color: String) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25)
        .shadow(radius: 3)
        .frame(width: 120, height: 160)
        .foregroundStyle(Color.white)
      Text(letter)
        .fontWeight(.bold)
        .scalableText()
        .foregroundStyle(Color(color))
        .frame(width: 80)
    }
  }
}

// To drop the card from the top, you’ll animate content‘s offset.
/// Note: SwiftUI makes animating any view parameter that depends on a property incredibly easy. You simply surround the dependent property with a closure:
/// In `SplashAnimation`, the offset of your card depends on `animating`.
private struct SplashAnimation: ViewModifier {
  @State private var animating = true
  
  /// A more interesting Animation is a spring, where the view bounces like a spring. You can specify how stiff it is and how fast the bouncing stops.
  /// This creates a spring animation.
  let animation = Animation.interpolatingSpring(
    mass: 0.2,
    // the lower, the stiffer the spring
    stiffness: 80,
    ///  Controls the amount of friction or resistance applied to the spring’s motion. A higher damping value reduces oscillations, making the spring stop sooner and appear less “bouncy.” A lower value allows the spring to oscillate more, resulting in a bouncier animation.
    damping: 5,
    /// The starting velocity of the animation, measured in points per second. This parameter is useful when chaining animations, as it allows you to match the velocity of the spring with the ongoing movement. A value of 0.0 means the animation starts from rest, while a positive or negative value gives it an initial “push.”
    initialVelocity: 0.0)
  
  let finalYPosition: CGFloat
  let delay: Double
  
  func body(content: Content) -> some View {
    content
    /// If animating is true, then the card’s offset is off the top of the screen at -700 points.
      .offset(y: animating ? -700 : finalYPosition)
      .rotationEffect(animating ? .zero : Angle(degrees: Double.random(in: -10...10)))
      .onAppear {
        // Explicti Animation
         /// When false, the offset will be the final designated position. You change animating to false when the view appears.
//        withAnimation(Animation.default.delay(delay)) {
        /// This animation lasts for 1.5 seconds and slows gradually at the end of the animation.
//        withAnimation(Animation.easeOut(duration: 1.5).delay(delay)) {
//        withAnimation(animation.delay(delay)) {
//          animating = false
//        }
        animating = false
      }
      // Implicit animation
    // This adds an implicit animation to the view. The view watches the property animating, and whenever animating changes, the view animates with the Animation provided.
      .animation(animation.delay(delay), value: animating)
  }
  
  /// Note:
  /// In this case, as you are only animating views with one animatable property, the implicit animation will appear exactly the same as the explicit animation. Explicit animations can be less code, but implicit animations give you more control by being able to animate each view depending on the animated property with different animations.
}

// This is simply a pass through method to make your code prettier.
private extension View {
  func splashAnimation(
    finalYposition: CGFloat,
    delay: Double
  ) -> some View {
    modifier(SplashAnimation(
      finalYPosition: finalYposition,
      delay: delay))
  }
}

#Preview {
  SplashScreen()
}
