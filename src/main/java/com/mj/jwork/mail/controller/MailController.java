package com.mj.jwork.mail.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mj.jwork.alarm.controller.EchoHandler;
import com.mj.jwork.alarm.model.service.AlarmService;
import com.mj.jwork.alarm.model.vo.Alarm;
import com.mj.jwork.common.model.vo.PageInfo;
import com.mj.jwork.common.template.FileUpload;
import com.mj.jwork.common.template.Pagination;
import com.mj.jwork.common.template.SendAlarm;
import com.mj.jwork.employee.model.vo.Employee;
import com.mj.jwork.mail.model.service.MailService;
import com.mj.jwork.mail.model.vo.Mail;
import com.mj.jwork.mail.model.vo.MailAt;

@Controller
public class MailController {
	
	@Autowired
	private MailService mService;
	
	@Autowired
	private AlarmService aService;
	
	@Autowired
	private EchoHandler ec;
	
	// 메일 리스트 조회
	@RequestMapping(value="list.ma")
	public ModelAndView mailListForward(@RequestParam(value="cpage", defaultValue="1") int currentPage, Mail m, String mailBoxName, HttpSession session, ModelAndView mv) {
		
		int empNo = ((Employee)session.getAttribute("loginUser")).getEmpNo();
		m.setEmpNo(empNo);
		//System.out.println(m);
		
		int listCount = mService.selectListCount(m);
		int unReadCount = mService.selectUnReadListCount(m);
		
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 5, 10);
		
		ArrayList<Mail> mList = mService.selectMailList(m, pi);
		
		//System.out.println(mList);
		//System.out.println(mList.get(0).getMailList());
		if(m.getMailCategory().equals("사용자메일함")) {
			mv.addObject("mailBoxName", mailBoxName);
		}
		
		mv.addObject("mailCategory", m.getMailCategory())
		  .addObject("mailBoxNo", m.getMailBoxNo())
		  .addObject("listCount", listCount)
		  .addObject("unReadCount", unReadCount)
		  .addObject("pi", pi)
		  .addObject("mList", mList)
		  .setViewName("mail/mailListView");
		  
