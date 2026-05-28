```mermaid
classDiagram
    %% Boundary Classes
    class Create_Character_UI { <<boundary>> }
    class Attack_Monster_UI { <<boundary>> }
    class Add_Item_UI { <<boundary>> }
    class Join_Guild_UI { <<boundary>> }

    class 플레이어 {
        -id: String
        -pw: String
        -name: String
        +플레이어체크(입력id: String) boolean
    }

    class 캐릭터 {
        <<abstract>>
        #캐릭터명: String
        #레벨: int
        #hp: int
        #공격력: int
        #인벤: 인벤토리
        +캐릭터(캐릭터명, 레벨)
        +스킬발동()* int
        +get인벤토리() 인벤토리
    }

    class 전사 { +스킬발동() int }
    class 마법사 { +스킬발동() int }

    class 인벤토리 {
        -아이템리스트: List~아이템~
        -최대용량: int
        +인벤토리()
        +아이템추가(item: 아이템) boolean
        +get아이템리스트() List~아이템~
    }

    class 아이템 {
        -아이템명: String
        -타입: String
        -가치: int
        -등급: String
        +아이템(아이템명, 타입, 가치)
        -등급부여(가치: int) String
    }

    class 길드 {
        -길드명: String
        -캐릭터리스트: List~캐릭터~
        -최대인원: int
        +길드(길드명)
        +캐릭터가입(charObj: 캐릭터) boolean
    }

    class 전투 {
        -현재플레이어: 플레이어
        -개설된길드목록: List~길드~
        +전투()
        +캐릭터생성(플레이어id, 캐릭터명, 직업, 레벨) 캐릭터
        +몬스터공격(플레이어id, 공격캐릭터) String
        +아이템획득(플레이어id, 캐릭터, 아이템명, 타입, 가치) String
        +길드가입(플레이어id, 캐릭터, 길드명) String
    }

    %% Relationships
    캐릭터 <|-- 전사 : 상속
    캐릭터 <|-- 마법사 : 상속
    
    %% 합성(Composition): 캐릭터 소멸시 인벤토리/아이템도 소멸
    캐릭터 *-- 인벤토리 : 합성화 (Composition)
    인벤토리 *-- 아이템 : 합성화 (Composition)
    
    %% 집합(Aggregation): 길드 소멸해도 캐릭터는 존재함
    길드 o-- 캐릭터 : 집단화 (Aggregation)
    
    %% 의존 관계
    전투 ..> 플레이어 : 의존
    전투 ..> 캐릭터 : 의존
    전투 ..> 아이템 : 의존
    전투 ..> 길드 : 의존
    
    Create_Character_UI ..> 전투
    Attack_Monster_UI ..> 전투
    Add_Item_UI ..> 전투
    Join_Guild_UI ..> 전투
