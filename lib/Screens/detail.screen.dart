import 'package:flutter/material.dart';

class Recipe {
  final int id;
  final String title;
  final String image;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final double rating;
  final int totalRatings;
  final int comments;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.rating,
    required this.totalRatings,
    required this.comments,
  });
}

class DetailScreen extends StatefulWidget {
  final Recipe recipe;

  const DetailScreen({
    required this.recipe,
    super.key,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLiked = false;
  bool isSaved = false;
  int userRating = 0;
  bool showCommentBox = false;
  String comment = '';

  void handleSubmitComment() {
    if (comment.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment submitted: $comment')),
      );
      setState(() {
        comment = '';
        showCommentBox = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image with Back Button
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  color: Colors.white,
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 100,
                    color: const Color(0xFF1B2430).withOpacity(0.3),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1B2430),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Container(
              color: const Color(0xFFF9EFD7),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.recipe.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF1B2430).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Interactive Features
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Like Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked
                                      ? Colors.red
                                      : const Color(0xFF1B2430),
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Like',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Save Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSaved = !isSaved;
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: const Color(0xFF1B2430),
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Comment Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showCommentBox = !showCommentBox;
                              });
                            },
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.message,
                                  color: Color(0xFF1B2430),
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.recipe.comments.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Rating Display
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.recipe.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.recipe.totalRatings} ratings',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      const Color(0xFF1B2430).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Rating
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate this recipe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(
                              5,
                              (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userRating = index + 1;
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.star,
                                    color: index < userRating
                                        ? Colors.amber
                                        : Colors.grey[300],
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Comment Box
                    if (showCommentBox)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add a comment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111111),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  comment = value;
                                });
                              },
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Share your thoughts about this recipe...',
                                hintStyle: TextStyle(
                                  color: const Color(0xFF1B2430)
                                      .withOpacity(0.5),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9EFD7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: handleSubmitComment,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF1B2430),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        showCommentBox = false;
                                        comment = '';
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (showCommentBox) const SizedBox(height: 24),

                    // Ingredients
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: List.generate(
                              widget.recipe.ingredients.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin:
                                          const EdgeInsets.only(top: 6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1B2430),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.recipe.ingredients[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instructions
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instructions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: List.generate(
                              widget.recipe.instructions.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1B2430),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        widget.recipe.instructions[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}