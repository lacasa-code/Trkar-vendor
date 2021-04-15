import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/carmodel.dart';
import 'package:trkar_vendor/model/part__category.dart';
import 'package:trkar_vendor/model/year.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class Add_Product extends StatefulWidget {
  @override
  _Add_ProductState createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
  bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Carmodel> carmodels;
  List<CarMade> CarMades;
  List<Year> years;

  List<Part_Category> part_Categories;
  List<Carmodel> filteredcarmodels_data = List();
  List<CarMade> filteredCarMades_data = List();
  TextEditingController serialcontroler, namecontroler, description;
  TextEditingController car_made_id_controler, car_model_id_Controler, part_category_id_controller,
      year_idcontroler, store_id, price_controller,discountcontroler, quantityController;
  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  String base64Image;
  final search = Search(milliseconds: 1000);

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        base64Image = base64Encode(_image.readAsBytesSync());
        print(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  void initState() {
    getAllCareMade();
    getAllCareModel();

    serialcontroler = TextEditingController();
    namecontroler = TextEditingController();
    car_made_id_controler = TextEditingController();
    car_model_id_Controler = TextEditingController();
    part_category_id_controller = TextEditingController();
    description = TextEditingController();
    store_id = TextEditingController();
    price_controller = TextEditingController();
    discountcontroler = TextEditingController();
    year_idcontroler = TextEditingController();
    serialcontroler = TextEditingController();
    namecontroler = TextEditingController();
    car_made_id_controler = TextEditingController();
    car_model_id_Controler = TextEditingController();
    quantityController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
        backgroundColor: themeColor.getColor(),
      ),
      body: Stack(
        children: [
          Container(
            width: ScreenUtil.getWidth(context),
            height: ScreenUtil.getHeight(context),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: namecontroler,
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'name');
                          } else if (value.length < 10) {
                            return getTransrlate(context, 'name') + ' < 10';
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Serial number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: serialcontroler,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return getTransrlate(context, 'counter');
                                } else if (value.length < 2) {
                                  return getTransrlate(context, 'counter');
                                }
                                _formKey.currentState.save();

                                return null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return getTransrlate(context, 'counter');
                                } else if (value.length < 2) {
                                  return getTransrlate(context, 'counter');
                                }
                                _formKey.currentState.save();

                                return null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Price",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: price_controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Discount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: discountcontroler,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<CarMade>(
                            items: CarMades,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredCarMades_data = CarMades
                            //           .where((u) =>
                            //       (u.carMade
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredCarMades_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Car Made',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.carMade,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Car Made",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Carmodel>(
                            items: carmodels,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Car Model',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.carmodel,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {

                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Car Model",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(6.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Part_Category>(
                            items: part_Categories,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Part Category',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.categoryName,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {

                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Year",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Year>(
                            items: years,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Year',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.year,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {

                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Year",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Carmodel>(
                            items: carmodels,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Categories',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.carmodel,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {

                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Categories",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Carmodel>(
                            items: carmodels,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(),
                                        width: 2),),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        'Stores',
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.carmodel,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {

                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Stores",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: description,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),

                    InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: _image == null
                            ? Container(
                          color: Color(0xfff3f3f4),
                            height: ScreenUtil.getHeight(context) / 5,
                            width: ScreenUtil.getWidth(context),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ))
                            : Image.file(
                          _image,
                          height: ScreenUtil.getHeight(context) / 5,
                          width: ScreenUtil.getWidth(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        getImage();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                     child: FlatButton(
                              color: themeColor.getColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() => loading = true);
                                  API(context).post("add/products", {
                                    "name": namecontroler.text,
                                  "categories":[1,2],
                                  "car_made_id":car_made_id_controler.text,
                                  "car_model_id":car_model_id_Controler.text,
                                  "year_id":year_idcontroler.text,
                                  "part_category_id":part_category_id_controller.text,
                                  "discount":discountcontroler.text,
                                  "price":price_controller.text,
                                  "description":discountcontroler.text,
                                  "store_id":store_id.text,
                                  "quantity":quantityController.text,
                                  "serial_number":serialcontroler.text,
                                  "tags":'',
                                  }).then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                   // Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                       value['message'],
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                   ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getAllCareMade() async {
    API(context).get('car-mades').then((value) {
      if (value != null) {
        setState(() {
          CarMades = CarsMade.fromJson(value).data;
        });
      }
    });
  }
  Future<void> getAllCareModel() async {
    API(context).get('car-models').then((value) {
      if (value != null) {
        setState(() {
          if (value["data"] != null) {
            carmodels = [];
            value["data"].forEach((v) {
              carmodels.add(Carmodel.fromJson(v));
            });
          } });
      }
      getAllParts_Category();
    });
  }  Future<void> getAllParts_Category() async {
    API(context).get('part-categories').then((value) {
      if (value != null) {
        setState(() {
          part_Categories = Parts_Category.fromJson(value).data;
        });
        getAllYear();
      }
    });
  }  Future<void> getAllYear() async {
    API(context).get('car-yearslist').then((value) {
      if (value != null) {
        setState(() {
          years = Years.fromJson(value).data;
        });
      }
    });
  }
}