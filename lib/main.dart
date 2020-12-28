import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo.dart';
void main(){
  runApp(
    Home()
  );
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {


  TextEditingController thismonth = new TextEditingController();
  TextEditingController lastsmonth = new TextEditingController();
  TextEditingController moneykwh = new TextEditingController();
  TextEditingController zero = new TextEditingController();

  var nzero = 0;
  String nthismonth = '';
  String nlastmonth = '';
  String nmoneykwh = '';
  var total = '';

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<String> _items = [  ];
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async{
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Sinh hoạt phí'),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image(
                    image: AssetImage('assets/hinh1.jpg'),
                  ),
                ),
                Text('Tính toán hóa đơn tiền điện hàng tháng.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'Vietnam',
                  fontWeight: FontWeight.bold,
                )),
                SizedBox(height: 10.0),
                Text('Nhập số đầu, số cuối và số tiền/Kwh để tính tiền điện.',
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vietnam',
                ),),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: ('Số điện tiêu thụ tháng này(Kwh)'), labelStyle: TextStyle(color: Colors.white,fontSize: 20.0,),),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  controller: thismonth,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: ('Số điện tiêu thụ tháng trước(Kwh)'), labelStyle: TextStyle(color: Colors.white,fontSize: 20.0,),),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  controller: lastsmonth,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: ('Giá điện VND/Kwh'), labelStyle: TextStyle(color: Colors.white,fontSize: 20.0,),),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  controller: moneykwh,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Colors.amberAccent[200],
                      textColor: Colors.black,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(6.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        setState(() {
                          nthismonth = thismonth.text;
                          nlastmonth = lastsmonth.text;
                          nmoneykwh = moneykwh.text;
                          total = (((double.parse(nthismonth).toInt())-(double.parse(nlastmonth).toInt()))*(double.parse(nmoneykwh).toInt())).toString();
                        });
                      },
                      child: Text(
                        "Tính tiền",
                        style: TextStyle(fontSize: 20.0,fontFamily: 'Vietnam'),
                      ),
                    ),
                    FlatButton(
                      color: Colors.amberAccent[200],
                      textColor: Colors.black,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(6.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        setState(() {
                          total = nzero.toString();
                        });
                      },
                      child: Text(
                        "Xóa",
                        style: TextStyle(fontSize: 20.0,fontFamily: 'Vietnam'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                            ListTile(
                          leading: Icon(Icons.electrical_services_rounded),
                          title: Text('Số tiền tháng' '\n' '(+VAT 10%)',style: TextStyle(fontSize: 18.0,fontFamily: 'Vietnam'),),
                          subtitle: Text(total + ' VND',style: TextStyle(fontSize: 16.0,fontFamily: 'Vietnam')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Lưu', style: TextStyle(fontSize: 20.0,fontFamily: 'Vietnam'),),
                              onPressed: ()=>_addItem(),

                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Text('Lịch sử', style: TextStyle(fontSize: 20.0,fontFamily: 'Vietnam',color: Colors.white),),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                        child:AnimatedList(
                            shrinkWrap: true,
                            key: _key,
                            initialItemCount: _items.length,
                            itemBuilder:(context,index,animation){
                              return _buildItem(_items[index],animation,index);
                            }),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ) ;
  }
  Widget _buildItem(String item, Animation animation, int index)
  {
    return SizeTransition(
        sizeFactor: animation,
        child: Card(
          elevation: 2,
          child: ListTile(
            title: Text(
              item,
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Text(''),
            leading: Icon(Icons.attach_money),
            trailing: IconButton(
              icon: Icon(Icons.close,color:Colors.red,),
              onPressed: (){
                _removeItem(index);
              },
            ),
          ),
        ),
    );
  }
  void _removeItem(int i)
  {
    String removedItem = _items.removeAt(i);
    AnimatedListRemovedItemBuilder builder = (context,animation)
    {
      return _buildItem(removedItem, animation, i);
    };
    _key.currentState.removeItem(i, builder);
    saveData();
  }
  void _addItem()
  {
    String a = total;
    int i = _items.length>0 ? _items.length :0;
    _items.insert(i, 'Tháng ${_items.length+1}'+'\n' '${a} VND');
    _key.currentState.insertItem(i);
    saveData();
  }
  void saveData()
  {
    List<String> spList = _items.map((item) => json.encode(item.toString())).toList();
    sharedPreferences.setStringList(('_items'), spList);
    print(spList);
  }
  void loadData()
  {
    print(sharedPreferences.getStringList('_items'));
    List<String> spList = sharedPreferences.getStringList('_items');
    _items = spList.map((item) => json.decode(item.toString())).cast<String>().toList();
    setState(() {
    });
    print(spList);
  }
}


