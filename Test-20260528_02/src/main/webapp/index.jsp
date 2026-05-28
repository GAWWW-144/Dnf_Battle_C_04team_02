<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.*" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");

    전투 battle = (전투) session.getAttribute("battleSystem");
    if (battle == null) {
        battle = new 전투();
        session.setAttribute("battleSystem", battle);
    }

    String action = request.getParameter("action");
    String message = "";
    String error = "";
    String 플레이어아이디 = "hero";

    캐릭터 보유캐릭터 = (캐릭터) session.getAttribute("savedChar");

    if ("create".equals(action)) {
        String 캐릭터명 = request.getParameter("캐릭터명");
        String 직업 = request.getParameter("직업");
        int 레벨 = Integer.parseInt(request.getParameter("레벨"));

        캐릭터 생성캐릭터 = battle.캐릭터생성(플레이어아이디, 캐릭터명, 직업, 레벨);
        if (생성캐릭터 != null) {
            session.setAttribute("savedChar", 생성캐릭터);
            보유캐릭터 = 생성캐릭터;
            message = "캐릭터 생성 완료! (인벤토리가 자동으로 함께 생성되었습니다.)";
        } else {
            error = "캐릭터 생성 실패! 플레이어 아이디를 확인하세요.";
        }
    } 
    else if ("attack".equals(action)) {
        String 결과 = battle.몬스터공격(플레이어아이디, 보유캐릭터);
        if(결과.startsWith("스킬")) message = "⚔️ " + 결과; else error = 결과;
    }
    else if ("addItem".equals(action)) {
        String 아이템명 = request.getParameter("아이템명");
        String 타입 = request.getParameter("타입");
        int 가치 = Integer.parseInt(request.getParameter("가치"));
        
        String 결과 = battle.아이템획득(플레이어아이디, 보유캐릭터, 아이템명, 타입, 가치);
        if(결과.contains("성공")) message = "🎒 " + 결과; else error = 결과;
    }
    // [수정됨] 입력받은 길드명을 매개변수로 넘겨줍니다.
    else if ("joinGuild".equals(action)) {
        String 가입할길드명 = request.getParameter("길드명");
        String 결과 = battle.길드가입(플레이어아이디, 보유캐릭터, 가입할길드명);
        if(결과.contains("완료")) message = "🛡️ " + 결과; else error = 결과;
    }
    else if ("reset".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>던파 V2.0 시스템 (Composition/Aggregation)</title>
    <style>
        body { font-family: sans-serif; background: #f0f2f5; padding: 20px; }
        .container { max-width: 800px; margin: auto; }
        .box { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h3 { border-bottom: 2px solid #333; padding-bottom: 5px; margin-top:0; }
        .success { color: #0f5132; background: #d1e7dd; padding: 15px; border-radius: 5px; font-weight: bold; }
        .error { color: #842029; background: #f8d7da; padding: 15px; border-radius: 5px; font-weight: bold; }
        label { display: inline-block; width: 100px; }
        input, select { padding: 5px; margin-bottom: 10px; width: 180px; }
        button, input[type="submit"] { padding: 8px 15px; cursor: pointer; border: none; border-radius: 4px; background: #0d6efd; color: white; }
        .grid-row { display: flex; gap: 20px; }
        .col { flex: 1; }
        .item-list { background: #eee; padding: 10px; border-radius: 5px; font-size: 0.9em; min-height: 50px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🎮 던전앤파이터 배틀 시스템 V2.0</h2>

        <% if (!message.isEmpty()) { %><div class="box success"><%= message %></div><% } %>
        <% if (!error.isEmpty()) { %><div class="box error"><%= error %></div><% } %>

        <div class="grid-row">
            <div class="col">
                <div class="box">
                    <h3>1. 캐릭터 생성</h3>
                    <form method="post">
                        <input type="hidden" name="action" value="create">
                        <label>캐릭터명:</label> <input type="text" name="캐릭터명" required><br>
                        <label>직업:</label> <select name="직업"><option>전사</option><option>마법사</option></select><br>
                        <label>레벨:</label> <input type="number" name="레벨" value="1" min="1" required><br>
                        <button type="submit">생성하기</button>
                    </form>
                </div>

                <div class="box">
                    <h3>3. 길드 가입 (Aggregation)</h3>
                    <form method="post" style="margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px dashed #ccc;">
                        <input type="hidden" name="action" value="joinGuild">
                        <label>길드명:</label> 
                        <input type="text" name="길드명" placeholder="가입 또는 창설할 길드명" required><br>
                        <button type="submit" style="background:#198754; margin-top: 5px;">길드 창설 및 가입</button>
                    </form>

                    <p style="margin:5px 0; font-weight:bold;">[서버 내 길드 현황]</p>
                    <div class="item-list">
                        <% 
                            List<길드> guildList = battle.get개설된길드목록();
                            if(guildList.isEmpty()) { 
                                out.print("개설된 길드가 없습니다. 길드를 창설해 보세요!"); 
                            } else {
                                for(길드 g : guildList) {
                                    out.print("<div style='margin-bottom:10px;'>");
                                    out.print("<strong>[" + g.get길드명() + "]</strong> (정원: " + g.get현재인원() + "/5)<br>");
                                    List<캐릭터> members = g.get캐릭터리스트();
                                    
                                    if(members.isEmpty()) {
                                        out.print("<span style='color:#777; margin-left:10px;'> - 소속 인원 없음</span><br>");
                                    } else {
                                        for(캐릭터 c : members) { 
                                            String jobName = (c instanceof 전사) ? "전사" : "마법사";
                                            out.print("<span style='margin-left:10px;'> - " + c.get캐릭터명() + " (LV." + c.get레벨() + " " + jobName + ")</span><br>"); 
                                        }
                                    }
                                    out.print("</div>");
                                }
                            }
                        %>
                    </div>
                </div>

                <div class="box">
                    <h3>4. 몬스터 공격</h3>
                    <form method="post">
                        <input type="hidden" name="action" value="attack">
                        <button type="submit" style="background:#dc3545;">스킬발동 (공격)</button>
                    </form>
                </div>
            </div>

            <div class="col">
                <% if (보유캐릭터 != null) { %>
                    <div class="box" style="border-left: 5px solid #0d6efd;">
                        <h3>🛡️ 현재 캐릭터 상태</h3>
                        <p><b>이름:</b> <%= 보유캐릭터.get캐릭터명() %> (LV.<%= 보유캐릭터.get레벨() %>)</p>
                        <p><b>직업:</b> <%= (보유캐릭터 instanceof 전사) ? "전사" : "마법사" %></p>
                        <p><b>스탯:</b> HP <%= 보유캐릭터.getHp() %> / 공격력 <%= 보유캐릭터.get공격력() %></p>
                    </div>

                    <div class="box">
                        <h3>🎒 인벤토리 (Composition)</h3>
                        <form method="post" style="margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px dashed #ccc;">
                            <input type="hidden" name="action" value="addItem">
                            <label>아이템명:</label> <input type="text" name="아이템명" required><br>
                            <label>타입:</label> <select name="타입"><option>무기</option><option>방어구</option><option>물약</option></select><br>
                            <label>가치(수치):</label> <input type="number" name="가치" value="100" required><br>
                            <button type="submit" style="background:#6f42c1;">아이템 획득(루팅)</button>
                        </form>
                        
                        <p style="margin:5px 0; font-weight:bold;">[소지품 목록 <%=보유캐릭터.get인벤토리().get현재용량()%>/10]</p>
                        <div class="item-list">
                            <% 
                                List<아이템> items = 보유캐릭터.get인벤토리().get아이템리스트();
                                if(items.isEmpty()) { out.print("인벤토리가 비어있습니다."); }
                                else {
                                    for(아이템 item : items) { out.print("<li>" + item.get아이템정보() + "</li>"); }
                                }
                            %>
                        </div>
                    </div>
                <% } else { %>
                    <div class="box"><p>캐릭터를 먼저 생성해주세요.</p></div>
                <% } %>
            </div>
        </div>
        <div style="text-align: right;">
            <form method="post"><input type="hidden" name="action" value="reset"><button style="background:#333;">초기화</button></form>
        </div>
    </div>
</body>
</html>