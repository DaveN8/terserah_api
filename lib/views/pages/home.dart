part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Costs> dataCost = [];
  bool isLoading = false;
  bool ongkirReady = false;
  dynamic provinceData;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic cityIdOrigin;
  dynamic cityIdDestination;
  dynamic selectedCityOrigin;
  dynamic selectedProvinceOrigin;
  dynamic selectedCityDestination;
  dynamic selectedProvinceDestination;
  // dynamic dropDownValue; //For Courier
  dynamic provinsiAwal;
  dynamic provinsiAkhir;
  dynamic kotaAwal;
  dynamic kotaAkhir;
  dynamic berat;
  dynamic kurir;
  dynamic ongkirLength;
  dynamic dapatOngkir;

  TextEditingController beratbjir = TextEditingController();

  Future<dynamic> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        prov = value;
        isLoading = false;
      });
    });
    return prov;
  }

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        // cityDataOrigin = value;
        city = value;
      });
    });
    return city;
  }

  Future<List<Costs>> getCostes(
      var originId, var detinationId, var weight, var courier) async {
    List<Costs> costs = [];
    await MasterDataService.getCosts(
      originId,
      detinationId,
      weight,
      courier,
    ).then((value) {
      setState(() {
        // cityDataOrigin = value;
        costs = value;
        ongkirLength = costs.length;
      });
    });
    return costs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });

    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 240,
                      //   child: FutureBuilder<List<City>>(
                      //     future: cityDataOrigin,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         // return DropdownButtonFormField(
                      //         //   decoration: InputDecoration(
                      //         //     labelText: "City",
                      //         //     border: OutlineInputBorder(
                      //         //       borderRadius: BorderRadius.circular(10)
                      //         //     )
                      //         //   ),
                      //         //   items: snapshot.data.map((e) => DropdownMenuItem(
                      //         //     child: Text(e.cityName),
                      //         //     value: e.cityId,
                      //         //   )).toList(),
                      //         //   onChanged: (value){
                      //         //     setState(() {
                      //         //       cityIdOrigin = value;
                      //         //     });
                      //         //   },
                      //         // );
                      //         return DropdownButton(
                      //           isExpanded: true,
                      //           value: selectedCityOrigin,
                      //           icon: Icon(Icons.arrow_drop_down),
                      //           iconSize: 30,
                      //           elevation: 4,
                      //           style: TextStyle(color: Colors.black),
                      //           hint: selectedCityOrigin == null ? Text("Pilih Kota")
                      //
                      //               : Text(selectedCityOrigin.cityName),
                      //           items: snapshot.data!
                      //               .map<DropdownMenuItem<City>>((City Value) {
                      //             return DropdownMenuItem<City>(
                      //               value: Value,
                      //               child: Text(Value.cityName.toString()),
                      //             );
                      //           }).toList(),
                      //           onChanged: (newValue) {
                      //             setState(() {
                      //               selectedCityOrigin = newValue;
                      //               cityDataOrigin = selectedCityOrigin.cityId;
                      //             });
                      //           },
                      //         );
                      //       } else if (snapshot.hasError) {
                      //         // return Text(snapshot.error.toString());
                      //         return Text("Tidak ada Data");
                      //       }
                      //       return UiLoading.loadingSmall();
                      //     },
                      //   ),
                      // ),

                      // Row Pilih Kurir
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton<String>(
                                value: kurir,
                                hint: kurir == null
                                    ? const Text("Pilih Kurir")
                                    : Text(kurir),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    kurir = newValue!;
                                  });
                                },
                                items: <String>[
                                  'JNE',
                                  'POS',
                                  'TIKI',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value.toLowerCase(),
                                    child: Text(value),
                                  );
                                }).toList(),
                                isExpanded: true,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Enter weight',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your weight';
                                  }
                                  return value;
                                },
                                controller: beratbjir,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.all(20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "Origin",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Row Pilih Asal
                      Row(
                        children: [
                          //Row Provinsi Asal
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              width: 100,
                              child: FutureBuilder<dynamic>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceOrigin,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedProvinceOrigin == null
                                          ? Text("Pilih Provinsi")
                                          : Text(
                                              selectedProvinceOrigin.province),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.province.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedProvinceOrigin = newValue;
                                          cityDataOrigin = getCities(
                                              selectedProvinceOrigin.provinceId
                                                  .toString());
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    // return Text(snapshot.error.toString());
                                    return Text("Tidak ada Data");
                                  }
                                  return UiLoading.loadingSmall();
                                },
                              ),
                            ),
                          ),

                          const Spacer(flex: 1),
                          // const SizedBox(height: 2, width: 2,),

                          //Row Kota Asal
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityOrigin,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedCityOrigin == null
                                          ? Text("Pilih Kota")
                                          : Text(selectedCityOrigin.cityName),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<City>>(
                                              (City value) {
                                        return DropdownMenuItem<City>(
                                          value: value,
                                          child:
                                              Text(value.cityName.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCityOrigin = newValue;
                                          cityIdOrigin =
                                              selectedCityOrigin.cityId;
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    // return Text(snapshot.error.toString());
                                    return Text("Tidak ada Data");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return DropdownButton(
                                      items: null,
                                      onChanged: null,
                                      disabledHint: Text("Loading"),
                                    );
                                  }
                                  return DropdownButton(
                                    items: null,
                                    onChanged: null,
                                    disabledHint: Text("Pilih Provinsi Dahulu"),
                                    isExpanded: true,
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.all(20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "Destination",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Row Pilih Tujuan
                      Row(
                        children: [
                          //Row Provinsi Tujuan
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              width: 100,
                              child: FutureBuilder<dynamic>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceDestination,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedProvinceDestination == null
                                          ? Text("Pilih Provinsi")
                                          : Text(selectedProvinceDestination
                                              .province),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.province.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedProvinceDestination =
                                              newValue;
                                          cityDataDestination = getCities(
                                              selectedProvinceDestination
                                                  .provinceId
                                                  .toString());
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    // return Text(snapshot.error.toString());
                                    return Text("Tidak ada Data");
                                  }
                                  return UiLoading.loadingSmall();
                                },
                              ),
                            ),
                          ),

                          const Spacer(flex: 1),

                          //Row Kota Tujuan
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityDestination,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedCityDestination == null
                                          ? Text("Pilih Kota")
                                          : Text(
                                              selectedCityDestination.cityName),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<City>>(
                                              (City value) {
                                        return DropdownMenuItem<City>(
                                          value: value,
                                          child:
                                              Text(value.cityName.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCityDestination = newValue;
                                          cityIdDestination =
                                              selectedCityOrigin.cityId;
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    // return Text(snapshot.error.toString());
                                    return Text("Tidak ada Data");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return DropdownButton(
                                      items: null,
                                      onChanged: null,
                                      disabledHint: Text("Loading"),
                                    );
                                  }
                                  return DropdownButton(
                                    items: null,
                                    onChanged: null,
                                    disabledHint: Text("Pilih Provinsi Dahulu"),
                                    isExpanded: true,
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                dapatOngkir = await getCostes(
                                  cityIdOrigin,
                                  cityIdDestination,
                                  beratbjir.text,
                                  kurir,
                                );
                                setState(() {
                                  ongkirReady = true;
                                  isLoading = false;
                                });
                              },
                              child: const Text(
                                "Cek Ongkir",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: !ongkirReady
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Data Kosong"),
                          )
                        : ListView.builder(
                            itemCount: ongkirLength,
                            itemBuilder: (context, index) {
                              return CardCosts(dapatOngkir[index]);
                            },
                          ),
                  )),
              // Flexible(
              //   flex: 5,
              //   child: Container(
              //     width: double.infinity,
              //     height: double.infinity,
              //     child: provinceData.isEmpty
              //         ? const Align(
              //             alignment: Alignment.center,
              //             child: Text("Data Kosong"),
              //           )
              //         : ListView.builder(
              //             itemCount: provinceData.length,
              //             itemBuilder: (context, index) {
              //               return CardProvince(provinceData[index]);
              //             },
              //           ),
              //   ),
              // ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
