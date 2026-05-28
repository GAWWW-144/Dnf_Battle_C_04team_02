<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.*" %>
<%
    // Set encoding to UTF-8
    request.setCharacterEncoding("UTF-8");

    // Retrieve or create the battle controller in session to persist state
    전투 전투컨트롤러 = (전투) session.getAttribute("전투컨트롤러");
    if (전투컨트롤러 == null) {
        전투컨트롤러 = new 전투();
        session.setAttribute("전투컨트롤러", 전투컨트롤러);
    }

    String action = request.getParameter("action");
    String message = "";
    String error = "";

    // 플레이어 ID는 "hero"로 고정
    String 플레이어아이디 = "hero";

    if ("create".equals(action)) {
        String 캐릭터명 = request.getParameter("캐릭터명");
        String 직업 = request.getParameter("직업");
        int 레벨 = 1;
        
        try {
            레벨 = Integer.parseInt(request.getParameter("레벨"));
        } catch (NumberFormatException e) {
            error = "레벨은 숫자여야 합니다.";
        }

        if (error.isEmpty()) {
            // 1. 업캐스팅된 캐릭터 반환받기
            캐릭터 생성캐릭터 = 전투컨트롤러.캐릭터생성(플레이어아이디, 캐릭터명, 직업, 레벨);
            
            if (생성캐릭터 != null) {
                // 2. [핵심] 반환받은 캐릭터 객체를 session에 영구 보관
                session.setAttribute("savedChar", 생성캐릭터);
                
                message = "캐릭터가 성공적으로 생성되었습니다!<br>" +
                          "플레이어 ID: " + 플레이어아이디 + "<br>" +
                          "캐릭터명: " + 생성캐릭터.get캐릭터명() + "<br>" +
                          "직업: " + 직업 + "<br>" +
                          "레벨: " + 생성캐릭터.get레벨() + "<br>" +
                          "체력(HP): " + 생성캐릭터.get체력() + "<br>" +
                          "공격력: " + 생성캐릭터.get공격력();
            } else {
                error = "캐릭터 생성 실패! 플레이어 정보를 확인할 수 없습니다.";
            }
        }
    } else if ("reset".equals(action)) {
        // 컨트롤러와 저장된 캐릭터 모두 세션에서 삭제
        session.removeAttribute("전투컨트롤러");
        session.removeAttribute("savedChar");
        response.sendRedirect("index.jsp");
        return;
    }

    // [수정] 현재 보유 캐릭터를 세션에서 직접 가져옴
    캐릭터 보유캐릭터 = (캐릭터) session.getAttribute("savedChar");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>던전앤파이터 배틀 시스템</title>
    <style>
        body { font-family: sans-serif; margin: 30px; }
        .container { max-width: 600px; }
        .box { border: 1px solid #ccc; padding: 20px; margin-bottom: 20px; border-radius: 5px; }
        .success { color: green; font-weight: bold; background-color: #e6ffe6; padding: 10px; border: 1px solid green; border-radius: 5px; }
        .error { color: red; font-weight: bold; background-color: #ffe6e6; padding: 10px; border: 1px solid red; border-radius: 5px; }
        label { display: inline-block; width: 120px; margin-bottom: 10px; }
        input[type="text"], input[type="number"], select { padding: 5px; width: 200px; margin-bottom: 10px; }
        input[type="submit"], button { padding: 8px 15px; cursor: pointer; }
        .info { background-color: #f9f9f9; padding: 15px; border-left: 5px solid #007BFF; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🎮 던전앤파이터 배틀 시스템</h2>
        
        <% if (!message.isEmpty()) { %>
            <div class="box success"><%= message %></div>
        <% } %>
        <% if (!error.isEmpty()) { %>
            <div class="box error"><%= error %></div>
        <% } %>

        <div class="box">
            <h3>1. 캐릭터 생성 (Create Character)</h3>
            <p style="color:#666; margin-bottom: 15px;">플레이어 ID: <strong>hero</strong> (자동 지정)</p>
            <form action="index.jsp" method="post">
                <input type="hidden" name="action" value="create">
                
                <label for="캐릭터명">캐릭터명:</label>
                <input type="text" id="캐릭터명" name="캐릭터명" required><br>
                
                <label for="직업">직업:</label>
                <select id="직업" name="직업">
                    <option value="전사">전사 (HP=레벨*100, 공격력=레벨*15)</option>
                    <option value="마법사">마법사 (HP=레벨*60, 공격력=레벨*25)</option>
                </select><br>
                
                <label for="레벨">레벨:</label>
                <input type="number" id="레벨" name="레벨" value="1" min="1" required><br>
                
                <input type="submit" value="캐릭터 생성하기">
            </form>
        </div>

        <% if (보유캐릭터 != null) { %>
            <div class="box info">
                <h3>🛡️ 현재 보유 캐릭터 정보 (플레이어: hero)</h3>
                <p><strong>캐릭터명:</strong> <%= 보유캐릭터.get캐릭터명() %></p>
                <p><strong>직업:</strong> <%= (보유캐릭터 instanceof 전사) ? "전사" : "마법사" %></p>
                <p><strong>레벨:</strong> <%= 보유캐릭터.get레벨() %></p>
                <p><strong>체력(HP):</strong> <%= 보유캐릭터.get체력() %></p>
                <p><strong>공격력:</strong> <%= 보유캐릭터.get공격력() %> (<%= (보유캐릭터 instanceof 전사) ? "물리공격" : "마법공격" %>)</p>
            </div>
        <% } %>

        <div class="box">
            <h3>2. 몬스터 공격 (Attack Monster)</h3>
            <p style="color:#666; margin-bottom: 15px;">플레이어 ID: <strong>hero</strong> (자동 지정)</p>
            
            <form action="attack_result.jsp" method="post" target="attackPopup" onsubmit="window.open('', 'attackPopup', 'width=450,height=300,top=200,left=200');">
                <input type="hidden" name="attack_id" value="hero">
                
                <input type="submit" value="몬스터 공격하기 (스킬 발동)" style="background-color: #ffcc00; font-weight: bold; border: 1px solid #cc9900;">
            </form>
        </div>
        
        <div style="margin-top: 20px; text-align: right;">
            <form action="index.jsp" method="post" style="display:inline;">
                <input type="hidden" name="action" value="reset">
                <button type="submit" style="background-color: #f44336; color: white; border: none; padding: 5px 10px; border-radius: 3px;">전체 초기화 (Reset)</button>
            </form>
        </div>
    </div>
</body>
</html>