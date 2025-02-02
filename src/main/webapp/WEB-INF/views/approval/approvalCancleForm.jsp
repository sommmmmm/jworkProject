<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- include summernote css/js-->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<!-- 조직도 트리 -->
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<link rel="stylesheet" type="text/css" href="resources/css/treeview/jquery.treeview.css"/>


<style>
	 .content{
        margin: auto; 
        padding:4%
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
    
    #appMsg {
        font-size: smaller;
        width: 800px;
        text-align: right;
    }

    #buttonarea{
        display: inline-block;
        width: 370px;
    }

    #appThead{
        text-align:center;
        background:rgb(237, 237, 237);
        width:130px;
        font-size: small;
    }
    #indate{
        width:249px;
        font-size: small;
        text-align:center;
    }
    #returnFont{
        color: red;
        font-size: x-large
    }

    .approvalLine-area{
        border: 1px solid black;
        border-radius: 5%;
        width: 300px;
        padding:15px;
        margin: auto;
        overflow: auto;     
             
    }
    .approvalLine-button{
        width: 100px;
    }
    .modal-body div{
        float: left;
        height: 300px;
    }
    .modal-body{
        margin: auto;
    }
    
    #selectAppLineTB, #selectRefLineTB{
        margin: auto;
        text-align: center;
        width: 265px;
    }
    .signLogo{
        width: 60px;
    }

    .deptName{
        padding-left: 15px;
        font-size: small;
    }
    .empName{
        padding-left: 20px;
        display:none;
        list-style: none;
        font-size: small;
    }
    #tree{
            font-size: 14px;
        }
    
   .emp:hover{
       cursor: pointer;
   }

   .click {
        font-weight:bolder;
        color: green;
    }
   
   .employeeChart{
  	   border: 1px solid black;
       border-radius: 5%;
       width: 300px;
       padding:5px;
       text-align: left;
       height: 300px;
       width: 300px;
       overflow: auto;
   }
   .selectAppLine{
      overflow: auto;
      height: 265px;
   }
   .employeeChart::-webkit-scrollbar{
        width: 5px; /*스크롤바의 너비*/
    }

    .approvalLine-area::-webkit-scrollbar{
        width: 2px; /*스크롤바의 너비*/
    }
    .selectAppLine::-webkit-scrollbar{
        width: 2px; /*스크롤바의 너비*/
    }
    
  #appTbody, #refTbody{
  	font-size: small;
  }

  .removeBtn{
    display: flex;
    align-items:center; 
    justify-content: center;
    height: 6px;
    width: 4px;
    font-size: 2px;
  }

 
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp"/>
       
        <h4><b>상신 취소</b></h4>
    
        <br>
        

        <form action="reinsert.app" method="post" align="center" enctype="multipart/form-data" id="approvalForm">
        <input type="hidden" name="empNo" value="${ loginUser.empNo }">
        <input type="hidden" name="appNo" value="${ a.appNo }">
        <input type="hidden" name="docType" value="${ a.docType }">
            <table id="selectApproval" border="1">
                <tr>
                    <th width="140px">문서종류</th>
                    <td width="180px"> ${ a.docNo } </td>
                        <!-- <select name="appForm" id="appForm">
                            <option value="0">기안서</option>
                            <option value="1">품의서</option>
                            <option value="2">사직서</option> 
                        </select> -->
                    
                </tr>
                <tr>
                    <th>기 안 자</th>
                    <td>
                        ${ loginUser.empName }
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
                <tr >
                    <th width="90px" rowspan="3"style="text-align:center; background:rgb(237, 237, 237);">
                        <button type="button" class="btn" data-toggle="modal" data-target="#myModal" id="chart">
                            결재
                        </button>
                    </th>
                    <td height="25px" width="90px">${ loginUser.jobName }</td>
                    <td width="90px" id="job1"></td>
                    <td width="90px" id="job2"></td>
                    <td width="90px" id="job3"></td>
                </tr>
                <tr>
                    <td height="70px"><img class="signLogo" src="resources/images/approval/approved.png"/></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td height="25px">${ loginUser.empName }</td>
                    <td id="name1"></td>
                    <td id="name2"></td>
                    <td id="name3"></td>
                </tr>
            </table>
            <p id="appMsg">* 순서대로 결재가 진행됩니다.</p>
            
          
            
            <div class="approvalContent quit" align="center">
                <br>
                <c:choose>
	       			<c:when test="${ a.docType eq 0 }">
	       				<div class="approvalContent up" align="center">
			                <br>
			                <h3><b>기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</b></h3>
			                <br>
            		    </div>
	       			</c:when>
	       			<c:when test="${ a.docType eq 1 }">
	       				<div class="approvalContent request" align="center">
                			<br>
			                <h3><b>품&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;의&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</b></h3>
			                <br>
            			</div>
	       			</c:when>
	       			<c:otherwise>
	       				<h3><b>사&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</b></h3>
		                <table border="1" id="resignationAddForm">
		                    <tr>
		                        <th id="appThead">입사년도</th>
		                        <td id="indate">${ loginUser.enrollDate }</td>
		                        <th id="appThead">퇴사 예정일</th>
		                         <td id="indate"><input type="date" name="quitDate" value="${a.quitDate }" id="quitDate" ></td>
			                        <script>
			                        var today = new Date();
			      				    var threeWeeksLater = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 21);
			      				    var formattedDate = threeWeeksLater.toISOString().substr(0, 10);
			      				    document.getElementById("quitDate").min = formattedDate;
			                        </script>
		                    </tr>
		                </table>
              			<br>
	       			</c:otherwise>
	       		</c:choose>
            </div>

            <div class="approvalContent" align="center">
                <table border="1" width="759px">
                    <tr>
                        <th id="appThead" >제목</th>
                        <td ><input type="text" style="width:624px"  name="docTitle" value="${ a.docTitle }"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <textarea id="summernote" name="docContent">${ a.docContent }</textarea>
                            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
                            <script>
                            	$(document).ready(function() {
                          	  		$('#summernote').summernote({
	                           	    	placeholder: '내용을 입력하세요.',
	                          	        minHeight: 300,
	                          	        maxHeight: null,
	                          	        lang : 'ko-KR',
	                          	        toolbar: [
												// 글꼴 설정
												[ 'fontname', [ 'fontname' ] ],
												// 글자 크기 설정
												[ 'fontsize', [ 'fontsize' ] ],
												// 굵기, 기울임꼴, 밑줄,취소 선, 서식지우기
												[
														'style',
														[ 'bold', 'italic',
																'underline',
																'strikethrough',
																'clear' ] ],
												// 글자색
												[ 'color', [ 'forecolor', 'color' ] ],
												// 표만들기
												[ 'table', [ 'table' ] ],
												// 글머리 기호, 번호매기기, 문단정렬
												[ 'para',
														[ 'ul', 'ol', 'paragraph' ] ],
												// 줄간격
												[ 'height', [ 'height' ] ],
												// 그림첨부, 링크만들기, 동영상첨부
												// ['insert',['picture','link','video']],
												// 코드보기, 확대해서보기, 도움말
												[
														'view',
														[ 'codeview', 'fullscreen',
																'help' ] ] ],
												// 추가한 글꼴
												fontNames : [ 'Arial', 'Arial Black',
														'Comic Sans MS', 'Courier New',
														'맑은 고딕', '궁서', '굴림체', '굴림', '돋음체',
														'바탕체' ],
												// 추가한 폰트사이즈
												fontSizes : [ '8', '9', '10', '11', '12',
														'14', '16', '18', '20', '22', '24',
														'28', '30', '36', '50', '72' ]
                          	  			})
                          		});
                        </script>
                        </td>
                    </tr>
                    <tr>
                        <th id="appThead">첨부파일</th>
                        <td >
                        	<input type="file" id="upfile" class="form-control-file border" name="reupfile">
                        	<c:if test="${ not empty a.docOriginName }"> <!-- 기존의 첨부파일이 있을 경우 -->
	                            현재 업로드된 파일 : 
	                            <a href="${ a.docFilePath }" download="${ a.docOriginName }">${a.docOriginName}</a>
                            
                            	<input type="hidden" name="docOriginName" value="${ a.docOriginName }">
                            	<input type="hidden" name="docFilePath" value="${ a.docFilePath }">
                            </c:if>
                    </tr>
                    
                </table>
                <br>
            </div> <!--end of approvalContent -->
            
            
            
			
            <div id="buttonarea"  align="left">
                <button type="submit" class="btn btn-success" id="sbmitAppBtn" disabled='disabled'>결재</button>
            </div>

             <div id="buttonarea"  align="right">
                <button type="button" class="btn btn-light" onclick="history.back()">취소</button>
                <button type="button" class="btn btn-light" onclick="resaveBtn();">임시저장</button>
                <button type="button" class="btn btn-light" onclick="deleteSubmit();">삭제</button>
            </div>
            
            <script>
	         	//임시저장 
	         	function resaveBtn(){
	         		$("#approvalForm").attr("action","resaveApp.app").submit();
	         	}
	         
	         </script>
            

               <!-- The Modal -->
            <div class="modal fade" id="myModal">
                <div class="modal-dialog modal-lg">
                <div class="modal-content">
               
                    <!-- Modal Header -->
                    <div class="modal-header">
                    <h5 class="modal-title"><b>결재선</b></h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    
                    <!-- Modal body -->
                    <div class="modal-body">
                            
                            <div class="employeeChart">
                                 <ul id="tree" class="filetree treeview-famfamfam ">
            
                        
                                                
                                          
                                  </ul>
                                  <input type="hidden" id="appEmpNo" value="">
                                            
                           </div>

                       
                       <!-- ajax로 트리 불러오기 --> 
                        <script src="resources/js/treeview/jquery.cookie.js" type="text/javascript"></script>
           				<script src="resources/js/treeview/jquery.treeview.js" type="text/javascript"></script>
					   <script>
			                $(document).ready(function(){
			                    
			                    
			                    $(document).on("click", "#chart", function(){
			
			                        $.ajax({
			                            url: "employeeChart.emp",
			                            success: function(deptList){
			                                //console.log(deptList);
			                                let chart = "";
			                                for(let i=0; i<deptList.length; i++){
			                                    //console.log(deptList[i]);
			                                    if(deptList[i].deptName == "사장"){
			                                        chart += "<li><span class='emp' empNo='" + deptList[i].teamList[0].empList[0].empNo  +"' empName='" + deptList[i].teamList[0].empList[0].empName + "'>" 
			                                                                            + deptList[i].teamList[0].empList[0].jobName + '&nbsp;' + deptList[i].teamList[0].empList[0].empName + "</span></li>";
			                                    } else{
			                                        chart += '<li class="closed"><span class="folder">' + deptList[i].deptName + '</span>';
			                                        for(let j=0; j<deptList[i].teamList.length; j++){
			                                            if(deptList[i].teamList[j].teamName == "임원"){
			                                                for (let k=0; k<deptList[i].teamList[j].empList.length; k++){
			                                                    chart += '<ul><li><span class="emp" empNo="' + deptList[i].teamList[j].empList[k].empNo + '" empName="' + deptList[i].teamList[j].empList[k].empName + '">'
			                                                            + deptList[i].teamList[j].empList[k].jobName + '&nbsp;' + deptList[i].teamList[j].empList[k].empName + '</span></li></ul>';
			                                                }
			                                            } else{
			                                                chart += '<ul><li class="closed"><span class="folder">' + deptList[i].teamList[j].teamName + '</span>';
			                                                for(let k=0; k<deptList[i].teamList[j].empList.length; k++){
			                                                    chart += '<ul><li><span class="emp" empNo="' + deptList[i].teamList[j].empList[k].empNo +  '" empName="' + deptList[i].teamList[j].empList[k].empName + '">'
			                                                        + deptList[i].teamList[j].empList[k].jobName + '&nbsp;' + deptList[i].teamList[j].empList[k].empName + '</span></li></ul>';
			                                                }
			                                                chart+= '</li></ul>';
			
			                                            }
			                                            
			                                        }
			                                        chart += "</li>";
			                                    }
			                                    
			                                }
			                                $("#tree").html(chart);
			                                $("#tree").treeview({});
			
			                            }, error: function(){
			                                console.log("조직도 조회용 ajax 통신 실패");
			                            }
			
			                        })
			
			                    })

                                
                                //사원 선택시
                                $(document).on("click",".emp",function(){
                                   
                                    const empNo= $(this).attr("empNo");
                    
                                    //console.log(empNo);
                                    
                                    $("#appEmpNo").val(empNo);
                                   
                                    // 이전에 클릭된 엘리먼트의 색상을 원래대로 되돌립니다.
                                    $(".emp").css("color", "").css("font-weight", "normal");
  
                                    // 현재 클릭된 엘리먼트의 색상을 변경하고, #appEmpNo 엘리먼트의 값을 설정합니다.
                                    $(this).css("color", "green").css("font-weight", "bolder");

                                })

			                });
						
			                
							 $(document).on("click","#addSigner",function(){
			                	
			                	// 중복 체크를 위한 배열
			                	var addedEmpNos = [];
			                	
			                	// 이미 추가된 결재자들의 empNo를 배열에 저장
			                	$(".signEmp td:nth-child(2)").each(function() {
			                		addedEmpNos.push($(this).text());
			                	});
			                	
			                	var count = $(".signEmp").length;
			                	
			                	if(count >= 3){
			                		alert("결재자는 최대 3명까지 지정 가능합니다.");
			                		return;
			                	} else if (addedEmpNos.includes($("#appEmpNo").val())) {
			                		alert("이미 추가된 결재자입니다.");
			                		return;
			                	} else{
			                		$.ajax({
			                			url:"addSigner.app",
			                			data:{empNo:$("#appEmpNo").val()},
			                			success: function(list){
			                				let value=""
			                				value += "<tr class='signEmp'>"
			                					+ "<td style='color:red' class='removeEmp'><b>X</b></td>"
			                					+ "<td style='display:none'>"+list.empNo+"</td>"
			                					+ "<td>" + list.deptName + "</td>"
			                					+ "<td>" + list.empName + "</td>"
			                					+ "<td>" + list.jobName + "</td>"
			                					+ "<td style='display:none'>"+list.appLevel+"</td>"
			                					+ "</tr>";
			                				
			                				$("#appTbody").append(value);
			                				console.log(list);
			                				
			                				// 추가된 결재자의 empNo를 배열에 저장
			                				addedEmpNos.push(list.empNo);
			                				
			                				$(".removeEmp").click(function(){
			                					$(this).parent().remove();
			                					count--;
			                					// 결재자가 삭제될 때, 배열에서도 제거
			                					addedEmpNos = addedEmpNos.filter(function(empNo) {
			                						return empNo != list.empNo;
			                					});
			                				})
			                				
			                			}, error:function(){
			                				console.log("결재자 추가 ajax 통신실패");
			                			}
			                		})
			                	}
			                })

			                $(document).on("click","#addRefer",function(){
			                	
			                	// 중복 체크를 위한 배열
			                	var addedEmpNos = [];
			                	
			                	// 이미 추가된 참조자들의 empNo를 배열에 저장
			                	$(".refEmp td:nth-child(2)").each(function() {
			                		addedEmpNos.push($(this).text());
			                	});
			                	
			                	if (addedEmpNos.includes($("#appEmpNo").val())) {
			                		alert("이미 추가된 참조자입니다.");
			                		return;
			                	} else {
			                		$.ajax({
			                			url:"addSigner.app",
			                			data:{empNo:$("#appEmpNo").val()},
			                			success: function(list){
			                				let value=""
			                					value += "<tr class='refEmp'>"
			                						+ "<td style='color:red' class='removeRef'><b>X</b></td>"
			                						+ "<td style='display:none'>"+list.empNo+"</td>"
			                						+ "<td>" + list.deptName + "</td>"
			                						+ "<td>" + list.empName + "</td>"
			                						+ "<td>" + list.jobName + "</td>"
			                						+ "<td style='display:none'>"+list.appLevel+"</td>"
			                						+ "</tr>";
			                					
			                					$("#refTbody").append(value);
			                					console.log(list);
			                					
			                					// 추가된 참조자의 empNo를 배열에 저장
			                					addedEmpNos.push(list.empNo);
			                					
			                					$(".removeRef").click(function(){
			                						$(this).parent().remove();
			                						// 참조자가 삭제될 때, 배열에서도 제거
			                						addedEmpNos = addedEmpNos.filter(function(empNo) {
			                							return empNo != list.empNo;
			                						});
			                					})
			                					
			                				}, error:function(){
			                					console.log("결재자 추가 ajax 통신실패");
			                				}
			                				
			                			})
			                		}
			                })
                           
			            </script>
                       
                      

                        <div class="approvalLine-button">
                            <br>
                            <br>
                            <br>
                            <button type="button" class="btn btn-outline-secondary" id="addSigner">결재&gt;</button>
                            <br><br>
                            <!--<button type="button" class="btn btn-outline-secondary" id="removeEmp">&lt;제외</button>-->
                            <br><br>
                            <button type="button" class="btn btn-outline-secondary" id="addRefer">참조&gt;</button>
                        </div>

                       

                        <div class="approvalLine-area" >
                            <div class="selectAppLine">
                                <table id="selectAppLineTB" border="1">
                                    <h6 style="text-align: center;"><b>결재자</b></h6>
                                    <thead >
                                        <tr>
                                            <th width="15px"></th>
                                            <th style="display: none;"></th>
                                            <th>부서</th>
                                            <th>이름</th>
                                            <th>직급</th>
                                        </tr>
                                    </thead>
                                    <tbody id="appTbody">
                                       
                                    </tbody>
                                </table>
                                <br>
                                <table id="selectRefLineTB" border="1">
                                    <h6 style="text-align: center;"><b>참조자</b></h6>
                                    <thead>
                                        <tr>
                                            <th width="15px"></th>
                                            <th style="display: none;"></th>
                                            <th>부서</th>
                                            <th>이름</th>
                                            <th>직급</th>
                                        </tr>
                                    </thead>
                                    <tbody id="refTbody">
                                        
                                    </tbody>
                                </table>

                            </div>
                        
                        </div>
                    </div>
                    
                    <!-- Modal footer -->
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="selectApp" data-dismiss="modal">적용</button>
                    </div>
                    
                </div>
                </div>
            </div>
			<div id="app-list"></div>
        </form>
        <form action="delete.app" method="post" id="deleteBtn">
        	<input type="hidden" name="no" value=${a.appNo }>
        </form>
        <script>
        	function deleteSubmit(){
        		$("#deleteBtn").attr("action", "delete.app").submit();
        	}
        </script>
        
        <script>
			
            $(document).on("click", "#selectApp", function(){
            	
                var count = 0;

                $("#appTbody tr").each(function(){
                   
                   let no = $(this).children().eq(1).text();
                   let name = $(this).children().eq(3).text();
                   let job = $(this).children().eq(4).text();
                   console.log(count);
                   console.log(name);

                  
                   
                    if(count == 0){
                        $("#job1").text(job);
                        $("#name1").text(name);
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].empNo' value='" + no + "'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appLevel' value='1'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appNo' value='${a.appNo}'>");
                    }else if(count == 1){
                        $("#job2").text(job);
                        $("#name2").text(name);
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].empNo' value='" + no + "'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appLevel' value='2'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appNo' value='${a.appNo}'>");
                    }else if(count == 2){
                        $("#job3").text(job);
                        $("#name3").text(name);
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].empNo' value='" + no + "'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appLevel' value='3'>");
                        $("#app-list").append("<input type='hidden' name='alist[" +count + "].appNo' value='${a.appNo}'>");
                    }
                    
                    const target = document.getElementById('sbmitAppBtn');
                    target.disabled = false;
                    
                   count++;

                })
                
              

                $(document).on("click", "#chart", function() {
                    count = 0;
                    $('#job1').text('');
                    $('#job2').text('');
                    $('#job3').text('');
                    $('#name1').text('');
                    $('#name2').text('');
                    $('#name3').text('');
                    
                    const target = document.getElementById('sbmitAppBtn');
                    target.disabled = true;

                })

                
                var num = 0;
                $("#refTbody tr").each(function(){
                	let no = $(this).children().eq(1).text();
                    
                	$("#app-list").append("<input type='hidden' name='rlist[" +num + "].empNo' value='" + no + "'>");
                	++num;
                })
                
                
					
            })

        </script>
        

    </div> <!-- end of content-->
    </div>
    </div>
    </div>

</body>
</html>

