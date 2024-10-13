
# OfferGoose Clone

This project is an **Interview Assistant App** that converts the interviewer's spoken questions to text using a speech-to-text package and fetches real-time responses from a **Gemini-tuned model**. The application is built using the **Flutter framework** and leverages the **Bloc Cubit** for state management. It follows the **Repository**, **Observer**, and **Dependency Injection** design patterns for clean and scalable architecture.


<div style="display: flex; gap:40px; justify-content: center;">
<img src="https://drive.google.com/uc?export=view&id=1kXhHDTvXxVW6qCnCUDRoG09p6EJk4pVZ"  width="200"/>


<img src="https://drive.google.com/uc?export=view&id=1dNybyBEIHzupzklzZ27PseVTWjqNLP0X"  width="200"/>


<img src="https://drive.google.com/uc?export=view&id=1HmBupCWPi9uU3no8uG7dFi2S7Z_aJUAS"  width="200"/>



</div>

## Features

- **Speech-to-Text Conversion**: Converts the interviewer's spoken questions into text.
- **Real-Time AI Responses**: Fetches responses using the Gemini-tuned model API in real-time.
- **State Management**: Implements Bloc Cubits to manage states efficiently across the app.
- **Repository Pattern**: Decouples business logic from the UI by using repositories.
- **Dependency Injection**: Manages dependencies using DI, ensuring flexibility and testability.
- **Observer Pattern**: Monitors and handles application state transitions.

## Screens

1. **Home Screen**: 
   - Entry point of the app, where the user can initiate the interview process.
   
2. **Formal Interview Screen**:
   - Displays the speech recognition interface, capturing the interviewer's question and converting it into text.
   
3. **Response Screen**:
   - Displays the real-time AI-generated response based on the recognized question, streaming the response from the Gemini-tuned model.

## Architecture Overview

- **Cubit State Management**: 
  - The app uses Cubit for managing various states such as speech recognition, question response streaming, and timers.
  
- **Repository Pattern**: 
  - A **FormalInterviewResponseRepository** is used to interact with the Gemini model API and fetch responses. This ensures a clean separation between the data layer and business logic.

- **Dependency Injection (DI)**:
  - Dependencies such as the `FormalInterviewResponseRepository` and various Cubits are injected throughout the app to maintain testability and flexibility.

- **Observer Pattern**:
  - The app observes state transitions within the Cubits, handling errors, loading, and response events effectively.

## Dependencies

- **Flutter Bloc**: For state management using Cubit.
- **Speech to Text Package**: To capture and convert the interviewer's speech into text.
- **Gemini API (via OpenAI API)**: To generate responses in real-time.
- **Dart dotenv**: For environment variable management.
- **HTTP**: For making network requests to the Gemini API.


## Dependencies

The application utilizes the following packages:

- **cupertino_icons**: ^1.0.8
- **flutter_screenutil**: ^5.9.3
- **speech_to_text**: ^7.0.0
- **flutter_spinkit**: ^5.2.1
- **flutter_bloc**: ^8.1.6
- **flutter_dotenv**: ^5.1.0
- **google_generative_ai**: ^0.4.6



## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/interview-assistant-app.git
   ```

2. **Navigate to the Project Directory:**:
 ```bash
cd interview-assistant-app
```

3. **Install Dependencies**:
 ```bash
flutter pub get
```

4. **Set up the Environment Variables:**:

 ```bash
OPEN_AI_API_KEY=your_gemini_api_key_here
```

5. **Run the App**:
 ```bash
Run the App
```


## How It Works

### Speech-to-Text Recognition:
- The user speaks the question into the app on the **Formal Interview Screen**.
- The `SpeechRecognitionCubit` listens for the speech input and converts it into text using the speech-to-text package.

### Fetching AI Response:
- Once the question is recognized, the app sends the text to the **Gemini-tuned model** via the `FormalInterviewResponseCubit`.
- The response is streamed in real-time, updating the **Response Screen** with each portion of the answer as it arrives.

### State Management:
- Each screen is managed by a corresponding Cubit, which handles state transitions (e.g., loading, streaming, errors).
- The app follows the Bloc Observer pattern to manage these states and log errors.

## Contribution Guidelines
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request, detailing the changes you've made.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Conclusion
Thank you for exploring the **Interview Assistant App**. We hope this application serves as a valuable tool for interview preparation and enhances your experience by leveraging advanced speech recognition and AI response capabilities. For any queries, feedback, or contributions, feel free to reach out.


