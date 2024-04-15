import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eudaimonia_bakery/models/voucher.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';

class VoucherService{
    static Future<List<Voucher>> fetchVouchers() async{
        final response = await http.get(Uri.parse(Endpoints.vouchers));
        if(response.statusCode == 200){
            final List<dynamic> jsonResponse = jsonDecode(response.body);
            return jsonResponse.map((item) => Voucher.fromJson(item)).toList();
        } else {
          throw Exception('Failed to load vouchers');
        }
    }

    static Future<bool> deleteVoucher(int id) async{
        final response = await http.delete(Uri.parse('${Endpoints.vouchers}/$id'));
        if(response.statusCode == 200){
            return true;
        }
        return false;
    }

    static Future<void> createVoucher(Voucher voucher) async {
    final response = await http.post(
      Uri.parse(Endpoints.vouchers),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(voucher.toJson()),
    );
    if (response.statusCode == 201) {
      // Berhasil menyimpan voucher
      return;
    } else if (response.statusCode == 422) {
      print(response.body);
    } else {
      // Gagal menyimpan voucher, lemparkan exception
      throw Exception('Gagal menyimpan voucher: ${response.statusCode}');
    }
  }

  static Future<void> updateVoucher(Voucher voucher) async {
  final response = await http.put(
    Uri.parse('${Endpoints.vouchers}/${voucher.id}'), // URL untuk memperbarui voucher dengan ID tertentu
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(voucher.toJson()), // Konversi objek voucher menjadi JSON
  );
  if (response.statusCode == 200) {
    // Berhasil memperbarui voucher
    return;
  } else {
    // Gagal memperbarui voucher, lemparkan exception
    throw Exception('Gagal memperbarui voucher: ${response.statusCode}');
  }
}

}