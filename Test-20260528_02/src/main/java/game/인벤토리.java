package game;

import java.util.ArrayList;
import java.util.List;

public class 인벤토리 {
    private List<아이템> 아이템리스트;
    private final int 최대용량 = 10; // 요구사항: 인벤토리 최대 10칸

    public 인벤토리() {
        this.아이템리스트 = new ArrayList<>();
    }

    // 인벤토리에 아이템 추가 로직 (용량 체크)
    public boolean 아이템추가(아이템 item) {
        if (아이템리스트.size() < 최대용량) {
            아이템리스트.add(item);
            return true; // 획득 성공
        }
        return false; // 용량 초과로 획득 실패
    }

    // JSP 화면 출력을 위한 Getter
    public List<아이템> get아이템리스트() { return 아이템리스트; }
    public int get현재용량() { return 아이템리스트.size(); }
    public int get최대용량() { return 최대용량; }
}