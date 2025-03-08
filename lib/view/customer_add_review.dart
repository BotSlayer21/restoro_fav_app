import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/review.dart';

class AddReview extends StatefulWidget {
  static const routeName = '/tambah_review';
  final String id;
  const AddReview({super.key, required this.id});

  @override
  TambahReviewState createState() => TambahReviewState();
}

class TambahReviewState extends State<AddReview> {
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Review',
                hintText: 'Masukkan Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                PostReview review = PostReview(
                  id: widget.id,
                  name: nameController.text,
                  review: reviewController.text,
                );

                ApiService(client: Client()).postReview(review).then((response) {
                  // Handle response jika diperlukan
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("[${response.statusCode}] Review submitted")),
                  );
                  // Clear input fields
                  nameController.clear();
                  reviewController.clear();
                }).catchError((error) {
                  // Handle error jika ada
                  if (error.contains('Timeout') || error.contains('Client')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Periksa Jaringan Anda')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    );
                  }
                });
              },
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}