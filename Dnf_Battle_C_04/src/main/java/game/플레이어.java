package game;

public class 플레이어 {
    private String 플레이어아이디;
    private 캐릭터 보유캐릭터;

    public 플레이어(String 플레이어아이디) {
        this.플레이어아이디 = 플레이어아이디;
    }

    public boolean 플레이어체크(String 입력아이디) {
        return this.플레이어아이디.equals(입력아이디);
    }

    public void 캐릭터설정(캐릭터 생성캐릭터) {
        this.보유캐릭터 = 생성캐릭터;
    }

    public 캐릭터 캐릭터가져오기() {
        return this.보유캐릭터;
    }

    public String get플레이어아이디() {
        return 플레이어아이디;
    }
}