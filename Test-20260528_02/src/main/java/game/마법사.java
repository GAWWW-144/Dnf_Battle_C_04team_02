package game;

public class 마법사 extends 캐릭터 {

    public 마법사(String 캐릭터명, int 레벨) {
        super(캐릭터명, 레벨); // 부모 생성자 호출 시 인벤토리도 자동 생성됨
        this.hp = 레벨 * 60;
        this.공격력 = 레벨 * 25;
    }

    @Override
    public int 스킬발동() {
        // 마법사: "파이어볼" -> 데미지 = 공격력 * 2.0
        return (int) (this.공격력 * 2.0);
    }
}