		return mv;
		
	}
	
	
	// 사용자 메일함 조회 서비스
	@ResponseBody
	@RequestMapping(value="mailBoxList.ma", produces="application/json; charset=UTF-8")
	public String ajaxSelectMailBox(int empNo) {
		
		ArrayList<Mail> mblist = mService.selectMailBoxList(empNo);
		
		return new Gson().toJson(mblist);
		
	}
	
	// 사용자 메일함 수정 서비스
	@ResponseBody
	@RequestMapping("updateMailBox.ma")
	public String ajaxUpdateMailBox(Mail m) {
		int result = mService.updateMailBox(m);
		
		return result > 0 ? "success" : "fail" ;
		
	}
	
	// 사용자 메일함 추가 서비스
	@ResponseBody
	@RequestMapping(value="insertMailBox.ma", produces="application/json; charset=UTF-8")
	public String ajaxInsertMailBox(Mail m) {
		
		int result = mService.insertMailBox(m);
		Mail mailbox = null;
		if(result > 0) {
			mailbox = mService.selectMailBox(m);
		}
		
		return new Gson().toJson(mailbox);
		
	}
	
	// 사용자 메일함 삭제 서비스
	@ResponseBody
	@RequestMapping("deleteMailBox.ma")
	public String ajaxDeleteMailBox(int mailBoxNo) {
		
		// 해당 메일함에 있는 메일 개수 Count
		int count = mService.countMailBoxMail(mailBoxNo);
		
		// 해당 메일함에 있는 메일들을 휴지통으로 이동
		int deleteMailsResult = mService.updateMailsWithMailBox(mailBoxNo);
		
		int mailBoxResult = 0;
		
		if(deleteMailsResult == count) {
			mailBoxResult = mService.deleteMailBox(mailBoxNo);
		}
		
		return mailBoxResult > 0 ? "success" : "fail";
		
	}
	
	//메일작성페이지 포워딩
	@RequestMapping("mailEnrollForm.ma")
	public String mailEnrollForm(HttpSession session, Model m) {
		
		int savedMailCount = mService.savedMailCount(((Employee)session.getAttribute("loginUser")).getEmpNo());
		
		m.addAttribute("savedMailCount", savedMailCount);
		
		return "mail/mailEnrollForm";
		
	}
	
	// 메일 이동 서비스
	@ResponseBody
	@RequestMapping("moveMail.ma")
	public String ajaxMoveMail(Mail m, @RequestParam(value="mailNoList[]") ArrayList<Integer> mailNoList) {
		
		//System.out.println(m);
		//System.out.println(mailNoList);
		int result = 1;
		for(int i=0; i<mailNoList.size(); i++) {
			//System.out.println(mailNoList.get(i));
			m.setMailNo(mailNoList.get(i));
			//System.out.println(m);
			result = result * mService.moveMail(m);
			
		}
		
		return result > 0 ? "success" : "fail";
		
	}
	
	// 메일 중요 서비스
	@ResponseBody
	@RequestMapping("important.ma")
	public String ajaxImportant(Mail m) {
		
		int result = mService.updateImportant(m);
		
		return result > 0 ? "success" : "fail";
		
	}
	
	// 메일 보내기 서비스
	@RequestMapping(value="sendMail.ma")
	public ModelAndView sendMail(Mail m, @RequestPart(value="upfile") List<MultipartFile> upfile, HttpSession session, ModelAndView mv) {
		
		// 에디터에서 빈 값을 넘기는 경우 공백으로만 두줄 넘어가는 것에 대한 오류를 막기 위한 구문
		if(m.getMailContent().trim().length() == 0) {
			m.setMailContent(m.getMailContent().trim());
		}
		//System.out.println(upfile);
		
		int mailResult = mService.sendMail(m);
		int mailAtResult = 1;
		int detailResult = 1;
		
		
		if(mailResult > 0) {
			
			if(!upfile.get(0).getOriginalFilename().equals("")) {
				for(int i=0; i<upfile.size(); i++) {
					//System.out.println(upfile.get(i).getOriginalFilename());
					String saveFilePath = FileUpload.saveFile(upfile.get(i), session, "resources/mailUploadFiles/");
					
					MailAt ma = new MailAt();
					ma.setOriginName(upfile.get(i).getOriginalFilename());
					ma.setChangeName(saveFilePath);
					
					mailAtResult = mailAtResult * mService.insertMailAt(ma);
					
				}
			}
			
			
			
			if(mailAtResult > 0) {
				Mail md = new Mail();
				if(m.getSend().equals("Y")) {
					String[] receiverArr = m.getReceiver().split(",");
					String[] receiverNoArr = m.getReceiverNo().split(",");
					
					int mailNo = 0;
					for(int i=0; i<receiverArr.length; i++) {
						
						md.setEmpNo(Integer.parseInt(receiverNoArr[i]));
						md.setEmpName(receiverArr[i]);
						md.setType("R");
						//System.out.println(md);
						mailNo = mService.insertMailDetail(md);
						
						if(mailNo > 0) {
							
							Alarm a = new Alarm();
							a.setTargetNo(md.getEmpNo());
							a.setAlarmMsg(m.getSender() + "님이 메일을 보냈습니다.");
							a.setRefNo(mailNo);
							a.setRefType("mail");
							a.setUrl("alarmDetail.ma?mailNo=" + mailNo);
							
							//System.out.println(a);
							aService.insertAlarm(a);
							
							SendAlarm.sendAlarm(a, ec.getSessionList());
							
							
						} else {
							mv.setViewName("common/errorPage");
							return mv;
						}
						
						
					}
					mv.addObject("send", "Y")
					  .addObject("mailNo", mailNo)
					  .addObject("message", "메일 전송 성공!")
					  .addObject("subMessage", "보낸 메일은 보낸 메일함에서 확인 가능합니다.");
					
					
				} else {
					mv.addObject("send", "N")
					  .addObject("message", "임시저장 성공!")
					  .addObject("subMessage", "임시저장 메일은 임시저장함에서 확인 가능합니다.");
				}
				
				md.setEmpNo(m.getSenderNo());
				md.setEmpName(m.getSender());
				md.setType("S");
				
				detailResult = detailResult * mService.insertMailDetail(md);
				
				mv.setViewName("mail/mailSuccess");
				
			} else {
				mv.setViewName("common/errorPage");
			}
			
			
		}else {
			mv.setViewName("common/errorPage");
		}
		
		
		return mv;
		
	}
	
	
	// 메일 상세페이지
	   @RequestMapping("detail.ma")
	   public ModelAndView selectMail(Mail m, String mailCategory, String mailBoxName, HttpSession session, ModelAndView mv) {
	      //System.out.println(m);
	      m.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
	      
	      int result = mService.updateMailRead(m);
	      
	      if(result > 0) {
	         Mail mi = mService.selectMail(m);
	         //System.out.println(mi);
	         mv.addObject("mi", mi).addObject("mailCategory", mailCategory).addObject("mailBoxName", mailBoxName).setViewName("mail/mailDetailView");
	         
	      } else {
	         mv.setViewName("common/errorPage");
	      }
	      
	      return mv;
	      
	   }
	
	// 메일 임시작성 페이지 포워딩
	@RequestMapping("updateForm.ma")
	public ModelAndView updateForm(Mail m, HttpSession session, ModelAndView mv) {
		
		// 임시저장 메일 불러오
		m.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
		Mail mi = mService.selectMail(m);
		
		// 임시저장 메일 개수
		int savedMailCount = mService.savedMailCount(((Employee)session.getAttribute("loginUser")).getEmpNo());
		mv.addObject("mi", mi).addObject("savedMailCount", savedMailCount).setViewName("mail/mailUpdateForm");
		
		return mv;
		
	}
	
	@RequestMapping("updateMail.ma")
	public ModelAndView updateMail(Mail m, @RequestPart(value="upfile") List<MultipartFile> upfile, String deleteAt, 
												String deleteOrigins, HttpSession session, ModelAndView mv) {
		
		//System.out.println("m : " + m);
		int result = mService.updateMail(m);
		
		
		int attachResult = 1;
		// 기존 첨부파일 있었다면
		if(result > 0 && !deleteAt.isEmpty()) {
			String deleteAtArr[] = deleteAt.split(",");
			String deleteOriginsArr[] = deleteOrigins.split(",");
			for(int i=0; i<deleteAtArr.length; i++) {
				
				attachResult = attachResult * mService.deleteMailAt(Integer.parseInt(deleteAtArr[i]));
				
				if(attachResult > 0) {
					new File(session.getServletContext().getRealPath(deleteOriginsArr[i])).delete();
				}
				
			}
		}
		
		
		int mailAtResult = 1;
		// 첨부파일 있다면
		if(!upfile.get(0).getOriginalFilename().equals("")) {
			
			for(int i=0; i<upfile.size(); i++) {
				//System.out.println(upfile.get(i).getOriginalFilename());
				String saveFilePath = FileUpload.saveFile(upfile.get(i), session, "resources/mailUploadFiles/");
				
				MailAt ma = new MailAt();
				ma.setOriginName(upfile.get(i).getOriginalFilename());
				ma.setChangeName(saveFilePath);
				ma.setMailNo(m.getMailNo());
				mailAtResult = mailAtResult * mService.insertMailAt(ma);
				
			}
		}
				
		if(mailAtResult > 0){
			// 메일 전송이었다면
			if(m.getSend().equals("Y")) {
				Mail md = new Mail();
				md.setMailNo(m.getMailNo());
				int detailResult = 1;
				String[] receiverArr = m.getReceiver().split(",");
				String[] receiverNoArr = m.getReceiverNo().split(",");
				
				for(int i=0; i<receiverArr.length; i++) {
					
					md.setEmpNo(Integer.parseInt(receiverNoArr[i]));
					md.setEmpName(receiverArr[i]);
					md.setType("R");
					//System.out.println("md : " + md);
					detailResult = detailResult * mService.insertMailDetail(md);
					Alarm a = new Alarm();
					a.setTargetNo(md.getEmpNo());
					a.setAlarmMsg(m.getSender() + "님이 메일을 보냈습니다.");
					a.setRefNo(m.getMailNo());
					a.setRefType("mail");
					a.setUrl("alarmDetail.ma?mailNo=" + m.getMailNo());
					
					// 알람 테이블 insert
					aService.insertAlarm(a);
					// 메세지 보내는 구문
					SendAlarm.sendAlarm(a, ec.getSessionList());
					
					
				}
				if(detailResult > 0) {
					mv.addObject("send", "Y")
					  .addObject("message", "메일 전송 성공!")
					  .addObject("subMessage", "보낸 메일은 보낸 메일함에서 확인 가능합니다.")
					  .setViewName("mail/mailSuccess");
				}else {
					mv.setViewName("common/errorPage");
				}
				
			// 다시 임시저장이었다면
			} else {
				mv.addObject("send", "N")
				  .addObject("message", "임시저장 성공!")
				  .addObject("subMessage", "임시저장 메일은 임시저장함에서 확인 가능합니다.")
				  .setViewName("mail/mailSuccess");
			}
		} else {
			mv.setViewName("common/errorPage");
		}
				
		
		return mv;
		
	}
	
	
	@RequestMapping("search.ma")
	public ModelAndView searchMail(@RequestParam(value="cpage", defaultValue="1") int currentPage, Mail m, ModelAndView mv, HttpSession session) {
		
		m.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
		int listCount = mService.selectListCount(m);
		int unReadCount = mService.selectUnReadListCount(m);
		
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 5, 10);
		
		ArrayList<Mail> mList = mService.selectMailList(m, pi);
		
		mv.addObject("mailCategory", "검색결과")
		  .addObject("listCount", listCount)
		  .addObject("unReadCount", unReadCount)
		  .addObject("pi", pi)
		  .addObject("mList", mList)
		  .addObject("condition", m.getCondition())
		  .addObject("keyword", m.getKeyword())
		  .setViewName("mail/mailListView");
		  
		return mv;
		
	}
	
	// 메일 이동 서비스
	@ResponseBody
	@RequestMapping("deleteMail.ma")
	public String ajaxDeleteMail(Mail m, @RequestParam(value="mailNoList[]") ArrayList<Integer> mailNoList) {
		
		//System.out.println(m);
		//System.out.println(mailNoList);
		int result = 1;
		for(int i=0; i<mailNoList.size(); i++) {
			//System.out.println(mailNoList.get(i));
			m.setMailNo(mailNoList.get(i));
			//System.out.println(m);
			result = result * mService.deleteMail(m);
			
		}
		
		return result > 0 ? "success" : "fail";
		
	}
		
	// 메일 답장
	@RequestMapping("reply.ma")
	public String replyMail(Mail m, Model model, HttpSession session) {
		//System.out.println();
		// 임시저장 메일 개수
			int savedMailCount = mService.savedMailCount(((Employee)session.getAttribute("loginUser")).getEmpNo());
		model.addAttribute("reply", m).addAttribute("savedMailCount", savedMailCount);
		
		return "mail/mailEnrollForm";
		
	}
	
	// 메일 발송취소
	@ResponseBody
	@RequestMapping("cancelSend.ma")
	public String ajaxCancelSend(Mail m) {
		int result = mService.cancelSend(m);
		
		if(result > 0) {
			Alarm a = new Alarm();
			a.setRefNo(m.getMailNo());
			a.setTargetNo(m.getEmpNo());
			aService.deleteAlarm(a);
		}
		
		return result > 0 ? "success" : "fail";
	}
	
	@ResponseBody
	@RequestMapping("readMail.ma")
	public String ajaxReadMail(Mail m, @RequestParam(value="mailNoList[]") ArrayList<Integer> mailNoList, String readDateList) {
		//System.out.println(m);
		//System.out.println("read : " + readDateList);
		
		String[] readDateArr = readDateList.split(",");
		int datelength = readDateArr.length;
		
		int result = 1;
		for(int i=0; i<mailNoList.size(); i++) {
			//System.out.println(mailNoList.get(i));
			m.setMailNo(mailNoList.get(i));
			if(i < datelength) {
				m.setReadDate(readDateArr[i]);
			}
			//System.out.println(m);
			result = result * mService.updateMailRead(m);			
		}
		
		return result > 0 ? "success" : "fail";
		
	}
	
	@RequestMapping("alarmDetail.ma")
	public ModelAndView alarmDetail(Mail m, HttpSession session, ModelAndView mv) {
		
		m.setEmpNo(((Employee)session.getAttribute("loginUser")).getEmpNo());
		
		Mail mailStatus = mService.checkMailStatus(m);
		//System.out.println(mailStatus);
		//System.out.println(mailStatus.getCancel());
		// 발송취소된 메일 아닐때
		if(mailStatus.getCancel().equals("N")) {
			mailStatus.setRead("Y");
			int result = mService.updateMailRead(mailStatus);
			//System.out.println(result);
			if(result > 0) {
				Mail mi = mService.selectMail(mailStatus);
				// 삭제하지 않은 메일
				if(mailStatus.getStatus().equals("Y")) {
					// 사용자메일함에 들어있지 않을 때
					if(mailStatus.getMailBoxName() == null) {
						mv.addObject("mi", mi).addObject("mailCategory", "받은메일함").setViewName("mail/mailDetailView");
					} else {
						mv.addObject("mi", mi).addObject("mailCategory", "사용자메일함").addObject("mailBoxName", mailStatus.getMailBoxName()).setViewName("mail/mailDetailView");
					}
					
				} else if(mailStatus.getStatus().equals("N")){
					mv.addObject("mi", mi).addObject("mailCategory", "휴지통").setViewName("mail/mailDetailView");
				} else {
					session.setAttribute("errorMsg", "삭제된 메일은 확인할 수 없습니다.");
					mv.setViewName("redirect:/home.jwork");
				}
				
			}else {
				session.setAttribute("errorMsg", "조회 실패");
				mv.setViewName("common/errorPage");
			}
		
		}else {
			session.setAttribute("errorMsg", "발송 취소되어 확인할 수 없습니다.");
			mv.setViewName("redirect:/home.jwork");
		}
		return mv;
	}
	
	
}
