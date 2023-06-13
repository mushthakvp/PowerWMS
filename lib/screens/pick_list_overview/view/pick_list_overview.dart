import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/screens/pick_list_overview/view/widgets/dropdown.dart';
import '../../../models/base_response.dart';
import '../../../models/stock_mutation.dart';
import '../../../providers/add_product_provider.dart';
import '../../../providers/stockmutation_needto_process_provider.dart';
import '../../../repository/stock_mutation_repository.dart';
import '../../../util/widget/popup.dart';
import '../../pick_list_view/model/pick_list_model.dart';
import '../../picklist_product_screen/widgets/scan_form.dart';
import '../model/pick_list_line_model.dart';
import '../provider/mutation.dart';
import '../provider/pick_list_overview_provider.dart';

class PickListOverViewV2 extends StatefulWidget {
  const PickListOverViewV2({Key? key, required this.data}) : super(key: key);
  final PickListNew data;

  @override
  State<PickListOverViewV2> createState() => _PickListOverViewV2State();
}

class _PickListOverViewV2State extends State<PickListOverViewV2> {
  List<PickListLineV2> _picklistLines = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPicklistLines();
    });
  }

  void _fetchPicklistLines() async {
    setState(() {
      isLoading = true;
    });
    final provider = context.read<PickListOverviewProvider>();
    _picklistLines = await provider.getPickListLine(id: widget.data.id ?? 0);
    log("Picklist Lines: ${_picklistLines.length}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mutationRepository = context.read<StockMutationRepository>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_horizontal.png',
              width: size.width * 0.23,
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              widget.data.uid ?? '',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            SizedBox(width: size.width * 0.1),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  PickDropDown(widget.data),
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AddProductProvider>(
                        create: (_) => AddProductProvider(),
                      ),
                      ChangeNotifierProvider<MutationProviderV2>(
                        create: (_) => MutationProviderV2.create(
                          _picklistLines.first,
                          [],
                          // [],
                          [],
                        ),
                      ),
                      StreamProvider<Map<int, StockMutation>?>(
                        create: (_) =>
                            mutationRepository.getStockMutationsStream(
                                _picklistLines.first.picklistId ?? 0),
                        initialData: null,
                        catchError: (_, err) {
                          return null;
                        },
                      ),
                    ],
                    child: Column(
                      children: [
                        ScanForm(
                          onParse: (process) {
                            print("process");
                            log(process.toString());
                            // if (process &&
                            //     InternetState.shared.connectivityAvailable()) {
                            //   _onProcessHandler(provider, context);
                            // }
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void _onProcessHandler(MutationProviderV2 provider, BuildContext context) {
    context
        .read<StockMutationRepository>()
        .saveMutation(provider.getStockMutation())
        .then((value) {
      if (value.success) {
        provider.clear();
        Navigator.of(context).pop();
        context
            .read<StockMutationNeedToProcessProvider>()
            .changePendingMutation(isPending: false);
      } else {
        if (value.message == "No Internet") {
          showErrorAlert(
            title: value.message,
            message: 'Saving Locally',
            onClose: () {
              provider.clear();
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
            },
          );
        } else {
          showErrorAlert(message: value.message);
        }
      }
    }).catchError((error) {
      var response = error as BaseResponse;
      showErrorAlert(message: response.message);
    });
  }
}
