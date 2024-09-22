import 'package:chatbot/const.dart';
import 'package:chatbot/message.dart';
import 'package:chatbot/optioncard.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _searchController = TextEditingController(); // Controller for the search bar

  static const apiKey = api_key;

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  bool _showIconBar = true; // To toggle between the icon bar and search bar

  
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

  // Function to handle search message submission
  Future<void> _onSendSearchMessage() async {
    final message = _searchController.text;

    if (message.isNotEmpty) {
      setState(() {
        _isChatSubmitted = true;
        _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
        _searchController.clear(); // Clear the search field after submission
      });

      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
      });
    }
  }

  // Function to toggle to the search bar
  void _onSearchIconPressed() {
    setState(() {
      _showIconBar = false; // Show search bar instead of the icon bar
    });
  }

  // Function to cancel search and show the icon bar again
  void _onCancelSearch() {
    setState(() {
      _showIconBar = true; // Show the icon bar again
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021024),
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
                      actions:  [
                        
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                        ),
                         IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // After sign out, Firebase will automatically trigger auth state change
            },
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
                            child: const SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  OptionCard(
                                    title: '🔍 Explain recursion with examples',
                                    icon: Icons.arrow_outward,
                                  ),
                                  SizedBox(width: 20),
                                  OptionCard(
                                    title: '📚 Show me SQL queries examples',
                                    icon: Icons.arrow_outward,
                                  ),
                                  SizedBox(width: 20),
                                  OptionCard(
                                    title: '🚀 Learn Flutter Widgets',
                                    icon: Icons.arrow_outward,
                                  ),
                                  SizedBox(width: 20),
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

          // Toggle between the icon bar and search bar
          _showIconBar ? _buildIconBar() : _buildSearchBar(),
        ],
      ),
    );
  }

  // Function to create the icon bar similar to the one in the image
 // Function to create the icon bar similar to the one in the image
Widget _buildIconBar() {
  return Container(
    // Modify the padding inside the bar
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
    // Modify the margin at the bottom to increase spacing from the screen's bottom
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 40), // Increase the last value to move the bar up

    decoration: BoxDecoration(
      color: const Color(0xFF112946),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: const Color.fromARGB(255, 150, 213, 242),
        width: 2.0,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.group, color: Colors.white),
          onPressed: () {
            // Define what happens when this icon is pressed
          },
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            setState(() {
              // Reset the chat to its default state
              _messages.clear();
              _isChatSubmitted = false;
              _controller.clear(); // Clear the input field
              _searchController.clear(); // Clear the search field if needed
              _showIconBar = true; // Ensure the icon bar is visible
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: _onSearchIconPressed, // Toggle to the search bar when search is clicked
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Define what happens when this icon is pressed
          },
        ),
        IconButton(
          icon: const Icon(Icons.headset, color: Colors.white),
          onPressed: () {
            // Define what happens when this icon is pressed
          },
        ),
      ],
    ),
  );
}

  // Function to create the search bar similar to the text input area with send and mic icons
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 40),
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
              controller: _searchController, // Attach the search controller
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: () {
              // Define what happens when the mic icon is pressed
            },
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _onSendSearchMessage, // Use the search message submission
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: _onCancelSearch, // Cancel the search and show the icon bar again
          ),
        ],
      ),
    );
  }

}
