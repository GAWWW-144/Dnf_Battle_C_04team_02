<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.*" %>
<%
    // 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 세션에서 전투컨트롤러 불러오기 (없으면 생성)
    전투 전투컨트롤러 = (전투) session.getAttribute("전투컨트롤러");
    if (전투컨트롤러 == null) {
        전투컨트롤러 = new 전투();
        session.setAttribute("전투컨트롤러", 전투컨트롤러);
    }

    String action = request.getParameter("action");
    String message = "";
    String error = "";

    // 플레이어 ID 고정
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
            // 업캐스팅된 캐릭터 반환받기
            캐릭터 생성캐릭터 = 전투컨트롤러.캐릭터생성(플레이어아이디, 캐릭터명, 직업, 레벨);
            
            if (생성캐릭터 != null) {
                // 세션에 영구 보관
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
    } 
    else if ("attack".equals(action)) {
        String 전달된아이디 = request.getParameter("attack_id");
        캐릭터 저장된캐릭터 = (캐릭터) session.getAttribute("savedChar");

        if (전투컨트롤러 == null || 저장된캐릭터 == null) {
            error = "보유한 캐릭터가 없습니다. 캐릭터를 먼저 생성해 주세요.";
        } else {
            // 몬스터 공격 실행
            String 결과 = 전투컨트롤러.몬스터공격(전달된아이디, 저장된캐릭터);
            
            if (결과.startsWith("스킬 발동")) {
                message = "⚔️ " + 결과;
            } else {
                error = 결과;
            }
        }
    } 
    else if ("reset".equals(action)) {
        // 초기화 처리 후 index.jsp로 리다이렉트
        session.removeAttribute("전투컨트롤러");
        session.removeAttribute("savedChar");
        response.sendRedirect("index.jsp");
        return;
    }

    // 처리된 결과 메시지를 request 객체에 담음
    if (!message.isEmpty()) request.setAttribute("message", message);
    if (!error.isEmpty()) request.setAttribute("error", error);

    // 처리가 끝났으므로 결과값을 들고 다시 메인 화면(index.jsp)으로 포워딩(이동)
    RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
    dispatcher.forward(request, response);
%>