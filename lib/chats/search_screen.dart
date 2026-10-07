import 'package:flutter/material.dart';

import 'chat_room_screen.dart';
import 'widget/common.dart';

class SearchItem {
  final String title;
  final String subtitle;
  final String id; 
  final bool isGroup;
  final String? roomSubtitle; 
  final String keywords; 
  const SearchItem({
    required this.title,
    required this.subtitle,
    required this.id,
    required this.keywords,
    this.isGroup = false,
    this.roomSubtitle,
  });
}

class SearchScreen extends StatefulWidget {
  final List<SearchItem> items;
  final String hint;
  const SearchScreen({super.key, required this.items, this.hint = 'Search'});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? widget.items
        : widget.items
            .where((i) => i.keywords.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 75,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.3),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18),
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() => _query = '');
                      },
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search,
                              color: Colors.grey.shade600, size: 56),
                          const SizedBox(height: 16),
                          const Text(
                            'No Results Found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final r = results[i];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 28),
                          leading: r.isGroup
                              ? Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.group,
                                      color: Colors.blue, size: 26),
                                )
                              : AppAvatar(name: r.title, size: 52),
                          title: Text(
                            r.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          subtitle: Text(
                            r.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatRoomScreen(
                                name: r.title,
                                number: r.id,
                                subtitle: r.roomSubtitle,
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
    );
  }
}