<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>

<style>
     div{box-sizing: border-box;}
     figure {
  text-align: center;
    }
   #day-select a, #reservation-table a{
        text-decoration: none;
        color: black;
    }
    .outer{
        width: 960px;
    }
    
    #carDetailView tr td{
    	 height: 30px;
    }
 .fc-toolbar-chunk *{
	 float:left!important;
	 margin-left:14px!important;
	}
	.fc-daygrid-day-frame,.fc-timegrid-axis-frame-liquid,.fc-timegrid-axis{
	display:none;
	}
  #car-updateForm th,#carDetailView th{  height: 50px;}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@6.1.4/index.global.min.js'></script>
   
    <script>
    document.addEventListener('DOMContentLoaded', function() {
    	  var calendarEl = document.getElementById('calendar');

    	  var calendar = new FullCalendar.Calendar(calendarEl, {
    		  schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
    		  expandRows: true,
    		  timeZone: 'local',
    		  selectable: true,
    		 slotMinTime: "09:00:00", // 최소시간
             slotMaxTime: "20:00:00", // 최대시간 (23시까지만 화면에 보여짐)
    	    initialView: 'resourceTimeGridDay',
    	    nowIndicator: true, 
    	    dateClick: function(info) {
              //  alert('Clicked on: ' + info.dateStr);
                // change the day's background color just for fun
              /*   info.dayEl.style.backgroundColor = '#d6dfcc'; */
               // $("#reservationForm").modal("show");
              
            },
    	    headerToolbar: {
    	    	left:'',
                center: 'prev,title,next',
               right:'today,listWeek'/* ,timeGridWeek' */
            },
            
            buttonText: {
                prev:"<",
                next:">",
                today: "오늘",
                month:"월",
                week:"주",
                day:"일",
                list: "목록",
            },
            nowIndicator: true, // 현재 시간 마크
            navLinks:false, // 달력상의 날짜를 클릭할 수 있는지 여부, 클릭시 일 달력/주 달력으로 넘어감(Boolean, default:false/Demo)
            locale: 'ko',
            day:'numeric',
            navLinks: true,
           	select:function(info){

        		$.ajax({
        			url:"detail.car",
        			data:{carName:info.resource.id},
        			success:function(c){
        				$("#carName").text(c.carName);
        				$("#reserveCarName").attr("value",c.carName);
        				$("#carImg").attr("src",c.carImg);
        				$("#carType").text(c.carType);
        				$("#gearType").text(c.gearType);
        				$("#color").text(c.color);
        				$("#maker").text(c.maker);
        				$("#fuelType").text(c.fuelType);
        				$("#modelYear").text(c.modelYear);
        				
        				if(c.status == 'Y'){
        					$("#status").text("정상").css("color","blue");
        				}else{
        					$("#status").text("고장").css("color","red");
        					$("#reserveBtn").attr("disabled",true);
        				}
        				$("span[id=etc]").text(c.etc);


        			},error:function(){
        				
        				console.log("ajax통신 실패");
        			}
        			
        		});
        		
        		$("#carDetailView").modal("show");
        		
           	},
    	    resources: [
    	      $.ajax({
    	    		url:"list.acar",
    	    		success:function(list){
    	    			for(let i=0; i<list.length; i++){
    	    				calendar.addResource({
    	    				id:list[i].carName,
    	    				title:list[i].carName,
    	    				url:list[i].carImg
    	    				})
    	    			}
    	    		}
    	    		
    	    	})
    	    ], 
    	 
                 events: [
                 	
                 ]
                 
    	  })

    	  calendar.render();
    	});
		
    
 
    	
   
    </script>
  	
</head>
<body>
   
    <jsp:include page="../common/menubar.jsp"/>
    <div style="width: 940px; margin:20px;">
        <h2>차량 예약 현황</h2>
        <hr>
         <div id='calendar' style="margin:20px;">
          
           
            </div>
        
        <div>
     
           
    </div>
      
        </div>
       



    <!-- 상세보기 -->
     <script>
            	function detailView(carName){
            		
            		$.ajax({
            			url:"detail.car",
            			data:{carName:carName},
            			success:function(c){
            				$("#carName").text(c.carName);
            				$("#reserveCarName").attr("value",c.carName);
            				$("#carImg").attr("src",c.carImg);
            				$("#carType").text(c.carType);
            				$("#gearType").text(c.gearType);
            				$("#color").text(c.color);
            				$("#maker").text(c.maker);
            				$("#fuelType").text(c.fuelType);
            				$("#modelYear").text(c.modelYear);
            				
            				if(c.status == 'Y'){
            					$("#status").text("정상").css("color","blue");
            				}else{
            					$("#status").text("고장").css("color","red");
            					$("#reserveBtn").attr("disabled",true);
            				}
            				$("span[id=etc]").text(c.etc);


            			},error:function(){
            				
            				console.log("ajax통신 실패");
            			}
            			
            		});
            	}
            
            </script>

    <!-- 차량 상세 조회 -->
    <div class="modal" id="carDetailView">
        <div class="modal-dialog">
        <div class="modal-content">
    
            <!-- Modal Header -->
            <div class="modal-header">
            <h4 class="modal-title">차량 상세 정보</h4>
            <button type="button" class="close" data-dismiss="modal" onclick=" $('#carDetailView').modal('hide');">&times;</button>
            </div>
    
            <!-- Modal body -->
            <div class="modal-body">
                <table id="carDetailView">
                    <tr >
                        <th >차량명</th>
                        <td>
                            <div class="col-10">
                            	<span id="carName"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>차량 대표 이미지</th>
                        <td>
                        	 <img id="carImg" src="<c:out value='${car.carImg}' default='resources/uploadFiles/imgAdd.png'/>"   width="100px" height="70px" readonly>
                        </td>
                    </tr>
                    <tr>
                        <th >차량종류</th>
                        <td>
                          <div class="col-10">
                         	 <span id="carType"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th >기어형식</th>
                        <td>
                           <div class="col-10">
                           	<span id="gearType"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th >차량색상</th>
                        <td>
                           <div class="col-10">
                           	<span id="color"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th >제조사</th>
                        <td>
                           <div class="col-10">
                           	<span id="maker"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th >연료형식</th>
                        <td>
                           <div class="col-10">
                           	<span id="fuelType"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th >차량연식</th>
                        <td>
                          <div class="col-10">
                          	<span id="modelYear"></span>
                            </div>
                        </td>                   
                    </tr>
                    <tr>
                        <th>설비상태</th>
                        <td>
                        	<span id="status"></span>
                            
                        </td>
                    </tr>
                    <tr>
                        <th >비고</th>
                        <td>
                        	<span id="etc"></span>
                        </td>
                    </tr>

                </table>
            </div>
    
            <!-- Modal footer -->
            <div class="modal-footer">
            	<form action="reservForm.car" method="post">
            		<input type="hidden"  name="carName" id="reserveCarName" >
            		<button type="submit" class="btn btn-sm btn-primary"  type="submit" id="reserveBtn">예약하기</button>
            	</form>
                <button type="button" class="btn btn-sm btn-light" data-dismiss="modal" onclick=" $('#carDetailView').modal('hide');">닫기</button>
            </div>
    
        </div>
        </div>
    </div>

  
</body>
</html>