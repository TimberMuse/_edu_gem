import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MathGeneratorScreen extends StatefulWidget {
  const MathGeneratorScreen({super.key});

  @override
  State<MathGeneratorScreen> createState() => _MathGeneratorScreenState();
}

class _MathGeneratorScreenState extends State<MathGeneratorScreen> {
  final TextEditingController _topicController = TextEditingController();
  String _generatedProblem = '';
  bool _isLoading = false;

  // TODO: Replace with your actual API key or fetch it from a secure source
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  Future<void> _generateProblem() async {
    if (_topicController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedProblem = '';
    });

    try {
      // Initialize the generative model
      // Note: This requires the API key to be set. 
      // For the prototype, we'll simulate the response if no key is present to avoid crashing.
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _generatedProblem =
              "Simulation: (Please set your API Key to get real AI results)\n\n"
              "If you have 5 ${_topicController.text}s and your friend gives you 3 more, "
              "how many ${_topicController.text}s do you have?";
          _isLoading = false;
        });
        return;
      }

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _apiKey,
      );

      final prompt = 'Generate a simple math word problem for a 6-year-old involving ${_topicController.text}.';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _generatedProblem = response.text ?? 'No response from AI.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _generatedProblem = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Magician'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What do you want to count?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                hintText: 'e.g., Dinosaurs, Space ships, Cupcakes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateProblem,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text('Generate Problem'),
            ),
            const SizedBox(height: 30),
            if (_generatedProblem.isNotEmpty) ...[
              Text(
                'Your Problem:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _generatedProblem,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
