<%@ page language="java" contentType=`"text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<title>Insert title here</title>
<style>
    /* outer영역 */
    .outer{
        width:960px;
        height:1000px;
        border:1px solid black;
    }
    /* 메뉴바영역 */
    .title{
        color:rgb(50,50,50);
        margin-left: 30px;
        margin-top:30px;
    }
    .selectBar{
        margin-left: 30px;
    }
    .selectBar>span{
        color:rgba(50, 50, 50, 0.79);
        font-size:15px;
        font-weight: 600;
    }
    .selectBar>div{
        margin-top:10px;
        height:3px;
        float: left;
    }
    /* content영역 */
    .enrollForm{
        margin-left:30px;
        margin-right: 30px;
        margin-top: 30px;
    }
    .header{
        display: flex;
    }
    input{
        width:100px;
        border: 1px solid rgb(170, 170, 170);
        border-radius: 5px;
    }
    textarea{
        resize: none;
        width:690px;
        height:190px;
        border:1px solid rgb(170, 170, 170);
        border-radius: 5px;
        padding:10px;
    }
    button[type=button]{
        height:30px;
        width:60px;
        border-radius: 5px;
        font-size: 12px;
        line-height: 5px;
    }
    button[type=submit]{
        width:120px;
        height:30px;
        border-radius: 5px;
        font-size: 12px;
        line-height: 5px;
    }
    .textWrap{
        margin-left: 630px;
        margin-bottom: 5px;
        font-size: 13px;
        font-weight: 600;
        color:rgb(50,50,50)
    }
</style>
</head>
<body>
    <div class="outer">

        <div class="title">
            <h3 style="color:rgb(50,50,50); font-weight: 600;">신청<h3> 
        </div>
        <br>
        <div class="selectBar">
            <span>&nbsp;출장신청</span>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>시간외 근무신청</span> 
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>신청상세</span>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:rgb(0,172,0)">출장관리</span>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:rgb(0,172,0)">시간외 근무관리</span>
            <br>
            <div style="width:395px; background: rgb(234, 234, 234);">&nbsp;</div>
            <div style="width:115px; background: rgb(170, 170, 170);">&nbsp;</div>
            <div style="width:390px; background: rgb(234, 234, 234);">&nbsp;</div>
        </div>

        <form action="" method="" class="enrollForm">

            
            <div class="body">
                <div style="display: flex;">
                    <img src="" alt="" style="width:30px; height:30px">
                    <div style="font-size: 13px; font-weight: 600; color:rgb(50,50,50); margin-top:4px; margin-left: 3px;">&nbsp;출장일정, 필요정보 입력</div>
                    <div style="background:rgb(234, 234, 234); width:700px; height:1px; margin-top:13px; margin-left: 20px;">&nbsp;</div>
                </div>

                <br>

                <div style="display: flex;">
                    <img src="" alt="" style="width:30px; height:30px">
                    <div style="font-size: 13px; font-weight: 600; color:rgb(50,50,50); margin-top:4px; margin-left: 3px;">
                        &nbsp;신청자&nbsp; <input type="text" name="" value="로그인사원이름"> 
                        &nbsp;소속&nbsp; <input type="text" name="" value="로그인사원소속"> 
                    </div>
                    <div style="background:rgb(234, 234, 234); width:550px; height:1px; margin-top:13px; margin-left: 20px;">&nbsp;</div>
                </div>

                <br>

                <div style="display: flex;">
                    <div style="font-size: 13px; font-weight: 600; color:rgb(50,50,50); margin-top:4px; margin-left: 3px;">
                        시작일&nbsp; <input type="date" name="" value="" style="width:150px; text-align: center; height:20px;"> 
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;종료일&nbsp; <input type="date" name="" value="" style="width:150px; text-align: center; height:20px;"> 
                    </div>
                    <div style="background:rgb(234, 234, 234); width:452px; height:1px; margin-top:13px; margin-left: 20px;">&nbsp;</div>
                </div>

                <br><br>
                <div class="textWrap">
                    <span class="textCount">0자</span><span class="textTotal">/200자</span>
                </div>
                <textarea name="" id="" cols="30" rows="10" placeholder="출장신청 내용을 입력해주세요."></textarea>
                <div style="float: right; margin-top:160px;">
                    <button type="button" class="btn btn-secondary">취소</button>
                    <button type="submit" class="btn btn-success">시간외근무신청</button>
                </div>

            </div>

        </form>

    </div>
</body>
</html>