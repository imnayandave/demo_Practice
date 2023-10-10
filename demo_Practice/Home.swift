//
//  Home.swift
//  demo_Practice
//
//  Created by Nayan Dave on 10/10/23.
//

import SwiftUI

struct Home: View {
    @State var offSet: CGSize = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageSize = (isOrientationVertical() ? size.width * 0.75 : size.width * 0.2)
            VStack {
                ZStack(alignment: .center) {
                    Image("Main")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize-30)
                        .rotationEffect(.init(degrees: -15))
                        .zIndex(1)
                        .offset(x: offSetToAngle().degrees * 5, y: offSetToAngle(true).degrees * 5)
                    Circle()
                        .fill(Color("Yellow"))
                        .frame(width: imageSize-20, height: imageSize)
                        .padding(.top, 25)
                        .offset(x: offSetToAngle().degrees * 2.5, y: offSetToAngle(true).degrees * 2.5)
                }
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .zIndex(0)
                    .offset(x: offSetToAngle().degrees * 2.5, y: offSetToAngle(true).degrees * 2.5)
                
                VStack(alignment: .center) {
                    BlendedText("Import Export Software Platform")
                    BlendedText("The simplest way to manage your EXIM")
                    Button {
                        if let url = URL(string: "https://trezix.io/") {
                               UIApplication.shared.open(url)
                            }
                    } label: {
                        Text("Book Demo")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                            .fontWeight(.bold)
                            .foregroundColor(Color("BG"))
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color("Yellow"))
                                    .brightness(-0.05)
                            }
                    }
                }
                .offset(x: offSetToAngle().degrees * 2.5, y: offSetToAngle(true).degrees * 2.5)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .foregroundColor(.white)
            .frame(width: isOrientationVertical() ? imageSize : imageSize * 2.5)
            .background(content: {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color("BG"))
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            })
            .rotation3DEffect(offSetToAngle(true), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(offSetToAngle(), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(offSetToAngle(true) * 0.5, axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.95)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .shadow(radius: offSet == .zero ? 5 : min(offSet.height, offSet.width) + 10, x: 0, y: 10)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offSet = value.translation
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.32)) {
                            offSet = .zero
                        }
                    })
            )
        }
    }
    
    func offSetToAngle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offSet.height : offSet.width) / (isVertical ? screenSize.height : screenSize.width)
        return .init(degrees: progress * 10)
    }
    
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }()
    
    func isOrientationVertical() -> Bool {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .unknown, .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        @unknown default:
            return true
        }
        
    }
    
    @ViewBuilder
    func BlendedText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.compressed)
            .blendMode(.difference)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
