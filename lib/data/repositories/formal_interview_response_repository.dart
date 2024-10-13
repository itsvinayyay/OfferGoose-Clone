import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:offer_goose_clone/constants/model_tuning.dart';

/// This class is responsible for interacting with the Gemini API to generate
/// formal interview responses in real-time via a content stream.
class FormalInterviewResponseRepository {
  // Initialize the Gemini model with the latest version and the API key
  final GenerativeModel _geminiModel = GenerativeModel(
    model: 'gemini-1.5-flash-latest',  // Specify the Gemini API model version
    apiKey: dotenv
        .get("OPEN_AI_API_KEY"), // Fetch the API key securely from environment variables
  );

  /// Stream a response from the Gemini API based on the input question
  /// 
  /// This function streams responses from the Gemini model, enabling real-time
  /// feedback as the response is being generated. It yields parts of the response
  /// progressively until the full answer is received.
  ///
  /// - [question]: The input interview question for which the model will generate
  ///               a formal response.
  ///
  /// Returns:
  ///   A `Stream` of `Map<String, dynamic>` where each entry contains:
  ///   - 'text': The generated response text from the Gemini model.
  ///   - 'isComplete': A boolean flag indicating whether the response stream is complete.
  Stream<Map<String, dynamic>> getQuestionResponse(
      {required String question}) async* {
    try {
      // Define the prompt with the input interview question, formatted
      // using the `interviewTuning` function to customize the response.
      final prompt = [
        Content.text(interviewTuning(interviewQuestion: question))
      ];

      // Stream the content response from the Gemini API in real-time.
      final responses = _geminiModel.generateContentStream(prompt);

      // Listen for each part of the generated response from the API.
      await for (final response in responses) {
        if (response.text!.isNotEmpty) {
          // Yield the response text along with a flag indicating that the
          // response stream is still in progress.
          yield {
            'text': response.text!,  // Current segment of the response text
            'isComplete': false,     // Response is still being streamed
          };
        }
      }

      // Once all parts of the response have been received, yield a final empty text
      // and mark the stream as complete.
      yield {
        'text': '',              // No more content, response is fully streamed
        'isComplete': true,      // Mark the completion of the stream
      };
    } catch (e) {
      // Catch any exceptions that occur during the streaming process, log the error
      log("Exception occurred while generating response from Gemini API: $e");
      rethrow; // Rethrow the exception to propagate it up the call stack
    }
  }
}
