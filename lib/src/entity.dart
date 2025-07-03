/// 게임 내 모든 엔티티(캐릭터, 몬스터)의 기본이 되는 추상 클래스
abstract class Entity {
  String name;
  int health;
  int attack;
  int defense;

  Entity(this.name, this.health, this.attack, this.defense);

  /// 상태를 보여주는 추상 메서드
  void showStatus();

  /// 공격을 수행하는 추상 메서드
  void attackEntity(Entity target);

  /// 데미지를 받는 메서드
  void takeDamage(int damage) {
    int actualDamage = (damage - defense).clamp(0, damage);
    health -= actualDamage;
    print('$name이(가) $actualDamage의 데미지를 받았습니다.');
    print('$name의 남은 체력: $health');
  }

  /// 살아있는지 확인하는 메서드
  bool isAlive() => health > 0;
}
