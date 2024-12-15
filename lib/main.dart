import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Finder',
      theme: ThemeData(primarySwatch: Colors.red),
      home: PokemonSearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokemonSearchScreen extends StatefulWidget {
  const PokemonSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonSearchScreenState createState() => _PokemonSearchScreenState();
}

class _PokemonSearchScreenState extends State<PokemonSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? pokemonData;
  bool isLoading = false;

  Future<void> fetchPokemon(String name) async {
    setState(() {
      isLoading = true;
      pokemonData = null;
    });

    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
      if (response.statusCode == 200) {
        setState(() {
          pokemonData = json.decode(response.body);
        });
      } else {
        setState(() {
          pokemonData = null;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        pokemonData = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre del Pokémon',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ejemplo: pikachu',
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) fetchPokemon(value.toLowerCase());
              },
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : pokemonData != null
                    ? PokemonCard(data: pokemonData!)
                    : Center(child: Text('No se encontró el Pokémon')),
          ],
        ),
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const PokemonCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'].toString().toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.network(
              data['sprites']['front_default'],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text('Peso: ${data['weight']}'),
            Text('Altura: ${data['height']}'),
          ],
        ),
      ),
    );
  }
}
