import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Eudaimonia Bakery'),
        backgroundColor: Constants.secondaryColor,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to Eudaimonia Bakery!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'At Eudaimonia Bakery, we believe in the joy of fresh, delicious baked goods delivered right to your doorstep. Inspired by the Greek word "Eudaimonia," meaning a state of good spirit or happiness, our mission is to bring happiness and satisfaction to our customers through our convenient and user-friendly online bakery platform.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Our primary goal is to simplify the process of ordering and purchasing baked goods from local bakeries, allowing you to enjoy your favorite treats without the need to visit the store physically. We aim to support local bakeries by providing them with a platform to expand their reach and increase their sales through digital channels.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'What We Offer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Convenience: Order your favorite breads, cakes, and pastries from the comfort of your home.\n'
              '- Wide Selection: Discover a variety of baked goods from different local bakeries all in one place.\n'
              '- Detailed Product Information: Get comprehensive details about ingredients, prices, availability, and customer reviews.\n'
              '- Efficient Order Management: Experience a seamless and accurate order processing system.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Why Choose Eudaimonia Bakery?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- User-Friendly Interface: Our application is designed to be intuitive and easy to navigate, ensuring a hassle-free shopping experience.\n'
              '- Support Local Businesses: By using our platform, you are helping local bakeries grow and thrive in the digital age.\n'
              '- Quality and Freshness: We partner with the best local bakeries to bring you high-quality and freshly baked products.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Join Us in Celebrating the Joy of Baking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We invite you to explore our app, discover delightful baked goods, and experience the convenience and happiness that Eudaimonia Bakery brings. Whether you\'re craving a freshly baked loaf of bread, a decadent cake, or a sweet pastry, we’ve got you covered.\n\n'
              'Thank you for choosing Eudaimonia Bakery. We look forward to serving you!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
