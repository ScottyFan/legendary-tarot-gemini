import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot Reading',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1a0033),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔮 Tarot Reading', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2d0052),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨ Welcome to Your Tarot Journey ✨',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Choose your reading type:',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              SpreadCard(
                title: 'Single Card',
                description: 'Quick guidance for your day',
                icon: '🃏',
                spread: TarotSpread.singleCard,
              ),
              const SizedBox(height: 16),
              SpreadCard(
                title: 'Three Card Spread',
                description: 'Past, Present, Future',
                icon: '🎴',
                spread: TarotSpread.threeCard,
              ),
              const SizedBox(height: 16),
              SpreadCard(
                title: 'Celtic Cross',
                description: 'Deep insight into your situation',
                icon: '✨',
                spread: TarotSpread.celticCross,
              ),
              const SizedBox(height: 16),
              SpreadCard(
                title: 'Love & Relationship',
                description: 'Explore matters of the heart',
                icon: '💖',
                spread: TarotSpread.love,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpreadCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final TarotSpread spread;

  const SpreadCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.spread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionScreen(spread: spread, spreadName: title),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3d1f5c),
              Color(0xFF2d0052),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  final TarotSpread spread;
  final String spreadName;

  const QuestionScreen({
    Key? key,
    required this.spread,
    required this.spreadName,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spreadName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2d0052),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Focus on Your Question',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Take a deep breath and think about what guidance you seek...',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'What guidance do you seek?',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2d0052),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_questionController.text.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardSelectionScreen(
                          spread: widget.spread,
                          spreadName: widget.spreadName,
                          question: _questionController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Draw Cards',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}

class CardSelectionScreen extends StatefulWidget {
  final TarotSpread spread;
  final String spreadName;
  final String question;

  const CardSelectionScreen({
    Key? key,
    required this.spread,
    required this.spreadName,
    required this.question,
  }) : super(key: key);

  @override
  State<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  List<int> selectedCards = [];
  int cardsNeeded = 0;
  List<int> cardPositions = [];

  @override
  void initState() {
    super.initState();
    cardsNeeded = _getCardsNeeded(widget.spread);
    // Generate 22 random positions for the Major Arcana
    cardPositions = List.generate(22, (i) => i)..shuffle(Random());
  }

  int _getCardsNeeded(TarotSpread spread) {
    switch (spread) {
      case TarotSpread.singleCard:
        return 1;
      case TarotSpread.threeCard:
        return 3;
      case TarotSpread.love:
        return 4;
      case TarotSpread.celticCross:
        return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select ${selectedCards.length}/$cardsNeeded Cards',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2d0052),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              selectedCards.length < cardsNeeded
                  ? 'Choose the cards that call to you...'
                  : 'Your cards have been chosen',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 22,
              itemBuilder: (context, index) {
                bool isSelected = selectedCards.contains(index);
                return GestureDetector(
                  onTap: () {
                    if (!isSelected && selectedCards.length < cardsNeeded) {
                      setState(() {
                        selectedCards.add(index);
                      });
                    } else if (isSelected) {
                      setState(() {
                        selectedCards.remove(index);
                      });
                    }
                  },
                  child: TarotCardBack(
                    isSelected: isSelected,
                    selectionNumber: selectedCards.indexOf(index) + 1,
                  ),
                );
              },
            ),
          ),
          if (selectedCards.length == cardsNeeded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    List<String> selectedCardNames = selectedCards
                        .map((i) => TarotCards.majorArcana[cardPositions[i]])
                        .toList();
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(
                          spread: widget.spread,
                          spreadName: widget.spreadName,
                          question: widget.question,
                          selectedCards: selectedCardNames,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reveal Your Reading',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TarotCardBack extends StatelessWidget {
  final bool isSelected;
  final int selectionNumber;

  const TarotCardBack({
    Key? key,
    required this.isSelected,
    required this.selectionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.deepPurpleAccent,
          width: isSelected ? 3 : 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [Colors.amber.shade700, Colors.amber.shade900]
              : [const Color(0xFF4a148c), const Color(0xFF2d0052)],
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  '🌙',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$selectionNumber',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReadingScreen extends StatefulWidget {
  final TarotSpread spread;
  final String spreadName;
  final String question;
  final List<String> selectedCards;

  const ReadingScreen({
    Key? key,
    required this.spread,
    required this.spreadName,
    required this.question,
    required this.selectedCards,
  }) : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _isLoading = true;
  String _reading = '';
  
  // Update this URL based on your setup:
  // For Android Emulator: 'http://10.0.2.2:3000/api/tarot'
  // For iOS Simulator: 'http://localhost:3000/api/tarot'
  // For physical device: 'http://YOUR_COMPUTER_IP:3000/api/tarot'
  final String backendUrl = 'http://localhost:3000/api/tarot';

  @override
  void initState() {
    super.initState();
    _getReading();
  }

  Future<void> _getReading() async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question': widget.question,
          'spread': widget.spread.toString().split('.').last,
          'cards': widget.selectedCards,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _reading = data['response'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _reading = 'Sorry, I encountered an error. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _reading = 'Failed to connect to the server. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spreadName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2d0052),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurpleAccent),
                  SizedBox(height: 20),
                  Text(
                    'Channeling the wisdom of the cards...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2d0052),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Question:',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Cards:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.selectedCards
                        .map((card) => Chip(
                              label: Text(card),
                              backgroundColor: const Color(0xFF3d1f5c),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.deepPurpleAccent),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Reading:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _reading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'New Reading',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

enum TarotSpread {
  singleCard,
  threeCard,
  celticCross,
  love,
}

class TarotCards {
  static const List<String> majorArcana = [
    'The Fool',
    'The Magician',
    'The High Priestess',
    'The Empress',
    'The Emperor',
    'The Hierophant',
    'The Lovers',
    'The Chariot',
    'Strength',
    'The Hermit',
    'Wheel of Fortune',
    'Justice',
    'The Hanged Man',
    'Death',
    'Temperance',
    'The Devil',
    'The Tower',
    'The Star',
    'The Moon',
    'The Sun',
    'Judgement',
    'The World',
  ];
}