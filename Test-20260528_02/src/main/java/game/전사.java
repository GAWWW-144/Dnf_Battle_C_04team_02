package game;

public class 전사 extends 캐릭터 {

    public 전사(String 캐릭터명, int 레벨) {
        super(캐릭터명, 레벨); // 부모 생성자 호출 시 인벤토리도 자동 생성됨
        this.hp = 레벨 * 100;
        this.공격력 = 레벨 * 15;
    }

    @Override
    public int 스킬발동() {
        // 전사: "검휘두르기" -> 데미지 = 공격력 * 1.5
        return (int) (this.공격력 * 1.5);
    }
}