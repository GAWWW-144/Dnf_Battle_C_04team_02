package game;
import java.util.ArrayList;
import java.util.List;

public class 길드 {
    private String 길드명;
    private List<캐릭터> 캐릭터리스트; // Aggregation (캐릭터 객체 참조 보관)
    private final int 최대인원 = 5;

    public 길드(String 길드명) {
        this.길드명 = 길드명;
        this.캐릭터리스트 = new ArrayList<>();
    }

    public boolean 캐릭터가입(캐릭터 c) {
        // 이미 가입된 캐릭터인지 중복 체크
        if (캐릭터리스트.contains(c)) {
            return false;
        }

        // 정원이 남았을 때만 추가
        if (캐릭터리스트.size() < 최대인원) {
            캐릭터리스트.add(c);
            return true;
        }
        return false;
    }

    public String get길드명() { return 길드명; }
    public int get현재인원() { return 캐릭터리스트.size(); }
    
    // [추가됨] UI에 길드원 목록을 출력하기 위해 리스트를 반환하는 Getter
    public List<캐릭터> get캐릭터리스트() { return 캐릭터리스트; }
}