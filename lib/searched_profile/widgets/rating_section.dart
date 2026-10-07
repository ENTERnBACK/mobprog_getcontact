import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingSection extends StatefulWidget {
  final String phoneNumber;
  final double baseRating; 
  final int baseReviews; 

  const RatingSection({
    super.key,
    required this.phoneNumber,
    required this.baseRating,
    required this.baseReviews,
  });

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  double? _myRating;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyRating();
  }

  Future<void> _loadMyRating() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRating = prefs.getDouble('my_rating_${widget.phoneNumber}');
    setState(() {
      _myRating = savedRating;
      _isLoading = false;
    });
  }

  Future<void> _saveRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('my_rating_${widget.phoneNumber}', rating);
    setState(() {
      _myRating = rating;
    });
  }

  void _showRatingDialog() {
    int tempRating = _myRating?.toInt() ?? 0;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Rate this number'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How do you rate this number?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < tempRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            tempRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: tempRating > 0
                      ? () {
                          _saveRating(tempRating.toDouble());
                          Navigator.pop(context);
                        }
                      : null, 
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
    }

    // Kalkulasi Skor Total
    int totalReviews = widget.baseReviews + (_myRating != null ? 1 : 0);
    double currentTotalScore = (widget.baseRating * widget.baseReviews) + (_myRating ?? 0);
    double displayedRating = totalReviews == 0 ? 0.0 : currentTotalScore / totalReviews;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    displayedRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Text(
                    'from 5.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        IconData icon = Icons.star_border;
                        if (index < displayedRating.floor()) {
                          icon = Icons.star;
                        } else if (index < displayedRating.ceil() && displayedRating % 1 != 0) {
                          icon = Icons.star_half;
                        }
                        return Icon(icon, color: Colors.amber, size: 28);
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on $totalReviews community reviews',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tombol untuk user memberi rating
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showRatingDialog,
              icon: Icon(
                _myRating != null ? Icons.star : Icons.star_border, 
                color: Colors.amber
              ),
              label: Text(
                _myRating != null ? 'Your Rating: ${_myRating!.toInt()} Stars' : 'Rate this number',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}