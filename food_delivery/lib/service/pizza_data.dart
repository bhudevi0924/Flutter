import 'package:food_delivery/model/pizza_model.dart';

List<PizzaModel> getPizza() {
  List<PizzaModel> pizza=[];
  PizzaModel pizzaModel = new PizzaModel();

  pizzaModel.name= "pizza1";
  pizzaModel.image="images/pizza.png";
  pizzaModel.price="50";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name= "pizza2";
  pizzaModel.image="images/pizza.png";
  pizzaModel.price="150";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name= "pizza1";
  pizzaModel.image="images/pizza.png";
  pizzaModel.price="50";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name= "pizza2";
  pizzaModel.image="images/pizza.png";
  pizzaModel.price="150";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  return pizza;
}