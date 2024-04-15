import 'package:eudaimonia_bakery/screens/admin/add_new_voucher.dart';
import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/models/voucher.dart';
import 'package:eudaimonia_bakery/services/voucher_service.dart';
import 'package:eudaimonia_bakery/screens/admin/detail_voucher_screen.dart';
import 'package:eudaimonia_bakery/screens/admin/update_voucher_screen.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => VoucherScreenState();
}

class VoucherScreenState extends State<VoucherScreen> {
  
   Future<void> _showDeleteConfirmationDialog(int voucherId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Voucher'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this voucher?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Call delete voucher function and close dialog
                VoucherService.deleteVoucher(voucherId);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 126, 89),
      appBar: AppBar(
        title: const Text('Manage Voucher', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: FutureBuilder<List<Voucher>>(
        future: VoucherService.fetchVouchers(), 
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            }else{
              List<Voucher> vouchers = snapshot.data ?? [];
              return ListView.builder(
                itemCount: vouchers.length,
                itemBuilder: (context, index) {
                  return GestureDetector( 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailVoucherScreen(voucher: vouchers[index])));                     
                    },
                    child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vouchers[index].title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                Text("Min. Order: Rp ${vouchers[index].discountValue}"),
                                Text("Quota: ${vouchers[index].quota}")
                              ],
                            ),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateVoucherPage(voucher: vouchers[index]),));
                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: (){
                                  _showDeleteConfirmationDialog(vouchers[index].id);
                                }, icon: Icon(Icons.delete)),
                              ],
                            ))
                          ]
                      ),
                    )         
                  ),
                );                  
                },
              );
            }
          },
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVoucherPage())
          );
        },
        label: const Text('Add New Voucher'),
        icon: const Icon(Icons.add),
      ),
    );
  }
} 

