import 'package:flutter/material.dart';
import 'package:metrical/auth/supabase_auth.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> filterIngredients = [];
  final search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIngredients();
    search.addListener(filteringIngredients);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: search,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Search Ingredients',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: filterIngredients.isEmpty
                ? Center(
                    child: Text('No Ingredients found'),
                  )
                : ListView.builder(
                    itemCount: filterIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = filterIngredients[index];

                      return ListTile(
                        title: Text(ingredient['name']),
                        trailing: Text('${ingredient['calories']} kcal'),
                      );
                    },
                  ))
      ],
    );
  }

  Future<void> fetchIngredients() async {
    final res = await SupabaseAuth.client
        .from('Ingredients')
        .select()
        .order('name', ascending: true);

    if (!mounted) return;
    setState(() {
      ingredients = List<Map<String, dynamic>>.from(res);
      filterIngredients = ingredients;
    });
  }

  void filteringIngredients() {
    final query = search.text.toLowerCase();
    setState(() {
      filterIngredients = ingredients.where((ing) {
        final name = ing['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }
}
