package game;

public class 전사 extends 캐릭터 {
    public 전사(String 캐릭터명, int 레벨) {
        super(캐릭터명, 레벨);
        this.체력 = 레벨 * 100;
        this.공격력 = 레벨 * 15;
    }

    @Override
    public int 스킬발동() {
        return (int) (this.공격력 * 1.5);
    }
}