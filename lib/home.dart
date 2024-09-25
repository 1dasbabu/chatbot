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
  final TextEditingController _searchController = TextEditingController();
   User? user =
      FirebaseAuth.instance.currentUser; // Controller for the search bar

  static const apiKey = api_key;

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  bool _showIconBar = true; // To toggle between the icon bar and search bar

  void _handleOptionTap(String text) {
    setState(() {
      _searchController.text = text; // Set the search controller's text
    });
    _onSendSearchMessage(); // Trigger the search message submission
  }

  void _showUserDetails() {
    const double iconBarHeight = 60.0; // Height of the icon bar

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'User Details',
      transitionDuration:
          const Duration(milliseconds: 500), // Custom animation duration
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // User Details window positioned higher above the icon bar
            Positioned(
              bottom: iconBarHeight + 70, // Adjust this as needed
              left: 20,
              right: 20,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1), // Start from below
                  end: Offset.zero, // End at the final position
                ).animate(CurvedAnimation(
                  parent: anim1,
                  curve: Curves.easeInOut, // Smooth easing animation
                )),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.5, // Limits height to 50% of the screen
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF021024), // Background color (dark blue)
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white, // White border for a polished look
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    // Make content scrollable
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // User details with edit option
                        Row(
                          children: [
                            // Circle avatar (profile image placeholder)
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              backgroundImage: user?.photoURL != null
                                  ? NetworkImage(user!
                                      .photoURL!) // Use user's profile picture if available
                                  : null, // Fallback if no profile picture
                              child: user?.photoURL == null
                                  ? const Icon(Icons.person,
                                      size: 40,
                                      color: Colors
                                          .grey) // Default icon if no image
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'User Name',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration
                                          .none, // Ensure no underlining
                                    ),
                                  ),
                                  Text(
                                    user?.email ?? 'user@example.com',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      decoration: TextDecoration
                                          .none, // Ensure no underlining
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Edit IconButton inside the window
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                // Implement the edit functionality here
                                _editUserDetails();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            // Navigate back to login screen or handle after sign-out action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // The icon bar stays fixed at the bottom
            Positioned(
              bottom: 0, // Fix the icon bar to the bottom
              left: 0,
              right: 0,
              child: _buildIconBar(), // Your icon bar widget
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut, // Fade in with smooth easing
          ),
          child: child,
        );
      },
    );
  }

  void _showAboutUs() {
    // Define the height of the icon bar
    const double iconBarHeight = 60.0;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'About Rizz GPT',
      transitionDuration:
          const Duration(milliseconds: 500), // Custom animation duration
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // "About Us" window positioned further higher above the icon bar
            Positioned(
              bottom: iconBarHeight + 70, // Adjust this as needed
              left: 20,
              right: 20,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin:
                      const Offset(0, 1), // Start from just above the icon bar
                  end: Offset.zero, // End at the final position
                ).animate(CurvedAnimation(
                  parent: anim1,
                  curve: Curves.easeInOut, // Smooth easing animation
                )),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.7, // Limits height to 70% of the screen
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF021024), // Background color (dark blue)
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white, // White border for a polished look
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'About Rizz GPT',
                          style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontSize: 28,
                              decoration: TextDecoration.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rizz GPT is your personal AI-powered programming assistant! Built with the Gemini API for fast, accurate coding help, it supports multiple languages and solves your coding challenges instantly.\n\n'
                                'With Firestore for secure data and a sleek design crafted in Figma, Rizz GPT is your go-to tool for seamless coding, made in Flutter for flexibility across platforms.',
                                style: GoogleFonts.caveat(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Close Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the modal
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // The icon bar stays fixed at the bottom
            Positioned(
              bottom: 0, // Fix the icon bar to the bottom
              left: 0,
              right: 0,
              child: _buildIconBar(), // Your icon bar widget
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut, // Fade in with smooth easing
          ),
          child: child,
        );
      },
    );
  }

  // Function to handle the user details edit
