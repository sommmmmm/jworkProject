package com.mj.jwork.approval.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mj.jwork.alarm.controller.EchoHandler;
import com.mj.jwork.alarm.model.service.AlarmService;
import com.mj.jwork.alarm.model.vo.Alarm;
import com.mj.jwork.approval.model.service.ApprovalService;
import com.mj.jwork.approval.model.vo.AppLine;
import com.mj.jwork.approval.model.vo.Approval;
import com.mj.jwork.common.model.vo.PageInfo;
import com.mj.jwork.common.template.FileUpload;
import com.mj.jwork.common.template.Pagination;
import com.mj.jwork.common.template.SendAlarm;
import com.mj.jwork.employee.model.vo.Employee;



@Controller
public class ApprovalController {
	
	@Autowired
	private ApprovalService aService;
	
	@Autowired
	private AlarmService alarmService;
	
	@Autowired
	private EchoHandler ec;
	
	// 내 결제 리스트 조회 페이징
	@RequestMapping("mylist.app")
	public String selectList() {
		return "approval/myApprovalList";
	}
	
	// 결재문서 작성 form 페이지
	@RequestMapping("enrollForm.app")
	public String ApprovalEnrollForm() {
		return "approval/approvalEnrollForm";
	}
	
	// 내 결재 리스트 버튼 조회 클릭시
	@ResponseBody
	@RequestMapping(value="btnList.app", produces="application/json; charset=utf-8")
	public String ajaxSelectBtn(Approval a, @RequestParam(value="cpage", defaultValue="1") int currentPage,Model model, HttpServletRequest request) {
		
		int listCount = aService.selectListCount(a); //페이징 매길 전체 게시글 수
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		
		ArrayList<Approval> list = aService.ajaxSelectBtn(pi,a);
		
		HashMap<String, Object> map = new HashMap();
		map.put("listCount", listCount);
		map.put("pi", pi);
		map.put("list", list);
		
		return new Gson().toJson(map);
		
	}
	
	
	// 내결재문서 상세 조회 페이지
	@RequestMapping("myDetail.app")
	public ModelAndView approvalDetail(int no, ModelAndView mv) {
		Approval a = aService.selectApproval(no);
		ArrayList<AppLine> al = aService.selectAppLine(no);
		
		mv.addObject("a",a).setViewName("approval/myApprovalDetail");
		mv.addObject("al",al).setViewName("approval/myApprovalDetail");
		
		//System.out.println(a);
		
		return mv;
	}
	
	//상신 취소 페이지
	@RequestMapping("cancelForm.app")
	public String approvalCancleForm(int no, Model model) {
		model.addAttribute("a",aService.selectApproval(no));
		return "approval/approvalCancleForm";
	}
	
	//결재문서 삭제하기(첨부파일 삭제 추가해야됨)
	@RequestMapping("delete.app") 
	public String deleteApproval(int no, HttpSession session, Model model){
		//System.out.println(no);
		int result = aService.deleteApproval(no);
		session.setAttribute("alertMsg","문서가 삭제되었습니다.");
		return "redirect:mylist.app";
		
//		if(result>0) {
//			//삭제 성공했을 경우 첨부파일이 있을때
//			if(!filePath.equals("")) {
//				new File(session.getServletContext().getRealPath(filePath)).delete();
//			}
//			
//			
//		}else { // 삭제실패
//			model.addAttribute("errorMsg", "문서 삭제 실패");
//			return "common/errorPage";
//		}
	}
	
	
	// 미결재 리스트 조회 페이징
	@RequestMapping("unsignlist.app")
	public String selectUnsignList(Approval a,HttpSession session,@RequestParam(value="cpage", defaultValue="1") int currentPage,Model model, HttpServletRequest request) {
		
		a.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
		
		int listCount = aService.selectUnsignListCount(a); //페이징 매길 전체 게시글 수
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		ArrayList<Approval> list = aService.selectUnsignList(pi,a); // 게시글 목록 조회
		
		model.addAttribute("pi",pi);
		model.addAttribute("list",list);
		model.addAttribute("listCount",listCount);
		
		return "approval/unsignApprovalList";
		
	}
	
