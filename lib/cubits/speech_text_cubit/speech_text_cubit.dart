import 'package:flutter_bloc/flutter_bloc.dart';

/// This Cubit class manages the state of the transcribed text from speech recognition.
///
/// It holds a `String` state, which represents the current recognized text, and
/// allows for updating the text as speech is transcribed in real-time.
class SpeechTextCubit extends Cubit<String> {
  
  /// Constructor for initializing the speech recognition text.
  ///
  /// The initial state is set to a default string, indicating that the system
  /// is currently recognizing the interviewer's question.
  SpeechTextCubit() : super("Recognizing the Interviewer's Question...");

  /// Method to trigger a change in the recognized text.
  ///
  /// This method updates the current state of the Cubit to reflect the new
  /// transcribed text received from speech recognition.
  ///
  /// - [changeInText]: A required `String` parameter representing the new
  ///   text recognized by the speech recognition system.
  void triggerText({required String changeInText}) {
    emit(changeInText); // Update the state with the newly recognized text.
  }
}
