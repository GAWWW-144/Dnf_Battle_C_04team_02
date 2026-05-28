package game;

public abstract class 캐릭터 {
    protected String 캐릭터명;
    protected int 레벨;
    protected int hp;
    protected int 공격력;
    
    // [핵심] 캐릭터 소멸 시 인벤토리도 같이 소멸되는 Composition(합성화) 구조
    protected 인벤토리 인벤; 

    public 캐릭터(String 캐릭터명, int 레벨) {
        this.캐릭터명 = 캐릭터명;
        this.레벨 = 레벨;
        this.인벤 = new 인벤토리(); // 캐릭터 생성 시 인벤토리 무조건 함께 생성
    }

    public abstract int 스킬발동();

    public 인벤토리 get인벤토리() { return 인벤; }
    public String get캐릭터명() { return 캐릭터명; }
    public int get레벨() { return 레벨; }
    public int getHp() { return hp; }
    public int get공격력() { return 공격력; }
}