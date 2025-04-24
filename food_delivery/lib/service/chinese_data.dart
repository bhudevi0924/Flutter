import 'package:food_delivery/model/chinese_model.dart';

List<ChineseModel> getChinese() {
  List<ChineseModel> chinese=[];
  ChineseModel chineseModel = new ChineseModel();

  chineseModel.name= "chinese1";
  chineseModel.image="images/noodles.png";
  chineseModel.price="50";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  chineseModel.name= "chinese2";
  chineseModel.image="images/noodles.png";
  chineseModel.price="150";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  chineseModel.name= "chinese1";
  chineseModel.image="images/noodles.png";
  chineseModel.price="50";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  chineseModel.name= "chinese2";
  chineseModel.image="images/noodles.png";
  chineseModel.price="150";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  return chinese;
}