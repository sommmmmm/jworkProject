<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	div{
        box-sizing: border-box;
    }
    .content{
        margin: auto; 
        padding:4%
    }
	  .approval-area{
	     width: 859px;
	     border:1px solid black;
	     height: 800px;
	 }
	
	 #selectApproval {
		 font-size: small;
		 text-align: center;
		 width: 300px;
		 display: inline-block;
		 border: 1px solid lightgray;
	 }
       #selectApproval td{
		 border: 1px solid lightgray;
	 }
	 #selectApproval th{
	     background-color: rgb(237, 237, 237);
         border: 1px solid lightgray;
	     height: 40px;
	 }
	
	 #selectApprovalLine{
	     width: 450px;
	     font-size: small;
	     display: inline-block;
	     border: 1px solid lightgray;
	     text-align: center;
	 }
     #selectApprovalLine th, #selectApprovalLine td{
	     border: 1px solid lightgray;
	 }
	
	 #returnFont{
		 color: red;
		 font-size: x-large
	 }
	
	 .appContent{
	     width: 754px;
	 }
     .appContent th{
	     text-align:center;
	     font-size: small;
	     border: 1px solid lightgray;
	 }
     .appContent td{
	     font-size: small;
	     border: 1px solid lightgray;
         padding-left: 10px;
         overflow: auto;
	 }
	
	 #appThead{
	     background:rgb(237, 237, 237);
	     width:129px;
	     height: 27px;
	 }
	
	 #indate{
	     width:248px;
	 }

     .signLogo{
        width: 60px;
    }
	
	 #buttonarea{
		 display: inline-block;
		 width: 750px;
	 }
    
    
    
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp"/>

        <h4><b>내 결재 문서</b></h4>
        <br>
        <div class="approval-area" align="center"  style="height: auto;">
        <c:choose>
	       	<c:when test="${ a.docType eq 0 }">
       			<br><br>
           		<h2><b>기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서 </b></h2>
       		</c:when>
       		<c:when test="${ a.docType eq 1 }">
       			<br><br>
          			<h2><b>품&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;의&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서 </b></h2>
       		</c:when>
	        <c:otherwise>
	        	<br><br>
	            <h2><b>사&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서 </b></h2>
	        </c:otherwise>
       	</c:choose>
            <br>
            <table id="selectApproval" border="1">
                <tr>
                    <th style="width:140px">문서번호</th>
                    <td width="180px">${ a.docNo }</td>
                </tr>
                <tr>
                    <th>기 안 자</th>
                    <td>
                        ${ a.empName }
                    </td>
                </tr>
                <tr>
                    <th>기 안 일</th>
                    <td>
                        ${ a.createDate }
                    </td>
                </tr>

            </table>
            <table  id="selectApprovalLine" border="1">
	                <tr>
	                    <th width="90px" rowspan="3"style="text-align:center; background:rgb(237, 237, 237);">결재</th>
	                    <td height="25px" width="90px"> ${ loginUser.jobName }</td>
		        	<c:forEach var="al" items="${ al }">
		                    <td width="90px">${ al.jobName }</td>
		            </c:forEach>
		            <c:choose>
		            	<c:when test="${al.size()== 1}">
		            		<td width="90px"></td>
		            		<td width="90px"></td>
		            	</c:when>
		            	<c:when test="${al.size()== 2}">
		            		<td width="90px"></td>
		            	</c:when>
		            </c:choose>
	                </tr>
	            
	                <tr>
	                    <td height="70px"><img class="signLogo" src="resources/images/approval/approved.png"/></td>
                    <c:forEach var="al" items="${ al }">
	                    <td width="90px">
	                    	<c:choose>
	                    		<c:when test="${al.confirmStatus eq 1 }">
	                    				<img class="signLogo" src="resources/images/approval/approved.png"/>
	                    			</c:when>
	                   				<c:when test="${al.confirmStatus eq 2 }">
	                    				<a id="returnFont" data-toggle="tooltip" title="${al.reReason }">
											<img class="signLogo" src="resources/images/approval/cancel.png"/>
										</a>
	                    			</c:when>
	                   	 	</c:choose>
	                   	 </td>
		            </c:forEach>
		           <c:choose>
		            	<c:when test="${al.size()== 1}">
		            		<td width="90px"></td>
		            		<td width="90px"></td>
		            	</c:when>
		            	<c:when test="${al.size()== 2}">
		            		<td width="90px"></td>
		            	</c:when>
		            </c:choose>
	                </tr>
	               
	                <tr>
	                    <td height="25px">${ loginUser.empName }</td>
	                <c:forEach var="al" items="${ al }">
	                    <td>${ al.empName }</td>
	                </c:forEach>
	                <c:choose>
		            	<c:when test="${al.size()== 1}">
		            		<td width="90px"></td>
		            		<td width="90px"></td>
		            	</c:when>
		            	<c:when test="${al.size()== 2}">
		            		<td width="90px"></td>
		            	</c:when>
		            </c:choose>
	                </tr>
	                
            </table>
            <script>
                $(document).ready(function(){
                  $('[data-toggle="tooltip"]').tooltip();   
                });
            </script>

           <br><br>
            <table class="appContent" border="1">
                 <!--사직서 양식이면 년도표 나오게-->
                 <c:if test="${ a.docType eq 2 }">
	                <tr align="center">
	                    <th id="appThead">입사년도</th>
	                    <td id="indate">${loginUser.enrollDate}</td>
	                    <th id="appThead">퇴사 예정일</th>
	                    <td id="indate">${ a.quitDate }</td>
	                </tr>
                </c:if>
                <tr>
                    <th id="appThead" >제목</th>
                    <td width="624px" colspan="3">${a.docTitle }</td>
                </tr>
                <tr>
                    <th style="background-color:rgb(237, 237, 237); height: 380px;">내용</th>
                    <td colspan="3" style="vertical-align : top; padding: 10px;" >${a.docContent }</td>
                </tr>
                <tr>
                    <th id="appThead">첨부파일</th>
                    <td colspan="3" style="text-align: left;">
                    <c:choose>
                    	<c:when test="${ not empty a.docOriginName }">	
                    		<a href="${ a.docFilePath }" download="${a.docOriginName}">${a.docOriginName}</a>
                   		</c:when>
                   		<c:otherwise>
                   			첨부파일이 없습니다.
                   		</c:otherwise>
                   	</c:choose>	
                   	</td>
                </tr>

            </table>
            <br>
        	<c:if test="${ a.appStatus eq '결재대기' or a.appStatus eq '진행중'}">
            <div id="buttonarea" align="right">
                <button type="button" class="btn btn-light" onclick="cancleFormSubmit();">상신취소</button>
            </div>
            </c:if>
            <br>
            <br>
            <form action="" method="post" id="cancleForm">
            	<input type="hidden" name="no" value="${ a.appNo }">
            </form>
            
            <script>
            	function cancleFormSubmit(){
            		$("#cancleForm").attr("action","cancelForm.app").submit();
            	}
            </script>
 
        </div> <!--end of approval-area-->

    </div><!--end of outer-->
    </div>
    </div>
    </div>

</body>
</html>