
import 'package:chatbot/const.dart';
import 'package:chatbot/drawer.dart';
import 'package:chatbot/optioncard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isChatSubmitted = false;
  final List<Message> _messages = []; // List to store user messages
  final TextEditingController _controller = TextEditingController();

  static const apiKey = api_key;

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  // Function to handle message submission
  Future<void> _onSendMessage() async {
    final message = _controller.text;

    if (_controller.text.isNotEmpty) {
      setState(() {
        _isChatSubmitted = true;
        _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
        _controller.clear(); // Clear the text field after submission
      });

      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF021024),
    drawer: CustomDrawer(),
    body: Column(
      children: [
        // Top part with AppBar and welcome message
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Container(
                  height: 39.0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 150, 213, 242),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 5, 51, 94),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      'RIZZ GPT',
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                top: 160,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show introduction text only if the chat hasn't been submitted
                      if (!_isChatSubmitted) ...[
                        Text(
                          'Hello!',
                          style: GoogleFonts.oi(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          'Rizzvankar',
                          style: GoogleFonts.oi(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          'How can I help you today?',
                          style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 70),
                      ],

                      // Option Cards
                      if (!_isChatSubmitted)
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 70, 92, 129),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                OptionCard(
                                  title: '🔍 Explain recursion with examples',
                                  icon: Icons.arrow_outward,
                                ),
                                const SizedBox(width: 20),
                                OptionCard(
                                  title: '📚 Show me SQL queries examples',
                                  icon: Icons.arrow_outward,
                                ),
                                const SizedBox(width: 20),
                                OptionCard(
                                  title: '🚀 Learn Flutter Widgets',
                                  icon: Icons.arrow_outward,
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),

                      // Chat Messages Area
                      if (_isChatSubmitted)
                        Flexible(
                          child: ListView.builder(
                            reverse: true, // Start from the bottom
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[_messages.length - 1 - index]; // Reverse order
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Align(
                                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: message.isUser
                                          ? const Color.fromARGB(255, 70, 92, 129)
                                          : const Color.fromARGB(255, 150, 213, 242),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      message.message,
                                      style: GoogleFonts.caveat(
                                        color: message.isUser ? Colors.white : Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chat Input Bar
        _buildInputBar(),
      ],
    ),
  );
}


  Widget _buildInputBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF112946),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color.fromARGB(255, 150, 213, 242),
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller, // Controller for the text field
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                hintText: "   ✨Ask .....",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onSendMessage, // Call the function when the send icon is clicked
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 150, 213, 242),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
              child: const Row(
                children: [
                  Icon(Icons.mic, color: Colors.black, size: 20),
                  SizedBox(width: 15),
                  Icon(Icons.subdirectory_arrow_left, color: Colors.black, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}
class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      // margin: EdgeInsets.symmetric(vertical: 15).copyWith(
      //   left: isUser ? 100 : 10,
      //   right: isUser ? 10 : 100,
      // ),
      decoration: BoxDecoration(
        color: isUser ? Colors.blueAccent : Colors.grey.shade400,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
    );
  }
}


