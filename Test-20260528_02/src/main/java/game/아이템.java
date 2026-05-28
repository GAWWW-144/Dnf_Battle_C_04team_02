package game;

public class 아이템 {
    private String 아이템명;
    private String 타입;
    private int 가치;
    private String 등급;

    public 아이템(String 아이템명, String 타입, int 가치) {
        this.아이템명 = 아이템명;
        this.타입 = 타입;
        this.가치 = 가치;
        this.등급 = 등급부여(가치);
    }

    private String 등급부여(int 가치) {
        if (가치 >= 1000) return "전설(Legendary)";
        else if (가치 >= 500) return "희귀(Rare)";
        else return "일반(Common)";
    }

    public String get아이템정보() {
        return "[" + 등급 + "] " + 아이템명 + " (" + 타입 + ", 가치: " + 가치 + ")";
    }
}