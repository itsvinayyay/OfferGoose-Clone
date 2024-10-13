import 'package:flutter_bloc/flutter_bloc.dart';

/// This Cubit class manages the state of speech recognition in the application.
///
/// It holds a boolean state which indicates whether speech recognition is
/// currently active or inactive, and allows for triggering the recognition state.
class SpeechRecognitionCubit extends Cubit<bool> {
  
  /// Constructor for initializing the speech recognition state.
  ///
  /// By default, the initial state is set to `false`, meaning that speech
  /// recognition is inactive when the Cubit is first created.
  SpeechRecognitionCubit() : super(false);

  /// Trigger the speech recognition state change.
  ///
  /// This method updates the current state of the Cubit to reflect whether
  /// speech recognition is enabled or disabled.
  ///
  /// - [recognitionState]: A boolean indicating the desired speech recognition state:
  ///     - `true`: If speech recognition should be active.
  ///     - `false`: If speech recognition should be inactive.
  void triggerSpeechRecognitionAs({required bool recognitionState}) {
    emit(recognitionState); // Update the state with the new recognition state.
  }
}

