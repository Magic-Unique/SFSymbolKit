# SFSymbolKit Usage

## 1. Import SFSymbolKit

```rub
pod 'SFSymbolKit'
```

```objc
#import <SFSymbolKit/SFSymbolKit.h>
```

## 2. Export symbol

1. Install [SF Symbol.app](https://developer.apple.com/sf-symbols/) on your Mac
1. Select SF Symbol in this app, such as: `wifi`
1. Export SF Symbol (⌘ + 􀆝 + E) as svg file to your disk (Select version).
1. Import svg file to your iOS project

## 3. Use SVG file

### 3.1 UIImage

```objc
imageView.image = [UIImage sk_imageNamed:@"wifi" pointSize:100];
```

### 3.2 SFSymbolImageView

```objc
SFSymbolImageView *symbolImageView = [[SFSymbolImageView alloc] init];
SFSymbolImage *symbolImage = [SFSymbolImage symbolImageNamed:@"wifi" pointSize:100];
```