	// 미결재문서 상세 조회 페이지
	@RequestMapping("unsignDetail.app")
	public ModelAndView unsignDetail(int no, ModelAndView mv, HttpSession session) {
		Approval a = aService.selectApproval(no);
		ArrayList<AppLine> al = aService.selectAppLine(no);
		int check = 0;
		for(int i=0; i<al.size(); i++) {
			
			if(al.get(i).getEmpNo() != ((Employee)session.getAttribute("loginUser")).getEmpNo()) {
				check += 1;
			}
			
		}
		// 상신취소된 결재일 때
		if(check == al.size()) {
				session.setAttribute("errorMsg", "상신 취소된 문서는 조회할 수 없습니다.");
				mv.setViewName("redirect:/home.jwork");
				
			} else {
				mv.addObject("a",a).setViewName("approval/unsignApprovalDetail");
				mv.addObject("al",al).setViewName("approval/unsignApprovalDetail");
			}
		
		return mv;
	}
	
		
	// 결재 리스트 조회 페이징
	@RequestMapping("signlist.app")
	public String selectSignList(@RequestParam(value="cpage", defaultValue="1") int currentPage,Model model, HttpServletRequest request) {
		
		Employee e = (Employee)request.getSession().getAttribute("loginUser");
		
		int listCount = aService.selectSignListCount(e.getEmpNo()); //페이징 매길 전체 게시글 수
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		ArrayList<Approval> list = aService.selectSignList(pi,e.getEmpNo()); // 게시글 목록 조회
		
		model.addAttribute("pi",pi);
		model.addAttribute("list",list);
		model.addAttribute("listCount",listCount);
		
		//System.out.println(list);
		
		return "approval/signApprovalList";
		
	}
	
	// 결재문서 상세 조회 페이지
	@RequestMapping("signDetail.app")
	public ModelAndView signDetail(int no, ModelAndView mv) {
		Approval a = aService.selectApproval(no);
		ArrayList<AppLine> al = aService.selectAppLine(no);
		
		mv.addObject("a",a).setViewName("approval/signApprovalDetail");
		mv.addObject("al",al).setViewName("approval/signApprovalDetail");
		
		//System.out.println(al);
		
		return mv;
	}
			
		
	// 임시보관함 리스트 조회 페이징
	@RequestMapping("draftList.app")
	public String selectdraftList(@RequestParam(value="cpage", defaultValue="1") int currentPage,Model model, HttpServletRequest request) {
		
		Employee e = (Employee)request.getSession().getAttribute("loginUser");
		
		int listCount = aService.selectdraftListCount(e.getEmpNo()); //페이징 매길 전체 게시글 수
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		ArrayList<Approval> list = aService.selectdraftList(pi,e.getEmpNo()); // 게시글 목록 조회
		
		model.addAttribute("pi",pi);
		model.addAttribute("list",list);
		model.addAttribute("listCount",listCount);
		
		//System.out.println(list);
		
		return "approval/appDraftboxList";
		
	}
	
	//임시저장함 문서 수정 페이지
	@RequestMapping("draftForm.app")
	public String approvalDraftForm(int no, Model model) {
		//System.out.println(no);
		model.addAttribute("a",aService.selectApproval(no));
		return "approval/appDraftboxForm";
	}

	//결재 승인
	@RequestMapping("signBtn.app")
	public String approvalSign(AppLine al,HttpSession session, Model model) {
		//System.out.println(al.getAppNo());
		//승인 버튼 누른 후 app_line변경
		int result1 = aService.signBtn(al);
		
		if(result1>0) {
			int result2 = aService.signStatus(al.getAppNo());
			
			Approval app = aService.selectAppInfo(al.getAppNo());
			Alarm alarm = new Alarm();
			
			// 결재가 완료되었을 때
			if(app.getAppStatus().equals("결재완료")) {
				alarm.setTargetNo(app.getEmpNo());
				alarm.setAlarmMsg("(" + app.getDocNo() + ")문서가 결재 완료되었습니다.");
				alarm.setRefNo(app.getAppNo());
				alarm.setRefType("approval");
				alarm.setUrl("myDetail.app?no=" + app.getAppNo());
			
			// 다음 결재자가 존재할 경우
			}else {
				alarm.setTargetNo(app.getTargetNo());
				alarm.setAlarmMsg("결재할 문서가 도착했습니다. (" + app.getDocNo() + ")");
				alarm.setRefNo(app.getAppNo());
				alarm.setRefType("approval");
				alarm.setUrl("unsignDetail.app?no=" + app.getAppNo());
			}
			
			
			alarmService.insertAlarm(alarm);
			
			SendAlarm.sendAlarm(alarm, ec.getSessionList());
			
			session.setAttribute("alertMsg","승인 완료 되었습니다.");
			return "redirect:unsignlist.app";
		}else {// 승인 실패
			model.addAttribute("errorMsg", "문서 승인 실패");
			return "common/errorPage";
			
		}
	}
	
