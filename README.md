# CircularProgressTimer

A circular progress countdown view.

Preview:

![Screeshot](preview.gif)

Usage:

```Swift
struct ContentView: View {
  @State var isCompleted: Bool = false
  
  var body: some View {
    CPTCountdownView(min: 0, max: 10, isCompleted: $isCompleted)
      .clockSize(CGSizeMake(300, 300))
      .borderWidth(18)
      .fontColor(.black)
      .trackColor(.gray.opacity(0.2))
      .barColor(.orange)
      .completionColor(.green)
      .clockFont(.system(size: 70))
      .valueChanged(value: isCompleted) { newValue in
        if newValue {
          print("Countdown completed")
        }
      }
  }
}
```
