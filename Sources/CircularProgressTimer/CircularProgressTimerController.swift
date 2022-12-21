//
//  Created by Sean Li on 2022/12/21.
//

import Foundation
import Combine

public protocol CircularProgressTimerControllable
where Self: ObservableObject {
  var timer: Timer.TimerPublisher { get }
  var counter: Int { get }
  var countTo: Int { get }
  func resume()
  func pause()
  func reset()
  func cancel()
}

public class CircularProgressTimerController: ObservableObject, CircularProgressTimerControllable
{
  private var timerSubscription: AnyCancellable?
  public let timer: Timer.TimerPublisher
  let initialCounter: Int
  @Published public private(set) var counter: Int
  @Published public private(set) var paused: Bool = true
  public let countTo: Int
  
  public init(timer: Timer.TimerPublisher,
       counter: Int = 0, countTo: Int = 60) {
    self.timer = timer
    self.initialCounter = counter
    self.counter = counter
    self.countTo = countTo
    setupSubscriptions()
  }
  
  deinit {
    cancel()
  }
  
  private func setupSubscriptions() {
    timerSubscription = timer
      .autoconnect()
      .combineLatest($paused)
      .debounce(for: .seconds(0.9), scheduler: DispatchQueue.main)
      .sink(receiveValue: { [unowned self] (_, isPaused) in
        guard !isPaused else { return }
        guard counter < countTo else {
          return
        }
        counter += 1
      })
  }
  
  public func resume() {
    self.paused = false
  }
  
  public func pause() {
    self.paused = true
  }
  
  public func reset() {
    pause()
    counter = initialCounter
  }
  
  public func cancel() {
    pause()
    timerSubscription?.cancel()
    timerSubscription = nil
  }
}
