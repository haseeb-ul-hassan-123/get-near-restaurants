class ProductsModel {
  final String pId;
  final String rId;
  final String pCategory;
  final String pSubCategory;
  final String pName;
  final String pNotes;
  final String pPrice;
  final String pImages;
  final List<dynamic> pLikes;
  final int status;

  ProductsModel({
    required this.pId,
    required this.rId,
    required this.pCategory,
    required this.pSubCategory,
    required this.pName,
    required this.pNotes,
    required this.pPrice,
    required this.pImages,
    required this.pLikes,
    required this.status,
  });

  factory ProductsModel.fromJson(json) {
    return ProductsModel(
      pId: json['pId'],
      rId: json['rId'],
      pCategory: json['pCategory'],
      pSubCategory: json['pSubCategory'],
      pName: json['pName'],
      pNotes: json['pNotes'],
      pPrice: json['pPrice'],
      pImages: json['pImages'],
      pLikes: json['pLikes'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pId': pId,
      'rId': rId,
      'pCategory': pCategory,
      'pSubCategory': pSubCategory,
      'pName': pName,
      'pNotes': pNotes,
      'pPrice': pPrice,
      'pImages': pImages,
      'pLikes': pLikes,
      'status': status,
    };
  }
}
