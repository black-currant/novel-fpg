import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';

/// 多选
///
/// from https://medium.com/@KarthikPonnam/flutter-multi-select-choicechip-244ea016b6fa
class MultiChoiceChip extends StatefulWidget {
  final List<String> reportList;

  final Function(List<String>)? onChoiceChanged;

  const MultiChoiceChip(this.reportList, {Key? key, this.onChoiceChanged})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<MultiChoiceChip> {
  List<String> selectedChoices = [];

  _buildChips() {
    List<Widget> chips = [];
    for (var item in widget.reportList) {
      chips.add(ChoiceChip(
        label: Text(item),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        selectedColor: Theme.of(context).colorScheme.secondary,
        selected: selectedChoices.contains(item),
        onSelected: (selected) {
          setState(() {
            selectedChoices.contains(item)
                ? selectedChoices.remove(item)
                : selectedChoices.add(item);
            widget.onChoiceChanged!(selectedChoices);
          });
        },
      ));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        spacing: horizontalMargin,
        runSpacing: verticalMargin,
        children: _buildChips(),
      ),
    );
  }
}
