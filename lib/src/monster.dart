import 'dart:math';
import 'entity.dart';

/// 몬스터 클래스
class Monster extends Entity {
  final int maxAttackPower;
  int _turnCount = 0;

  Monster(String name, int health, this.maxAttackPower)
      : super(name, health, 0, 0) {
    // 공격력은 캐릭터의 방어력과 maxAttackPower 중 큰 값으로 설정
    attack = maxAttackPower;
  }

  /// 공격력을 설정하는 메서드
  void setAttackPower(int characterDefense) {
    attack = max(characterDefense, maxAttackPower);
  }

  @override
  void attackEntity(Entity target) {
    print('\n$name의 공격!');
    target.takeDamage(attack);
    _turnCount++;

    // 3턴마다 방어력 2 증가
    if (_turnCount % 3 == 0) {
      defense += 2;
      print('\n$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
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
