import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/user_bloc/user_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import '../bloc/detail_item_bloc/detail_item_bloc.dart';

class CheckoutPage extends StatefulWidget {
  final ItemModel item;

  const CheckoutPage({Key? key, required this.item}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _updateTotalPrice();
  }

  // Memperbarui harga total berdasarkan jumlah barang
  void _updateTotalPrice() {
    setState(() {
      _totalPrice = _quantity * widget.item.price;
    });
  }

  // Menambah jumlah barang
  void _incrementCounter() {
    setState(() {
      if (_quantity < widget.item.quantity) {
        _quantity += 1;
        _updateTotalPrice();
      }
    });
  }

  // Mengurangi jumlah barang
  void _decrementCounter() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
        _updateTotalPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state is BuyItemFailure) {
            showOkAlertDialog(
              context: context,
              title: "Error",
              message: state.errorMessage,
            );
          } else if (state is BuyItemSuccess) {
            showOkAlertDialog(
              context: context,
              title: "Success",
              message: "Terimakasih sudah melakukan pesanan!",
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (9 / 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: widget.item.image,
                                        width: 160,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.item.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Rp.${widget.item.price}',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove),
                                                  onPressed: _decrementCounter,
                                                ),
                                                Text(
                                                  _quantity.toString(),
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: _incrementCounter,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (9 / 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "From",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(widget.item.sellerName ?? ""),
                                  Text(widget.item.sellerEmail ?? ""),
                                  Text(widget.item.sellerAddress ?? ""),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "To",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(state.user?.name ?? ""),
                                  Text(state.user?.address ?? ""),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (9 / 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Price:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${_totalPrice.toString()}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<DetailItemBloc>().add(
                            BuyItem(
                              itemId: widget.item.id!,
                              quantity: _quantity,
                            ),
                          );
                    },
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}