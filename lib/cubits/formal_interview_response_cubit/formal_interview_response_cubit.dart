import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offer_goose_clone/cubits/formal_interview_response_cubit/formal_interview_response_states.dart';
import 'package:offer_goose_clone/data/repositories/formal_interview_response_repository.dart';

/// This class manages the state for formal interview responses using the 
/// Bloc (Cubit) state management approach. It interacts with the 
/// `FormalInterviewResponseRepository` to fetch and stream real-time 
/// interview responses from the Gemini API.
class FormalInterviewResponseCubit extends Cubit<FormalInterviewResponseStates> {
  
  /// Constructor for initializing the cubit with the initial state.
  FormalInterviewResponseCubit() : super(InitialResponseState());

  /// An instance of the `FormalInterviewResponseRepository` to handle
  /// communication with the Gemini API.
  final FormalInterviewResponseRepository _formalInterviewResponseRepository =
      FormalInterviewResponseRepository();

  /// Fetch interview responses by streaming content from the Gemini API
  ///
  /// This method listens to the response stream generated by the Gemini API
  /// in real-time, progressively accumulating the response, and updates
  /// the state as each part of the response is received.
  ///
  /// - [question]: The interview question to be submitted to the API.
  ///
  /// Emits:
  ///   - `LoadingResponseState`: While the response is being fetched.
  ///   - `LoadedResponseState`: When the full response is fetched successfully.
  ///   - `ErrorResponseState`: In case of any error or exception.
  Future<void> fetchResponses({required String question}) async {
    try {
      // Emit a loading state with the current response (if any).
      emit(LoadingResponseState(state.response));

      // Get the response stream from the repository.
      final Stream<Map<String, dynamic>> responseStream =
          _formalInterviewResponseRepository.getQuestionResponse(
              question: question);

      // Variable to accumulate the response parts as they are received.
      String accumulatedResponse = "";

      // Listen for the stream of responses from the repository.
      await for (final partialResponse in responseStream) {
        // Accumulate the text part of the response.
        accumulatedResponse += partialResponse['text'];

        // Check if the response stream is complete.
        if (partialResponse['isComplete'] == true) {
          // If complete, emit the loaded state with the full response.
          emit(LoadedResponseState(accumulatedResponse));
        } else {
          // If not complete, emit a loading state with the partial response.
          emit(LoadingResponseState(accumulatedResponse));
        }
      }
    } catch (e) {
      // Log the exception and emit an error state with the current response and error message.
      log("Exception thrown at Formal Interview Response Repository => $e");
      emit(ErrorResponseState(state.response, e.toString()));
    }
  }

  /// Reset the state to an initial loading state, indicating preparation
  /// for generating a new interview response.
  void resetInitialResponse() {
    emit(LoadingResponseState("Preparing tuned response for you..."));
  }
}
