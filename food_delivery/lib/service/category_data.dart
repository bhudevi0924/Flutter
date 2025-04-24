import 'package:food_delivery/model/category_model.dart';

List<CategoryModel> getCategoryModel(){
  
  List<CategoryModel> category=[];
  CategoryModel categoryModel= new CategoryModel();

  categoryModel.name="Pizza";
  categoryModel.image="images/pizza.png";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.name="Burger";
  categoryModel.image="images/burger.png";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.name="Chinese";
  categoryModel.image="images/burger.png";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  return category;
}