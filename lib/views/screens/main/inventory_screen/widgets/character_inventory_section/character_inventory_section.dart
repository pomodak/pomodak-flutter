import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_inventory_section/character_card.dart';
import 'package:provider/provider.dart';

enum SortOrder { ascending, descending }

enum SortType { name, grade, id }

class CharacterInventorySection extends StatefulWidget {
  const CharacterInventorySection({super.key});

  @override
  State<CharacterInventorySection> createState() =>
      _CharacterInventorySectionState();
}

class _CharacterInventorySectionState extends State<CharacterInventorySection> {
  SortOrder _nameSortOrder = SortOrder.ascending;
  SortOrder _gradeSortOrder = SortOrder.ascending;
  SortOrder _idSortOrder = SortOrder.ascending;

  SortType _selectedSort = SortType.grade;

  List<CharacterInventoryModel> _sortedInventory = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sortedInventory =
        List.from(Provider.of<MemberViewModel>(context).characterInventory);
    _sortByGrade();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "캐릭터",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // 다음 버전에서 추가 예정
              // InkWell(
              //   onTap: () => showCollectionModal(context),
              //   borderRadius: BorderRadius.circular(8),
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              //     child: Text("📚 도감 보기",
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              //   ),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildSortButton(SortType.grade, '등급순', _gradeSortOrder),
              const SizedBox(width: 8),
              _buildSortButton(SortType.name, '이름순', _nameSortOrder),
              const SizedBox(width: 8),
              _buildSortButton(SortType.id, '획득순', _idSortOrder),
            ],
          ),
        ),
        _sortedInventory.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('캐릭터 인벤토리가 비어있습니다.'),
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: _sortedInventory.length,
                itemBuilder: (context, index) {
                  return CharacterCard(
                      characterInventory: _sortedInventory[index]);
                },
              ),
      ],
    );
  }

  void _resetSortOrder() {
    _nameSortOrder = SortOrder.ascending;
    _gradeSortOrder = SortOrder.ascending;
    _idSortOrder = SortOrder.ascending;
  }

  void _sortByName() {
    if (_nameSortOrder == SortOrder.ascending) {
      _resetSortOrder();
      _sortedInventory
          .sort((a, b) => a.character.name.compareTo(b.character.name));
      _nameSortOrder = SortOrder.descending;
    } else {
      _sortedInventory
          .sort((a, b) => b.character.name.compareTo(a.character.name));
      _nameSortOrder = SortOrder.ascending;
    }
    setState(() {});
  }

  void _sortByGrade() {
    if (_gradeSortOrder == SortOrder.ascending) {
      _resetSortOrder();
      _sortedInventory.sort(
          (a, b) => a.character.grade.index.compareTo(b.character.grade.index));
      _gradeSortOrder = SortOrder.descending;
    } else {
      _sortedInventory.sort(
          (a, b) => b.character.grade.index.compareTo(a.character.grade.index));
      _gradeSortOrder = SortOrder.ascending;
    }
    setState(() {});
  }

  void _sortByInventoryId() {
    if (_idSortOrder == SortOrder.ascending) {
      _resetSortOrder();
      _sortedInventory.sort(
          (a, b) => a.characterInventoryId.compareTo(b.characterInventoryId));
      _idSortOrder = SortOrder.descending;
    } else {
      _sortedInventory.sort(
          (a, b) => b.characterInventoryId.compareTo(a.characterInventoryId));
      _idSortOrder = SortOrder.ascending;
    }
    setState(() {});
  }

  Widget _buildSortButton(SortType type, String label, SortOrder sortOrder) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSort = type;
          switch (type) {
            case SortType.name:
              _sortByName();
              break;
            case SortType.grade:
              _sortByGrade();
              break;
            case SortType.id:
              _sortByInventoryId();
              break;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _selectedSort == type ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              _selectedSort != type
                  ? null
                  : sortOrder == SortOrder.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
              size: 14,
              color: Colors.black,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
