import 'dart:convert';
import 'package:web_socket_channel/html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const ipPort = '//192.168.1.105:3263';

class ConnectionDatesBlocs extends ChangeNotifier {

  final ValueNotifier<List<Map<String, dynamic>>> client =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> account =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> reserves =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> categories =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> products =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> brands =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<List<Map<String, dynamic>>> orders =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  ConnectionDatesBlocs() {
    connectionDatesBlocsInit();
  }

  connectionDatesBlocsInit() async {
    webSocketsConnection();
    getCategories();
    getProducts();
    getBrands();
    getReserves();
    getOrders();
    getClient();
  }


  late WebSocketChannel channel;

  webSocketsConnection() async {
    channel = HtmlWebSocketChannel.connect(Uri.parse('ws:$ipPort'));
    channel.stream.listen((message) {
      switch (message) {
        case 'updates Reserves':
          getCategories();
          break;
        case 'update categories':
          getCategories();
          break;
        case 'update Products':
          getCategories();
          getProducts();
          break;
        case 'update brands':
          getBrands();
          break;
        case 'updates ordes':
          getOrders();
          break;
          case 'updates clients':
            getClient();
          break;
      }
    });
  }

  getReserves() async {
    final url = Uri.parse('http:$ipPort/get_all_reserves');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final reservesData = List<Map<String, dynamic>>.from(data);
      reserves.value = reservesData;
    }
  }

  getCategories() async {
    final url = Uri.parse('http:$ipPort/get_all_categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final categoriesData = List<Map<String, dynamic>>.from(data);
      categories.value = categoriesData;
    }
  }

  getProducts() async {
    final url = Uri.parse('http:$ipPort/get_all_products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final productsData = List<Map<String, dynamic>>.from(data);
      products.value = productsData;
    }
  }

 getBrands() async {
    final url = Uri.parse('http:$ipPort/get_all_brands');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final brandsData = List<Map<String, dynamic>>.from(data);
      brands.value = brandsData;
    }
  }

  getOrders() async {
    final url = Uri.parse('http:$ipPort/get_all_orders');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final ordersData = List<Map<String, dynamic>>.from(data);
      orders.value = ordersData;
    }
  }

  getClient() async {
    final url = Uri.parse('http:$ipPort/get_all_accounts_user_clients');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final clientsData = List<Map<String, dynamic>>.from(data);
      client.value = clientsData;
    }
  }
}
