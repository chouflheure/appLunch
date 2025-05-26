import Lottie
import SwiftUI

private class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

private struct CachedAsyncImage<Content>: View where Content: View {

    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    /// Loads, displays and caches a modifiable image from the specified URL in phases.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - transaction: The transaction to use when the phase changes.
    ///   - content: A closure that takes the load phase as an input, and
    ///     returns the view to display for the specified phase.
    public init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {
        if let url, let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase, let url {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

internal enum PictureCacheDesignType {
    case scaledToFill_Circle
    case scaledToFill_Clipped
    case fullScreenImageTurn
    case fullScreenImageTurnDetail
    case scaledToFill_Circle_CFQ
    case scaleImageMessageProfile
}

struct CachedAsyncImageView: View {
    let urlString: String
    let designType: PictureCacheDesignType
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        CachedAsyncImage(url: URL(string: urlString) ?? URL(string: "")) {
            phase in
            switch phase {
            case .empty:
                switch designType {
                    
                case .scaledToFill_Circle_CFQ:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                    }

                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 34, height: 34)
                        }
                }

            case .success(let image):
                switch designType {
                    
                case .scaledToFill_Circle_CFQ:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)

                case .scaledToFill_Circle:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())

                case .scaledToFill_Clipped:
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()

                case .fullScreenImageTurn:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(width: UIScreen.main.bounds.width)
                        .contentShape(Rectangle())
                        .clipped()
                    
                case .fullScreenImageTurnDetail:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .frame(width: UIScreen.main.bounds.width)
                        .contentShape(Rectangle())
                        .clipped()
                
                case .scaleImageMessageProfile:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 34, height: 34)
                        }
                }

            case .failure(_):
                switch designType {
                    
                case .scaledToFill_Circle_CFQ:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                    }

                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                    
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 34, height: 34)
                        }
                }

            @unknown default:
                switch designType {
                    
                case .scaledToFill_Circle_CFQ:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                    }

                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                    
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 34, height: 34)
                        }
                }
            }
        }
    }
}
