package game;

public abstract class 캐릭터 {
    protected String 캐릭터명;
    protected int 레벨;
    protected int 체력;
    protected int 공격력;

    public 캐릭터(String 캐릭터명, int 레벨) {
        this.캐릭터명 = 캐릭터명;
        this.레벨 = 레벨;
    }

    public abstract int 스킬발동();

    // Getters for UI display
    public String get캐릭터명() { return 캐릭터명; }
    public int get레벨() { return 레벨; }
    public int get체력() { return 체력; }
    public int get공격력() { return 공격력; }
}