void _editUserDetails() {
  // Close any existing modal
  Navigator.of(context).pop();

  // Show the dialog for editing the username
  showDialog(
    context: context,
    builder: (context) {
      // Create a TextEditingController and set the initial value to the current display name
      final nameController = TextEditingController(text: user?.displayName ?? '');

      return AlertDialog(
        title: const Text('Edit User Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          // Cancel button to close the dialog without saving
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          // Save button to update the username
          TextButton(
            onPressed: () async {
              // Check if the input is not empty
              if (nameController.text.isNotEmpty) {
                try {
                  // Update the user's display name in Firebase
                  await user?.updateDisplayName(nameController.text);

                  // Reload the user to get the updated data
                  await user?.reload();

                  // Fetch the updated current user and set it in the state
                  final updatedUser = FirebaseAuth.instance.currentUser;

                  setState(() {
                    user = updatedUser; // Update the `user` object with the refreshed data
                  });

                  // Optionally show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Username updated successfully!')),
                  );

                  // Close the dialog after saving
                  Navigator.of(context).pop();
                } catch (e) {
                  // Handle any errors (e.g., display an error message)
                  print("Error updating user display name: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}


  Future<void> _onSendMessage() async {
    final message = _controller.text;

    if (_controller.text.isNotEmpty) {
      setState(() {
        _isChatSubmitted = true;
        _messages
            .add(Message(isUser: true, message: message, date: DateTime.now()));
        _controller.clear(); // Clear the text field after submission
      });

      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(
            isUser: false, message: response.text ?? "", date: DateTime.now()));
      });
    }
  }

  // Function to handle search message submission
  Future<void> _onSendSearchMessage() async {
    final message = _searchController.text;

    if (message.isNotEmpty) {
      setState(() {
        _isChatSubmitted = true;
        _messages
            .add(Message(isUser: true, message: message, date: DateTime.now()));
        _searchController.clear(); // Clear the search field after submission
      });

      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(
            isUser: false, message: response.text ?? "", date: DateTime.now()));
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF021024),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: statusBarHeight +
                      22, // Adjust based on the status bar height
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 39.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 150, 213, 242),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(15),
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
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20, // Adjust the radius if needed
                              backgroundImage: user?.photoURL != null
                                  ? NetworkImage(user!
                                      .photoURL!) // Display the user's photo if available
                                  : null, // Leave null if there's no photoURL
                              child: user?.photoURL == null
                                  ? const Icon(Icons.person,
                                      color: Colors
                                          .black) // Placeholder icon if no photo
                                  : null, // No child widget if photoURL exists
                            ),
                          ),
                        ],
                      )),
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
                            // 'Rizzvankar',
                            user?.displayName?? 'Guest',
                            style: GoogleFonts.oi(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                            maxLines: 1, // Ensure it's a single line
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis if the text overflows
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
                                    onTap: () {
                                      _handleOptionTap(
                                          '🔍 Explain recursion with examples');
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  OptionCard(
                                    title: '📚 Show me SQL queries examples',
                                    icon: Icons.arrow_outward,
                                    onTap: () {
                                      _handleOptionTap(
                                          '📚 Show me SQL queries examples');
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  OptionCard(
                                    title: '🚀 What are Flutter Widgets',
                                    icon: Icons.arrow_outward,
                                    onTap: () {
                                      _handleOptionTap(
                                          '🚀 Learn Flutter Widgets');
                                    },
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
                                final message = _messages[_messages.length -
                                    1 -
                                    index]; // Reverse order
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Align(
                                    alignment: message.isUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: message.isUser
                                            ? const Color.fromARGB(
                                                255, 70, 92, 129)
                                            : const Color.fromARGB(
                                                255, 150, 213, 242),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        message.message,
                                        style: GoogleFonts.caveat(
                                          color: message.isUser
                                              ? Colors.white
                                              : Colors.black,
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
  // F// Function to create the icon bar with larger icons
  Widget _buildIconBar() {
    return Container(
      // Modify the padding inside the bar
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      // Modify the margin at the bottom to increase spacing from the screen's bottom
      margin: const EdgeInsets.fromLTRB(
          16, 0, 16, 40), // Increase the last value to move the bar up

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
          // First icon: People/group icon with larger size
          IconButton(
            icon: const Icon(Icons.groups, color: Colors.white),
            iconSize: 30.0, // Increase the icon size here
            onPressed: _showAboutUs,
          ),
          // Second icon: Plus icon with larger size
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            iconSize: 30.0, // Increase the icon size here
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
          // Third icon: Search icon with larger size
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            iconSize: 30.0, // Increase the icon size here
            onPressed:
                _onSearchIconPressed, // Toggle to the search bar when search is clicked
          ),
          // Fourth icon: Gear/settings icon with larger size
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            iconSize: 30.0, // Increase the icon size here
            onPressed: () {
              _showUserDetails();
            },
          ),
          // Fifth icon: Collection or library icon with larger size
          IconButton(
            icon: const Icon(Icons.library_books, color: Colors.white),
            iconSize: 30.0, // Increase the icon size here
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
            onPressed:
                _onSendSearchMessage, // Use the search message submission
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed:
                _onCancelSearch, // Cancel the search and show the icon bar again
          ),
        ],
      ),
    );
  }
}
