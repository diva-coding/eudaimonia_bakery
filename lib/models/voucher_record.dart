class VoucherRecord{
    final int id;
    final String title;
    final String description;
    final DateTime activeDate;
    final DateTime expirationDate;
    final int discountValue;
    final int quota;

    const VoucherRecord({
        required this.id, 
        required this.title, 
        required this.description,
        required this.activeDate,
        required this.expirationDate,
        required this.discountValue,
        required this.quota
    });

    factory VoucherRecord.fromJson(Map<String, dynamic> json){
      return VoucherRecord(
        id : json['id'],
        title : json['title'],
        description : json['description'],
        activeDate : json['active_date'],
        expirationDate : json['expiration_date'],
        discountValue : json['discount_value'],
        quota : json['quota']
      );
    }
}