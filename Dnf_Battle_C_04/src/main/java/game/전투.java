package game;

public class 전투 {
    private 플레이어 현재플레이어 = new 플레이어("hero"); // 기본 플레이어의 아이디는 hero

    public 플레이어 플레이어가져오기() {
        return 현재플레이어;
    }

    public 캐릭터 캐릭터생성(String 플레이어아이디, String 캐릭터명, String 직업, int 레벨) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) {
            return null; // 플레이어 체크 실패
        }

        캐릭터 생성캐릭터 = null;
        
        // [업캐스팅 적용] 자식 객체를 생성하여 부모 타입(캐릭터)에 담음
        if ("전사".equals(직업)) {
            생성캐릭터 = (캐릭터) new 전사(캐릭터명, 레벨);
        } else if ("마법사".equals(직업)) {
            생성캐릭터 = (캐릭터) new 마법사(캐릭터명, 레벨);
        }

        if (생성캐릭터 != null) {
            현재플레이어.캐릭터설정(생성캐릭터);
        }
        return 생성캐릭터;
    }

    // [수정] 세션에 보관된 캐릭터를 전달받아 공격하도록 매개변수(공격캐릭터) 추가
    public String 몬스터공격(String 플레이어아이디, 캐릭터 공격캐릭터) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) {
            return "플레이어 ID가 일치하지 않습니다. (플레이어 ID는 hero여야 합니다.)";
        }

        if (공격캐릭터 == null) {
            return "보유한 캐릭터가 없습니다. 캐릭터를 먼저 생성해 주세요.";
        }

        // 다형성을 통한 스킬 발동
        int 데미지 = 공격캐릭터.스킬발동();
        String 등급 = 등급부여(데미지);
        String 스킬명 = (공격캐릭터 instanceof 전사) ? "검휘두르기" : "파이어볼";

        return String.format("스킬 발동: [%s] | 데미지: %d | 등급: %s", 스킬명, 데미지, 등급);
    }

    private String 등급부여(int 데미지) {
        if (데미지 >= 200) {
            return "S급공격";
        } else if (데미지 >= 100) {
            return "A급공격";
        } else {
            return "B급공격";
        }
    }
}