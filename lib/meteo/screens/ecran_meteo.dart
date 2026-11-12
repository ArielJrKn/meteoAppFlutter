//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/boucing.dart';
import '../models/meteo.dart';
import '../services/meteo_service.dart';

class EcranMeteo extends StatefulWidget {
  @override
  State<EcranMeteo> createState() => _EcranMeteo();
}

class _EcranMeteo extends State<EcranMeteo> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  late Future<Meteo> _meteoFuture;
  @override
  void initState(){
    super.initState();
    _meteoFuture = recupererMeteoParVille('paris');
  }
  void _rechercher() {
    final nom = _textEditingController.text.trim();
    if (nom.isEmpty) return;
    setState(() {
      _meteoFuture = recupererMeteoParVille(nom); // ← nouveau future
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.wb_sunny, color: Colors.orange,),
        title: Text("Météo"),
        actions: [
          TextButton.icon(
            onPressed: (){
              recupererMeteoParVille(_textEditingController.text);
            },
            icon: Icon(Icons.refresh),
            label: Text("Rafraîchir"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black
            ),
          )
        ],
      ),  
      body: Container(
        //color: Colors.blueAccent,
        child: Column(
          children: [
            Row(
              children: [
                // 🔹 Élément 1 : champ (prend tout l'espace)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          labelText: "Entrez une ville (ex:Cotonou, Paris)",

                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Champ obligatoire";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // 🔹 Élément 2 : bouton à droite
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _rechercher,
                        child: const Text("OK"),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),
                      ),
                    )
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(width: 5,),
                  Text(_textEditingController.text)
                ],
              ),
            ),
            FutureBuilder<Meteo>(
              future: _meteoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur : ${snapshot.stackTrace}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Aucun utilisateur trouvé'),
                  );
                }
                final meteo = snapshot.data!;
                final info = Meteo.decoderMeteo(meteo.code);
                return Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          BouncingWidget(
                            child: Text(info['emoji'] ?? '🌡️', style: TextStyle(fontSize: 100)),
                          ),
                          //Text('🌤️', style: TextStyle(fontSize: 100),),
                          Text(meteo.temperature.toString(), style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
                          Text(info['desc']!),

                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    GridView.count(
                      padding: EdgeInsets.all(10),
                      crossAxisCount: 2,          // 2 colonnes
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2,        // ajuste la hauteur des cartes
                      shrinkWrap: true,           // pour l'utiliser dans un Column/scroll
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DataCard(context, value: meteo.windspeed.toString(), lib: 'VENT', icon:'️️☁️'),
                        DataCard(context, value: meteo.temperature.toString(), lib: 'RESSENTI', icon:'️️🌡️'),
                        DataCard(context, value: meteo.winddirection.toString(), lib: 'DIRECTION', icon:'️️🌡️'),
                        DataCard(context, value: meteo.time, lib: 'HEURE', icon:'️️☁️'),
                      ],
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: .center,
              children: [
                Text('Données :', style: TextStyle( color: Colors.black),),
                Text(' Open-Meteo', style: TextStyle( color: Colors.black),),
                Text(' - Gratuit et sans clé', style: TextStyle( color: Colors.black),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget DataCard(
    BuildContext context, {
      required String icon,
      required String lib,
      required String value,
    }) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
    ),
    child: Row(

      mainAxisAlignment: .center,
      children: [
        Text(icon, style: TextStyle(fontSize: 50),),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            Text(lib, style: TextStyle(fontSize: 10, color: Colors.black),),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: .w900, color: Colors.black),)
          ],
        )
      ],
    ),
  );
}