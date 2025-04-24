import 'package:food_delivery/model/burger_model.dart';

List<BurgerModel> getBurger() {
  List<BurgerModel> burger=[];
  BurgerModel burgerModel = new BurgerModel();

  burgerModel.name= "burger1";
  burgerModel.image="images/burger.png";
  burgerModel.price="50";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name= "burger2";
  burgerModel.image="images/burger.png";
  burgerModel.price="150";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name= "burger1";
  burgerModel.image="images/burger.png";
  burgerModel.price="50";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name= "burger2";
  burgerModel.image="images/burger.png";
  burgerModel.price="150";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  return burger;
}