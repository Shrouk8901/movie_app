class CategoryModel {
  String name;
  String apiValue;

  CategoryModel({required this.name, required this.apiValue});

  static List<CategoryModel> categories = [
    CategoryModel(name: 'Action', apiValue: 'action'),
    CategoryModel(name: 'Adventure', apiValue: 'adventure'),
    CategoryModel(name: 'Animation', apiValue: 'animation'),
    CategoryModel(name: 'Horror', apiValue: 'horror'),
    CategoryModel(name: 'Comedy', apiValue: 'comedy'),
  ];
}
