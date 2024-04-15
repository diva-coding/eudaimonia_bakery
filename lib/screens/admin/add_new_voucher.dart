import 'package:eudaimonia_bakery/screens/admin/voucher_screen.dart';
import 'package:eudaimonia_bakery/services/voucher_service.dart';
import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/models/voucher.dart';

class AddVoucherPage extends StatefulWidget {
  @override
  _AddVoucherPageState createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherPage> {
  TextEditingController _titleC = TextEditingController();
  TextEditingController _descriptionC = TextEditingController();
  TextEditingController _activeDateC = TextEditingController();
  TextEditingController _expirationDateC = TextEditingController();
  TextEditingController _discountValueC = TextEditingController();
  TextEditingController _quotaC = TextEditingController();

  void _saveVoucher() async {
    // Buat objek voucher dari nilai yang dimasukkan ke dalam TextField
    Voucher voucher = Voucher(
      id: 1,
      title: _titleC.text,
      description: _descriptionC.text,
      activeDate: _activeDateC.text,
      expirationDate: _expirationDateC.text,
      discountValue: int.parse(_discountValueC.text),
      quota: int.parse(_quotaC.text),
    );
    try {
      // Kirim permintaan POST ke API menggunakan layanan VoucherService
      // Anda harus mengimplementasikan metode untuk menyimpan voucher di layanan ini
      await VoucherService.createVoucher(voucher);

      // Tampilkan pesan sukses atau navigasi ke layar lain jika diperlukan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
       Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VoucherScreen()),  
    );
      
    } catch (e) {
      // Tangani kesalahan jika gagal menyimpan voucher
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan voucher: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _titleC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Voucher', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(
                labelText: 'Title',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionC,
              decoration: const InputDecoration(
                labelText: 'Description',
                filled: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              onTap: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _activeDateC,
              decoration: const InputDecoration(
                labelText: 'Active Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_activeDateC);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _expirationDateC,
              decoration: const InputDecoration(
                labelText: 'Expiration Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_expirationDateC);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _discountValueC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '1000',
                labelText: 'Minimal Order (Rp)',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _quotaC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quota',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _saveVoucher();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 179, 126, 89),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(" ")[0];
      });
    }
  }
}
