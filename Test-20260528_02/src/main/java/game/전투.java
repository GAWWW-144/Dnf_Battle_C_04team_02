package game;

import java.util.ArrayList;
import java.util.List;

public class 전투 {
    private 플레이어 현재플레이어 = new 플레이어("hero"); 
    
    // 여러 개의 길드를 저장할 수 있도록 리스트로 관리합니다.
    private List<길드> 개설된길드목록 = new ArrayList<>();

    public 전투() {}

    public 캐릭터 캐릭터생성(String 플레이어아이디, String 캐릭터명, String 직업, int 레벨) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) return null;

        캐릭터 생성캐릭터 = null;
        if ("전사".equals(직업)) 생성캐릭터 = new 전사(캐릭터명, 레벨);
        else if ("마법사".equals(직업)) 생성캐릭터 = new 마법사(캐릭터명, 레벨);

        if (생성캐릭터 != null) 현재플레이어.캐릭터설정(생성캐릭터);
        return 생성캐릭터;
    }

    public String 몬스터공격(String 플레이어아이디, 캐릭터 공격캐릭터) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) return "에러: 플레이어 아이디 불일치";
        if (공격캐릭터 == null) return "에러: 보유한 캐릭터가 없습니다.";

        int 데미지 = 공격캐릭터.스킬발동();
        String 등급 = (데미지 >= 200) ? "S급 공격" : (데미지 >= 100) ? "A급 공격" : "B급 공격";
        String 스킬명 = (공격캐릭터 instanceof 전사) ? "검휘두르기" : "파이어볼";

        return String.format("스킬 발동: [%s] | 데미지: %d | 등급: %s", 스킬명, 데미지, 등급);
    }

    public String 아이템획득(String 플레이어아이디, 캐릭터 내캐릭터, String 아이템명, String 타입, int 가치) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) return "에러: 플레이어 아이디 불일치";
        if (내캐릭터 == null) return "에러: 캐릭터를 먼저 생성해 주세요.";

        아이템 획득아이템 = new 아이템(아이템명, 타입, 가치);
        인벤토리 인벤 = 내캐릭터.get인벤토리(); 

        if (인벤.아이템추가(획득아이템)) {
            return "획득 성공! " + 획득아이템.get아이템정보() + " [인벤: " + 인벤.get현재용량() + "/" + 인벤.get최대용량() + "]";
        } else {
            return "획득 실패: 인벤토리 공간이 꽉 찼습니다.";
        }
    }

    // 길드명을 매개변수로 받아 창설 또는 가입 처리
    public String 길드가입(String 플레이어아이디, 캐릭터 내캐릭터, String 가입할길드명) {
        if (!현재플레이어.플레이어체크(플레이어아이디)) return "에러: 플레이어 아이디 불일치";
        if (내캐릭터 == null) return "에러: 캐릭터를 먼저 생성해 주세요.";

        // 1. 이미 다른 길드에 가입되어 있는지 중복 검사
        for (길드 g : 개설된길드목록) {
            if (g.get캐릭터리스트().contains(내캐릭터)) {
                return "가입 실패: 이미 [" + g.get길드명() + "] 길드에 소속되어 있습니다.";
            }
        }

        // 2. 입력한 길드명이 존재하는지 검색
        길드 targetGuild = null;
        for (길드 g : 개설된길드목록) {
            if (g.get길드명().equals(가입할길드명)) {
                targetGuild = g;
                break;
            }
        }

        // 3. 존재하지 않는다면 새로운 길드를 창설하여 목록에 추가
        if (targetGuild == null) {
            targetGuild = new 길드(가입할길드명);
            개설된길드목록.add(targetGuild);
        }

        // 4. 길드 가입 처리
        if (targetGuild.캐릭터가입(내캐릭터)) {
            return "[" + 가입할길드명 + "] 길드 가입(창설) 완료! (현재 인원: " + targetGuild.get현재인원() + "/5)";
        } else {
            return "가입 실패: [" + 가입할길드명 + "] 길드의 정원이 가득 찼습니다.";
        }
    }

    // [에러 원인 해결] 모든 길드 목록을 JSP로 반환하는 메서드
    public List<길드> get개설된길드목록() { 
        return 개설된길드목록; 
    }
}