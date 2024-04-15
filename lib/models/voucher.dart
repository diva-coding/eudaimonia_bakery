class Voucher{
    late int id;
    late String title;
    late String description;
    late String activeDate;
    late String expirationDate;
    late int discountValue;
    late int quota;

    Voucher({required this.id, required this.title, required this.description, required this.activeDate, required this.expirationDate, required this.discountValue, required this.quota}){
        this.id = id;
        this.title = title;
        this.description = description;
        this.activeDate = activeDate;
        this.expirationDate = expirationDate;
        this.discountValue = discountValue;
        this.quota = quota;
    }

    Voucher.fromJson(Map json)
    : id = json['id'],
      title = json['title'],
      description = json['description'],
      activeDate = json['active_date'],
      expirationDate = json['expiration_date'],
      discountValue = json['discount_value'],
      quota = json['quota'];

    Map toJson(){
        return {
            'id' : id,
            'title' : title,
            'description' : description,
            'active_date' : activeDate,
            'expiration_date' : expirationDate,
            'discount_value' : discountValue,
            'quota' : quota,
        };
    }
}

