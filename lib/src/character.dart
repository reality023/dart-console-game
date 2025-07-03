import 'entity.dart';

/// 플레이어 캐릭터 클래스
class Character extends Entity {
  bool _isDefending = false;
  bool _hasUsedItem = false;
  int _originalAttack = 0;
  bool _isItemActive = false;

  Character(String name, int health, int attack, int defense)
      : super(name, health, attack, defense) {
    _originalAttack = attack;
  }

  /// 아이템 사용 가능 여부 확인
  bool canUseItem() => !_hasUsedItem;

  /// 아이템 사용
  void useItem() {
    if (_hasUsedItem) {
      print('\n이미 아이템을 사용했습니다!');
      return;
    }

    _hasUsedItem = true;
    _isItemActive = true;
    attack = _originalAttack * 2;
    print('\n$name이(가) 아이템을 사용하여 이번 턴에 공격력이 두 배가 됩니다!');
    print('현재 공격력: $attack');
  }

  @override
  void attackEntity(Entity target) {
    print('\n$name의 공격!');
    target.takeDamage(attack);
    _isDefending = false;

    if (_isItemActive) {
      attack = _originalAttack;
      _isItemActive = false;
      print('아이템 효과가 종료되었습니다.');
      print('현재 공격력: $attack');
    }
  }

  /// 방어 상태로 전환
  void defend() {
    _isDefending = true;
    print('\n$name이(가) 방어 태세를 취했습니다.');
  }

  @override
  void takeDamage(int damage) {
    if (_isDefending) {
      print('\n$name이(가) 방어에 성공했습니다!');
      health += damage; // 방어 성공 시 데미지만큼 체력 회복
      print('$name의 체력이 $damage만큼 회복되었습니다.');
      print('현재 체력: $health');
    } else {
      super.takeDamage(damage);
    }
    _isDefending = false;
  }

  @override
  void showStatus() {
    print('\n=== $name의 상태 ===');
    print('체력: $health');
    print('공격력: $attack');
    print('방어력: $defense');
    print('==================\n');
  }
}
