import 'package:flutter/material.dart';
import 'package:tip_calculator/utils/hexcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;
  final Color _deepPurple = HexColor("#6908D6"); //#FF9C27B0 purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          alignment: Alignment.center,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.5),
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: _deepPurple.withOpacity(0.1),
                  //Colors.purpleAccent.shade100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Per Person",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                          color: _deepPurple,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "৳ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",
                          style: TextStyle(
                            fontSize: 34.9,
                            fontWeight: FontWeight.bold,
                            color: _deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.blueGrey.shade100,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: _deepPurple),
                      decoration: InputDecoration(
                        prefixText: "Bill Amount: ",
                        //prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (String value) {
                        try {
                          _billAmount = double.parse(value);
                        } catch (exception) {
                          _billAmount = 0.0;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Split",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    if (_personCounter > 1) {
                                      _personCounter--;
                                    } else {
                                      //do nothing;
                                    }
                                  },
                                );
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: _deepPurple.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                      color: _deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "$_personCounter",
                              style: TextStyle(
                                color: _deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    _personCounter++;
                                  },
                                );
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: _deepPurple.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                      color: _deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //Tip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tip",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "৳ ${(calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: _deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //slider
                    Column(
                      children: [
                        Text(
                          "$_tipPercentage%",
                          style: TextStyle(
                            color: _deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                        Slider(
                            min: 0,
                            max: 100,
                            activeColor: _deepPurple,
                            divisions: 10,
                            inactiveColor: Colors.grey,
                            value: _tipPercentage.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                _tipPercentage = value.round();
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  calculateTotalPerPerson(double billAmount, int splitBy, int tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
            splitBy;
    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
    double totalTip = 0.0;
    if (billAmount < 0 || billAmount.toString().isEmpty || billAmount == null) {
      // no go !
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }
}