	//결재반려
	@RequestMapping("returnBtn.app")
	public String approvalReturn(AppLine al,HttpSession session, Model model) {
		//System.out.println(al);
		//승인 버튼 누른 후 app_line변경
		int result1 = aService.returnBtn(al);
		
		if(result1>0) {
			int result2 = aService.returnStatus(al.getAppNo());
			
			Approval app = aService.selectAppInfo(al.getAppNo());
			Alarm alarm = new Alarm();
			
			alarm.setTargetNo(app.getEmpNo());
			alarm.setAlarmMsg("(" + app.getDocNo() + ")문서가 반려되었습니다.");
			alarm.setRefNo(app.getAppNo());
			alarm.setRefType("approval");
			alarm.setUrl("myDetail.app?no=" + app.getAppNo());
				
			
			alarmService.insertAlarm(alarm);
			
			SendAlarm.sendAlarm(alarm, ec.getSessionList());
			
			
			
			session.setAttribute("alertMsg","반려 완료 되었습니다.");
			return "redirect:unsignlist.app";
		}else {// 승인 실패
			model.addAttribute("errorMsg", "문서 반려 실패");
			return "common/errorPage";
			
		}
	}
	
	//임시저장
	@RequestMapping("saveApp.app")
	public String saveApproval(Approval a, MultipartFile upfile, HttpSession session, Model model) {
		//System.out.println(a);
		//System.out.println(upfile);
		
		if(!upfile.getOriginalFilename().equals("")) {
			
			if(a.getDocOriginName()!= null) {
				new File(session.getServletContext().getRealPath(a.getDocFilePath())).delete();
			}
			
			
			String saveFilePath = FileUpload.saveFile(upfile,session,"resources/uploadFiles/");
			
			a.setDocOriginName(upfile.getOriginalFilename());
			a.setDocFilePath(saveFilePath);
			
		}
		
		int result = aService.saveApproval(a);
		
		if(result>0) {
			session.setAttribute("alertMsg","임시저장 되었습니다.");
			return "redirect:draftList.app";
		}else {// 임시저장 실패
			model.addAttribute("errorMsg", "임시저장 실패");
			return "common/errorPage";
			
		}
				
	}
	
	//새문서 insert
	@RequestMapping("insertNewApp.app")
	public String insertNewApp(Approval a, MultipartFile upfile, HttpSession session, Model model) {
		//System.out.println(a);
		//System.out.println(a.getAlist());
		//System.out.println(a.getRlist());
		
		a.setAppCount(a.getAlist().size());
		
		
		if(!upfile.getOriginalFilename().equals("")) {
			String saveFilePath = FileUpload.saveFile(upfile,session,"resources/uploadFiles/");
			a.setDocOriginName(upfile.getOriginalFilename());
			a.setDocFilePath(saveFilePath);
		}
		
		int result = aService.insertNewApp(a);
		
		
		if(result>0) {
			int newAppNo = aService.selectCurrentAppNo();
			Approval app = aService.selectAppInfo(newAppNo);
			Alarm alarm = new Alarm();
			alarm.setTargetNo(app.getTargetNo());
			alarm.setAlarmMsg("결재할 문서가 도착했습니다. (" + app.getDocNo() + ")");
			alarm.setRefNo(app.getAppNo());
			alarm.setRefType("approval");
			alarm.setUrl("unsignDetail.app?no=" + app.getAppNo());
			
			alarmService.insertAlarm(alarm);
			
			SendAlarm.sendAlarm(alarm, ec.getSessionList());
			
			
			session.setAttribute("alertMsg","문서가 등록 되었습니다.");
			return "redirect:mylist.app";
		}else {// 문서등록 실패
			model.addAttribute("errorMsg", "문서등록 실패");
			return "common/errorPage";
			
		}
	}
	
