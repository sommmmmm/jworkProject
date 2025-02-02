<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<!-- jquery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- fullcalendar CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<!-- fullcalendar 언어 CDN -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<script>

    document.addEventListener('DOMContentLoaded', function(){
        
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            
            //initialView: 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본설정:달)
            height:'700px', // calendar 높이 설정
            expendRows:true, // 화면에 맞게 높이 재설정
            //aspectRatio:1.35;, // 가로세로비율정해줌. 창 크기에따라 달라지는 비율 유지
            //plugins: ['interaction', 'dayGrid'],

            header: {
                left: '',
                center: 'prev, title, next',
                right:'',
            },
            titleFormat: function(date){
                return date.date.year + '년' + (parseInt(date.date.month) + 1) + '월';
            },
            defualtDate: new Date(), // 미지정시 현재날짜
            nowIndicator: true, // 현재 시간 마크
            navLinks:false, // 달력상의 날짜를 클릭할 수 있는지 여부, 클릭시 일 달력/주 달력으로 넘어감(Boolean, default:false/Demo)
            /*
            navLinkDayClick: function(date.jsEvent){
                console.log('day',date.toISOString());
                console.log('coords',jsEvent.pageX,jsEvent.pageY);
                // 달력날짜숫자를 클릭했을때 어떤 행동을 하게 할건지 설정해주는 메뉴
            }
            */
            //editable:false, // 기존에입력되어있는 event를 드래그로 움직일 수 있도록 해주는 설정
            //selectable:true, // 달력날짜를 드래그해서 여러날짜를 지정할 수 있다
            eventLimit:true, // 달력상에 셀 크기보다 많은 이벤트가 등록되어 있는 경우 'more'로 표기함(Boolean, default:false)
            locale: 'ko', // 한국어설정
            /*
            eventAdd: function(obj){ 
                // 이벤트가 추가되면 발생하는 이벤트
            },
            eventChange: function(obj){
                // 이벤트가 수정되면 발생하는 이벤트
            },
            eventRemove: function(obj){
                // 이벤트가 삭제되면 발생하는 이벤트
            },
            */
           events:
           [
           /*
            {
                    //title: String, 이벤트에 표시될제목,
                    //start: Date object, 이벤트 시작 날짜(& 시간),
                    //end: Date object, 이벤트 종료 날짜(& 시간),
                    //groupid: String, 이벤트그룹, 이벤트 드래그/리사이징 할 경우 동일한 그룹 이벤트들은 자동으로 같이 수정됨,
                    //editable: Boolean, 이벤트 드래그, 리사이징 등의 편집여부를 설정함(default:false)
                    
                    title:'[강백호]' + ' ' + '연차',
                    color:'rgb(39, 174, 96)',
                    textColor:'white',
                    start:'2023-03-07'
            }
            */
            $(function(){
                    $.ajax({
                        url:"adminAllList.le",
                        dataType:"JSON",
                        type:"GET",
                        success:function(list){
                            console.log(list);
                            /*
                            value = "{"
                            for(i=0; i<list.length-1; i++){
                                value += "title : [" + list[i].empName + "] " + list[i].lcName + ","
                                       + "color : 'rgb(39, 174, 96)',"
                                       + "textColor: 'white',"
                                       + "start : " + list[i].leaveStart 
                                       + "}, "
                            }

                            for(i=list.length-1; i<list.length; i++){
                                value += "title : [" + list[i].empName + "] " + list[i].lcName + ","
                                       + "color : 'rgb(39, 174, 96)',"
                                       + "textColor: 'white',"
                                       + "start : " + list[i].leaveStart 
                                       + "}"
                            }
                            */
                            //console.log(value);
                            for(i=0; i<list.length; i++){
                                calendar.addEvent({
                                    title: "[" + list[i].empName + "] " + list[i].lcName ,
                                    start: list[i].leaveStart,
                                    end: list[i].leaveEnd,
                                    color:'rgb(39, 174, 96)',
                                    textColor:'white'
                                })
                            }
                            
                        },
                        error:function(){
                            console.log("전체휴가캘린더 ajax통신 실패");
                        }
                    })
                })

            ]
        
    });

    calendar.render();
});
</script>
<title>Insert title here</title>
<style>
    /* outer영역 */
    .leaveOuter{
        padding:50px;
        margin:auto;
    }
    /* content영역 */
    .AllLeaveList{
        margin-top: 30px;
    }
    #calendar{
        max-width:900px;
        margin:0 auto;
    }
    /*xxx년x월 제목*/
    .fc .fc-toolbar-title {
        color: rgb(63, 69, 65);
        font-size: 30px;
        font-weight: 600;
    }
    /*요일*/
    .fc-col-header-cell-cushion {
        color: rgb(50, 50, 50);
        font-size:15px;
        font-weight: 500;
    }
    .fc-col-header-cell-cushion:hover {
        text-decoration: none;
        color: rgb(50, 50, 50);
    }
    /*일자*/
    .fc-daygrid-day-number{
        color: rgb(50, 50, 50);
        font-size:12px;
    }
    .fc-daygrid-day-number:hover{
        color: rgb(50, 50, 50);
    }
    
    /*종일제목*/
    .fc-event-title.fc-sticky{
        
    }
    /*more버튼*/ 
    .fc-daygrid-more-link.fc-more-link{
        color: rgb(50, 50, 50);
    }
    /*일정시간*/
    .fc-daygrid-event > .fc-event-time{
        color:rgb(122, 134, 127);
    }
    /*시간제목*/
    .fc-daygrid-dot-event > .fc-event-title{
        color:rgb(50, 50, 50) !important; /*나중에 바꿀 예정*/
    }
    /*가로 줄 - 월달력 종일 or 복수일자*/
    .fc-h-event{

    }
    /*세로 줄 - 주달력, 일달력*/
    .fc-v-event{
        
    }
    /*title 옆에 점*/
    .fc-daygrid-event-dot{
        
    }
    /*month/week/day*/
    .fc .fc-button-primary {
        border-color: rgb(39, 174, 96);
        background-color: white;
        color: rgb(39, 174, 96);
        font-size:13px;
        width: 45px;
    }  
    .fc .fc-button-primary:hover {
        border-color: rgb(39, 174, 96);
        background-color: rgb(39, 174, 96);
        color: white;
    }
    .fc .fc-button-active:active {
        border-color: rgb(39, 174, 96);
        background-color: rgb(39, 174, 96);
        color: white;
    }  
    .fc-button-active {
        border-color: rgb(39, 174, 96)  		!important;
        background-color: rgb(39, 174, 96) 	!important;
        color: white 				            !important;
        /* font-weight: bold 			 !important; */
    }
    .fc .fc-button:active {
        border-color: rgb(39, 174, 96)  !important;
        background-color: white         !important;
        color: rgb(39, 174, 96)         !important;
    }
    .fc .fc-button-primary:disabled{
        background-color: rgb(39, 174, 96);
        border-color: rgb(39, 174, 96);
    }
    .fc .fc-non-business {
        background-color: rgb(245, 249, 246);
    }
    .fc-list-table a {
        color: rgb(50, 50, 50);
    }
</style>
</head>
<body>

    <jsp:include page = "../common/menubar.jsp" />
    <div class="leaveOuter">

        <h4><b>휴가</b></h4>

        <div class="AllLeaveList">
            <div id="calendar"></div>
        </div>
    </div>
</body>
</html>