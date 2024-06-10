import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import 'checkout_page.dart';

class DetailItemPage extends StatefulWidget {
  final String idItem;

  const DetailItemPage({Key? key, required this.idItem}) : super(key: key);

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state == const DetailItemState.empty()) {
            const Text("No Data");
          }
          if (state is AddItemToCartFailure) {
            showOkAlertDialog(
                context: context,
                title: "Error",
                message: 'This item is already in your cart!');
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if (state is AddItemToCartSuccess) {
            showOkAlertDialog(
                context: context,
                title: "Success",
                message: "Item yang kamu pilih sudah dimasukkan ke keranjang :)");
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemSuccess) {
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemFailure) {
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          }
        },
        child: BlocBuilder<DetailItemBloc, DetailItemState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Hero(
                                  tag: state.item?.id ?? "",
                                  child: CachedNetworkImage(
                                    imageUrl: state.item?.image ?? "",
                                    width: MediaQuery.of(context).size.width * (2 / 3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        state.item?.name ?? "",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                                      ),
                                      Text('Rp.${state.item?.price.toString() ?? ""}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Menambahkan jarak antar SizedBox
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (9 / 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    title: const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(state.item?.category ?? ""),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(state.item?.description ?? ""),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: const Text("Stock", style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(state.item?.quantity.toString() ?? ""),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Menambahkan jarak antar SizedBox
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (9 / 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    title: Text(state.item?.sellerName ?? ""),
                                    subtitle: Text(state.item?.sellerAddress ?? ""),
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
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            context.read<DetailItemBloc>().add(AddItemToCart(item: state.item!));
                          });
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Add to cart"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return CheckoutPage(item: state.item ?? ItemModel.empty);
                              }),
                            );
                          },
                          child: const Text("Buy Now"),
                        ),
                      ),
                    ],
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