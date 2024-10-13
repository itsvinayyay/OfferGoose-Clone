import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This Cubit class manages a timer that tracks the elapsed time in seconds.
///
/// It emits an integer state, representing the number of seconds that have
/// passed since the timer started. The timer increments every second.
class TimerCubit extends Cubit<int> {
  /// Private field to hold the reference to the Timer instance.
  Timer? _timer;

  /// Private field to track the total elapsed time in seconds.
  int _timeElapsed = 0;

  /// Constructor that initializes the cubit and starts the timer.
  ///
  /// The initial state is set to `0` (indicating 0 seconds elapsed)
  TimerCubit() : super(0) {}

  /// Method to start the timer.
  ///
  /// The timer runs periodically every 1 second, incrementing the `_timeElapsed`
  /// value and emitting the updated time state.
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeElapsed++; // Increment elapsed time
      emit(_timeElapsed); // Emit the new elapsed time state
    });
  }

  /// Method to restart the timer.
  ///
  /// This cancels the existing timer, resets the elapsed time to `0`, and starts
  /// a new timer from the beginning. The reset state is immediately emitted.
  void restartTimer() {
    _timer?.cancel(); // Stop the previous timer
    _timeElapsed = 0; // Reset elapsed time to 0
    emit(_timeElapsed); // Emit the reset state
    startTimer(); // Start a new timer from 0
  }


   /// Method to stop the timer and reset the elapsed time to 0.
  ///
  /// This method cancels the currently running timer, resets the `_timeElapsed`
  /// value to `0`, and emits the reset state. It can be used when you want to
  /// completely stop the timer without restarting it.
  void stopTimer() {
    _timer?.cancel(); // Stop the running timer, if there is one.
    _timeElapsed = 0; // Reset the elapsed time to 0.
    emit(_timeElapsed); // Emit the new state with the reset time.
  }





  /// Overrides the `close` method to ensure the timer is cancelled
  /// when the cubit is closed.
  ///
  /// This is necessary to prevent the timer from continuing to run when the cubit
  /// is no longer needed.
  @override
  Future<void> close() {
    _timer?.cancel(); // Cancel the timer if it's running
    return super.close();
  }
}
