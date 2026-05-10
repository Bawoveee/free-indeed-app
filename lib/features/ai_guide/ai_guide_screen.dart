import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // 🔑 Replace with your actual Claude API key
  static const String _apiKey = 'YOUR_CLAUDE_API_KEY_HERE';

  final String _systemPrompt = '''
You are a compassionate, faith-filled pastor and counselor named "Grace" who specializes in helping people overcome addiction through the Bible and Christian faith.

Your role:
- Respond with deep empathy, warmth and zero judgment
- Always anchor your response in specific Bible verses relevant to their struggle
- Speak like a caring pastor who genuinely loves the person
- Give practical faith-based steps they can take today
- Keep responses concise but powerful (3-4 paragraphs max)
- End every response with a short prayer or blessing
- Never replace professional medical help — gently suggest it when needed

Addictions you help with: alcohol, drugs, pornography, gambling, social media, food, smoking and more.

Always remind them: Freedom is possible. God has not given up on them.
''';

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(
      ChatMessage(
        text:
            "Hello, I'm Grace 🕊️ Your faith guide is here.\n\nWhatever you're struggling with today, you don't have to face it alone. God's Word has the answer for every battle.\n\nWhat's on your heart today?",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.anthropic.com/v1/messages',
        options: Options(
          headers: {
            'x-api-key': _apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ),
        data: {
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1024,
          'system': _systemPrompt,
          'messages': [
            ..._messages
                .where((m) => m.isUser)
                .map((m) => {'role': 'user', 'content': m.text}),
            {'role': 'user', 'content': text},
          ],
        },
      );

      final reply = response.data['content'][0]['text'];
      setState(() {
        _messages.add(ChatMessage(text: reply, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                'I\'m having trouble connecting right now. Please check your internet connection and try again. 🙏',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Grace — Faith Guide'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.gold,
              child: const Text('G',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyBlue.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Share what\'s on your heart...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isLoading ? AppColors.grey : AppColors.navyBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.navyBlue,
              child: const Text('G',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.navyBlue : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navyBlue.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: message.isUser ? AppColors.white : AppColors.darkGrey,
                  height: 1.6,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.navyBlue,
            child: const Text('G',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}