import 'package:flutter/material.dart';
import 'package:food_delivery/model/burger_model.dart';
import 'package:food_delivery/model/category_model.dart';
import 'package:food_delivery/model/chinese_model.dart';
import 'package:food_delivery/model/pizza_model.dart';
import 'package:food_delivery/pages/detail_page.dart';
import 'package:food_delivery/service/burger_data.dart';
import 'package:food_delivery/service/category_data.dart';
import 'package:food_delivery/service/chinese_data.dart';
import 'package:food_delivery/service/pizza_data.dart';
import 'package:food_delivery/service/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories= [];
  String track="0";
  List<PizzaModel> pizza=[];
  List<BurgerModel> burger=[];
  List<ChineseModel> chinese=[];

  @override
  void initState() {
    categories= getCategoryModel();
    pizza = getPizza();
    burger=getBurger();
    chinese=getChinese();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left:20),
        child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/logo.png", height:80,width: 80,fit: BoxFit.contain,),
              Text("Order your favourite food!", style: AppWidget.simpleTextStyles(),)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("images/girl.png", height:60,width: 60,fit: BoxFit.contain,)),
          ),

        ],),
        SizedBox(height: 30.0,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                margin: EdgeInsets.only(right: 30.0),
                decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(decoration: InputDecoration(border: InputBorder.none,hintText: "Search food item..."),),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: AppWidget.primaryColor,borderRadius: BorderRadius.circular(10.0)),
              child: Icon(Icons.search,size: 30.0,),
            )
          ],
        ),
        SizedBox(height: 20.0,),
        Container(
          alignment: Alignment.topLeft,
          height: 70,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryTile(
                categories[index].name!,
                categories[index].image!, 
                index.toString());
            },
          ),
        ),
        track=="0"? Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            height: MediaQuery.of(context).size.height/2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // max width per item
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.6, ),
                  itemCount: pizza.length, 
              itemBuilder: (context,index){
                return FoodTile(pizza[index].name!, pizza[index].image!, pizza[index].price!);
              }),
          ),
        ):
        track=="1" ? Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            height: MediaQuery.of(context).size.height/2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.6,),
                  itemCount: burger.length, 
              itemBuilder: (context,index){
                return FoodTile(burger[index].name!, burger[index].image!, burger[index].price!);
              }),
          ),
        ):
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            height: MediaQuery.of(context).size.height/2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                   maxCrossAxisExtent: 200, // max width per item
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.6,),
                  itemCount: chinese.length, 
              itemBuilder: (context,index){
                return FoodTile(chinese[index].name!, chinese[index].image!, chinese[index].price!);
              }),
          ),
        )
      ],),),
    );
  }
  
  Widget CategoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track=categoryindex.toString();
        setState(() {
          
        });
      },
      child: track==categoryindex? 
      Container(
        margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: EdgeInsets.only(right: 20.0, left: 20.0),
            decoration: BoxDecoration(color: AppWidget.primaryColor, borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              children: [
                Image.asset(image, height: 50, width: 50, fit: BoxFit.cover,),
                SizedBox(width: 10.0,),
                Text(name, style: AppWidget.whiteTextFieldStyles(),)
              ],
            ),
          ),
        ),
      ):
      Container(
        padding: EdgeInsets.only(right: 20.0, left: 20.0),
        margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          children: [
            Image.asset(image, height: 50, width: 50, fit: BoxFit.cover,),
            SizedBox(width: 10.0,),
            Text(name, style: AppWidget.simpleTextStyles(),)
          ],
        ),
      ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset(image, height: 100, width: 100, fit: BoxFit.contain)),
          SizedBox(height: 8),
          Text(name, style: AppWidget.boldTextFieldStyles()),
          Text("RS $price", style: AppWidget.priceTextFieldStyles()),
          Spacer(), // pushes the button down
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(image: image, name: name, price: price))),
              child: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  color: AppWidget.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(15.0),
                  )
                ),
                child: Icon(Icons.arrow_forward),
              ),
            ),
          )
        ],
      ),
    );
  }

}