	//상신취소, 임시저장form에서의 임시저장
	@RequestMapping("resaveApp.app")
	public String resaveApproval(Approval a, MultipartFile reupfile, HttpSession session, Model model) {
		System.out.println(a);
		//System.out.println(upfile);
		
		if(!reupfile.getOriginalFilename().equals("")) {
			
			if(a.getDocOriginName()!= null) {
				new File(session.getServletContext().getRealPath(a.getDocFilePath())).delete();
			}
			
			String saveFilePath = FileUpload.saveFile(reupfile,session,"resources/uploadFiles/");
			
			a.setDocOriginName(reupfile.getOriginalFilename());
			a.setDocFilePath(saveFilePath);
			
		}		
		
		int resultLine = aService.deleteLine(a);
		
		if(resultLine>0) {
			int result = aService.resaveApproval(a);
			session.setAttribute("alertMsg","임시저장 되었습니다.");
			return "redirect:draftList.app";
		}else {// 문서등록 실패
			model.addAttribute("errorMsg", "문서등록 실패");
			return "common/errorPage";
			
		}
				
	}

	
	//임시저장함에서의 재결재
		@RequestMapping("insertDrafbox.app")
		public String insertDrafbox(Approval a, MultipartFile reupfile, HttpSession session, Model model) {
			//System.out.println(a);
			//System.out.println(a.getAlist());
			//System.out.println(a.getRlist());

		a.setAppCount(a.getAlist().size());
		
		if(!reupfile.getOriginalFilename().equals("")) {
			
			if(a.getDocOriginName()!= null) {
				new File(session.getServletContext().getRealPath(a.getDocFilePath())).delete();
			}
			
			String saveFilePath = FileUpload.saveFile(reupfile,session,"resources/uploadFiles/");
			
			a.setDocOriginName(reupfile.getOriginalFilename());
			a.setDocFilePath(saveFilePath);
			
	
		}
		
		int result = aService.insertDrafbox(a);
		
		if(result>0) {
			
			Approval app = aService.selectAppInfo(a.getAppNo());
			Alarm alarm = new Alarm();
			alarm.setTargetNo(app.getTargetNo());
			alarm.setAlarmMsg("결재할 문서가 도착했습니다. (" + app.getDocNo() + ")");
			alarm.setRefNo(app.getAppNo());
			alarm.setRefType("approval");
			alarm.setUrl("unsignDetail.app?no=" + app.getAppNo());
			
			alarmService.insertAlarm(alarm);
			
			SendAlarm.sendAlarm(alarm, ec.getSessionList());
			
			session.setAttribute("alertMsg","문서가 등록 되었습니다.");
			return "redirect:mylist.app";
		}else {// 문서등록 실패
			model.addAttribute("errorMsg", "문서등록 실패");
			return "common/errorPage";
			
		}

	}
		
	//상신 취소 후 재결재
	@RequestMapping("reinsert.app")
	public String reinsertApp(Approval a, MultipartFile reupfile, HttpSession session, Model model) {
		System.out.println(a);
		System.out.println(a.getAlist());
		//System.out.println(a.getRlist());

		a.setAppCount(a.getAlist().size());
		
		if(!reupfile.getOriginalFilename().equals("")) {
			
			if(a.getDocOriginName()!= null) {
				new File(session.getServletContext().getRealPath(a.getDocFilePath())).delete();
			}
			
			String saveFilePath = FileUpload.saveFile(reupfile,session,"resources/uploadFiles/");
			
			a.setDocOriginName(reupfile.getOriginalFilename());
			a.setDocFilePath(saveFilePath);
			
		}
		
		int resultLine = aService.deleteLine(a);
		
		if(resultLine>0) {
			int result = aService.reinsertApp(a);
			session.setAttribute("alertMsg","문서가 등록 되었습니다.");
			return "redirect:mylist.app";
		}else {// 문서등록 실패
			model.addAttribute("errorMsg", "문서등록 실패");
			return "common/errorPage";
			
		}

	}
	
	// 참조문서 리스트 조회 페이징
	@RequestMapping("reflist.app")
	public String selectRefList(@RequestParam(value="cpage", defaultValue="1") int currentPage,Model model, HttpServletRequest request) {
		
		Employee e = (Employee)request.getSession().getAttribute("loginUser");
		
		int listCount = aService.selectRefListCount(e.getEmpNo()); //페이징 매길 전체 게시글 수
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		ArrayList<Approval> list = aService.selectRefList(pi,e.getEmpNo()); // 게시글 목록 조회
		
		model.addAttribute("pi",pi);
		model.addAttribute("list",list);
		model.addAttribute("listCount",listCount);
		
		//System.out.println(list);
		
		return "approval/referenceList";
		
	}
	
	// 참조문서 상세 조회 페이지
	@RequestMapping("refDetail.app")
	public ModelAndView refDetail(int no, ModelAndView mv) {
		Approval a = aService.selectApproval(no);
		ArrayList<AppLine> al = aService.selectAppLine(no);
		
		mv.addObject("a",a).setViewName("approval/refApprovalDetail");
		mv.addObject("al",al).setViewName("approval/refApprovalDetail");
		
		//System.out.println(al);
		
		return mv;
	}
	
	//검색
	@RequestMapping("search.app")
	public ModelAndView searchAppList(@RequestParam(value="cpage", defaultValue="1") int currentPage, Approval a, ModelAndView mv, HttpSession session) {
		
		a.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
	
		int listCount = aService.selectUnsignListCount(a);
		
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		
		ArrayList<Approval> list = aService.selectUnsignList(pi, a);
		
		//addObject("mailCategory", "검색결과")
		mv.addObject("listCount", listCount)
		  .addObject("pi", pi)
		  .addObject("list", list)
		  .addObject("condition", a.getCondition())
		  .addObject("keyword", a.getKeyword())
		  .setViewName("approval/unsignApprovalList");
		System.out.println(mv);  
		
		return mv;
		
	}
		
		


}


