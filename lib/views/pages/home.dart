part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];
  bool isLoading = false;

  Future<dynamic> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        isLoading = false;
        prov = value;
      });
    });
    return prov;
  }

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
    cityDataOrigin = getCities("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Origin"),
                      Text("Silahkan Pilih Kota"),
                      Container(
                        width: 240,
                        child: FutureBuilder<List<City>>(
                          future: cityDataOrigin,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // return DropdownButtonFormField(
                              //   decoration: InputDecoration(
                              //     labelText: "City",
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10)
                              //     )
                              //   ),
                              //   items: snapshot.data.map((e) => DropdownMenuItem(
                              //     child: Text(e.cityName),
                              //     value: e.cityId,
                              //   )).toList(),
                              //   onChanged: (value){
                              //     setState(() {
                              //       cityIdOrigin = value;
                              //     });
                              //   },
                              // );
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
                                items: snapshot.data!.map<DropdownMenuItem<City>>((City Value){
                                  return DropdownMenuItem<City>(
                                    value: Value,
                                    child: Text(Value.cityName.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue){
                                  setState(() {
                                    selectedCityOrigin = newValue;
                                    cityDataOrigin = selectedCityOrigin.cityId;
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
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: provinceData.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("Data Kosong"),
                        )
                      : ListView.builder(
                          itemCount: provinceData.length,
                          itemBuilder: (context, index) {
                            return CardProvince(provinceData[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
