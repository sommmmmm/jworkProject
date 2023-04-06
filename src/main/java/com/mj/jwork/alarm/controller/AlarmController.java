package com.mj.jwork.alarm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.mj.jwork.alarm.model.service.AlarmService;
import com.mj.jwork.alarm.model.vo.Alarm;

@Controller
public class AlarmController {
	
	@Autowired
	private AlarmService aService;
	
	@ResponseBody
	@RequestMapping(value="list.alarm", produces="application/json; charset=UTF-8")
	public String ajaxSelectAlarmList(int targetNo) {
		
		ArrayList<Alarm> list = aService.selectAlarmList(targetNo);
		int unReadCount = aService.selectUnReadCount(targetNo);
		
		Map<String, Object> alarm = new HashMap<>();
		alarm.put("list", list);
		alarm.put("unRead", unReadCount);
		
		return new Gson().toJson(alarm);
		
	}
	
	@ResponseBody
	@RequestMapping("readAlarm.al")
	public String ajaxReadAlarm(int alarmNo) {
		
		int result = aService.updateRead(alarmNo);
		
		return result > 0 ? "success" : "fail";
		
	}
	
	@ResponseBody
	@RequestMapping("deleteAlarms.al")
	public String ajaxDeleteAlarms(int targetNo) {
		
		int result = aService.deleteAlarms(targetNo);
		
		return result > 0 ? "success" : "fail";
		
	}
	
	
}
