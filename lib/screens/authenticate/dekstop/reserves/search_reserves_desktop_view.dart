import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchReservesDesktopView extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> filteredReservesNotifier;
  final ValueListenable<List<Map<String, dynamic>>> dates;
  final ValueNotifier<bool> isFocused;


  const SearchReservesDesktopView({Key? key, required this.filteredReservesNotifier, required this.dates, required this.isFocused,})
      : super(key: key);

  @override
  State<SearchReservesDesktopView> createState() => SearchReservesDesktopViewState();
}

class SearchReservesDesktopViewState extends State<SearchReservesDesktopView> {
  final TextEditingController _searchcontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchcontroller.addListener(_onSearchChanged);
    _focusNode.addListener(() async {
      if (!_focusNode.hasFocus) {
        // Espera 100 milisegundos antes de cambiar el valor de isFocused a false.
        await Future.delayed(const Duration(milliseconds: 200));
        widget.isFocused.value = false;
      } else {
        widget.isFocused.value = true;
      }
    });
  }

  void _onSearchChanged() {
    var filteredReserves =
    List<Map<String, dynamic>>.from(widget.dates.value);
      filteredReserves.sort((a, b) {
        try {
          final timestampA = a['created_at'].replaceAll('\u202F', ' ');
          final dateTimeA = DateFormat('MMM d, yyyy h:mm a').parse(timestampA);
          final timestampB = b['created_at'].replaceAll('\u202F', ' ');
          final dateTimeB = DateFormat('MMM d, yyyy h:mm a').parse(timestampB);
          return dateTimeB.compareTo(dateTimeA);
        } catch (e) {
          if (kDebugMode) {
            print('Error al analizar las fechas: $e');
          }
          return 0;
        }
      });

      if (_searchcontroller.text.isNotEmpty) {
        filteredReserves = filteredReserves.take(5).toList();
      }

      if (_searchcontroller.text.isNotEmpty) {
        filteredReserves.retainWhere((reserve) => reserve['name']
            .toLowerCase()
            .startsWith(_searchcontroller.text.toLowerCase()));
      }
    setState(() {
      widget.filteredReservesNotifier.value = filteredReserves;
    });
  }


  @override
  void dispose() {
    _searchcontroller.removeListener(_onSearchChanged);
    _searchcontroller.dispose();
    _focusNode.addListener(() {
      widget.isFocused.value = _focusNode.hasFocus;
    });
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 50,
      width: 500,
      child: TextFormField(
        focusNode: _focusNode,
        controller: _searchcontroller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 25, top: 5, bottom: 5, right: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          labelText: 'Buscar',
          labelStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).hintColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Theme.of(context).hintColor,)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Theme.of(context).primaryColor,),
          ),
        ),
        style: const TextStyle(
          fontSize: 20,

        ),
        minLines: 1,
        cursorColor: Theme.of(context).primaryColor,
      ),
    );

  }
}

