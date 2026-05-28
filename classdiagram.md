```mermaid
classDiagram
    class Create_Character_UI {
        <<boundary>>
        +캐릭터생성_요청()
    }

    class Attack_Monster_UI {
        <<boundary>>
        +몬스터공격_요청()
    }

    class 전투 {
        <<control>>
        -현재플레이어: 플레이어
        +플레이어가져오기() 플레이어
        +캐릭터생성(플레이어아이디: String, 캐릭터명: String, 직업: String, 레벨: int) 캐릭터
        +몬스터공격(플레이어아이디: String, 공격캐릭터: 캐릭터) String
        -등급부여(데미지: int) String
    }

    class 플레이어 {
        <<entity>>
        -플레이어아이디: String
        -보유캐릭터: 캐릭터
        +플레이어(플레이어아이디: String)
        +플레이어체크(입력아이디: String) boolean
        +캐릭터설정(생성캐릭터: 캐릭터) void
        +캐릭터가져오기() 캐릭터
        +get플레이어아이디() String
    }

    class 캐릭터 {
        <<abstract>>
        #캐릭터명: String
        #레벨: int
        #체력: int
        #공격력: int
        +캐릭터(캐릭터명: String, 레벨: int)
        +스킬발동()* int
        +get캐릭터명() String
        +get레벨() int
        +get체력() int
        +get공격력() int
    }

    class 전사 {
        +전사(캐릭터명: String, 레벨: int)
        +스킬발동() int
    }

    class 마법사 {
        +마법사(캐릭터명: String, 레벨: int)
        +스킬발동() int
    }

    %% Relationships (관계 정의)
    캐릭터 <|-- 전사 : 상속 (Inheritance)
    캐릭터 <|-- 마법사 : 상속 (Inheritance)
    
    전투 "1" *-- "1" 플레이어 : 포함 (Composition)
    플레이어 "1" o-- "0..1" 캐릭터 : 보관 (Aggregation)
