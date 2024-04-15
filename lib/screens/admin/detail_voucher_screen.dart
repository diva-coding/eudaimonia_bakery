import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/models/voucher.dart';

class DetailVoucherScreen extends StatefulWidget {
    final Voucher voucher;
  const DetailVoucherScreen({super.key, required this.voucher});

  @override
  State<DetailVoucherScreen> createState() => _DetailVoucherScreenState();
}

class _DetailVoucherScreenState extends State<DetailVoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Detail Voucher', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(widget.voucher.title, style:TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.voucher.description),
                  Text('Min. Order: ${widget.voucher.discountValue}'),
                  Text('Start ${widget.voucher.activeDate} until ${widget.voucher.expirationDate}'),
                  Text('Quota: ${widget.voucher.quota}')
              ],
          ),
        ),
    );
  }
}